//
//  MarkdownTextView.swift
//  MarkdownText
//
//  Created by Pedro Giuliano Farina on 03/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//
//swiftlint:disable function_body_length cyclomatic_complexity

import UIKit

public class MarkdownTextView: UITextView {

    // MARK: - Variables and Constants
    public var placeholder: String? {
        didSet {
            if textColor == .placeholderColor {
                attributedText = placeholder?.toPlaceholder()
            }
        }
    }

    internal private(set) var activeAttributes: [NSAttributedString.Key: Any] = [:]

    public internal(set) var activeFont: UIFont {
        get {
            if let font = activeAttributes[.font] as? UIFont {
                return font
            } else {
                activeAttributes[.font] = Fonts.defaultTextFont
                return Fonts.defaultTextFont
            }
        }
        set {
            activeAttributes[.font] = newValue
        }
    }
    ///Sets font value as active and adds font to selection
    public func setFont(to font: UIFont) {
        activeFont = font
        changeTextPreservingRange(to: attributedText.withExtraAttribute((.font, activeFont), in: selectedRange))
    }

    public internal(set) var isBold: Bool {
        get {
            return activeFont.hasTrait(.traitBold)
        }
        set {
            if newValue {
                if let boldFont = activeFont.bold() {
                    activeFont = boldFont
                }
            } else {
                activeFont = activeFont.removeTrait(.traitBold)
            }
        }
    }
    ///Sets bold value as active and adds/removes bold to selection
    public func setBold(_ value: Bool) {
        isBold = value
        changeTextPreservingRange(to: attributedText.withExtraAttribute((.font, activeFont), in: selectedRange))
    }

    public internal(set) var isItalic: Bool {
        get {
            return activeFont.hasTrait(.traitItalic)
        }
        set {
            if newValue {
                if let italicFont = activeFont.italic() {
                    activeFont = italicFont
                }
            } else {
                activeFont = activeFont.removeTrait(.traitItalic)
            }
        }
    }
    ///Sets italic value as active and adds/removes italic to selection
    public func setItalic(_ value: Bool) {
        isItalic = value
        changeTextPreservingRange(to: attributedText.withExtraAttribute((.font, activeFont), in: selectedRange))
    }

    public internal(set) var color: UIColor {
        get {
            if let color = activeAttributes[.foregroundColor] as? UIColor {
                return color
            } else {
                activeAttributes[.foregroundColor] = UIColor.black
                return .black
            }
        }
        set {
            activeAttributes[.foregroundColor] = newValue
        }
    }
    ///Sets color value as active and adds color to selection
    public func setColor(_ color: UIColor) {
        self.color = color
        changeTextPreservingRange(to: attributedText.withExtraAttribute((.foregroundColor, color), in: selectedRange))
    }

    public internal(set) var isHighlighted: Bool {
        get {
            if let color = activeAttributes[.backgroundColor] as? UIColor {
                return color != .clear
            } else {
                activeAttributes[.backgroundColor] = UIColor.clear
                return false
            }
        }
        set {
            let value: UIColor
            if newValue {
                value = .highlightColor ?? .systemYellow
            } else {
                value = .clear
            }
            activeAttributes[.backgroundColor] = value
        }
    }
    ///Sets highlight value as active and adds/removes highlight to selection
    public func setHighlighted(_ value: Bool) {
        isHighlighted = value
        if let backgroundColor = activeAttributes[.backgroundColor] as? UIColor {
            changeTextPreservingRange(to: attributedText.withExtraAttribute((.backgroundColor, backgroundColor), in: selectedRange))
        }
    }

    public internal(set) var isUnderlined: Bool {
        get {
            return activeAttributes[.underlineStyle] != nil
        }
        set {
            if newValue {
                activeAttributes[.underlineStyle] = NSNumber.init(value: NSUnderlineStyle.single.rawValue)
            } else {
                activeAttributes[.underlineStyle] = nil
            }
        }
    }
    ///Sets underline value as active  and adds/removes underline to selection
    public func setUnderlined(_ value: Bool) {
        isUnderlined = value
        if value {
            let underlineNumber = NSNumber.init(value: NSUnderlineStyle.single.rawValue)
            changeTextPreservingRange(to: attributedText.withExtraAttribute((.underlineStyle, underlineNumber), in: selectedRange))
        } else {
            changeTextPreservingRange(to: attributedText.removeAttribute(.underlineStyle, in: selectedRange))
        }
    }

    public private(set) var animator: UIDynamicAnimator?
    public internal(set) var isShowingPlaceholder: Bool = true

    // MARK: - Initializers

    public init(frame: CGRect) {
        super.init(frame: frame, textContainer: nil)
        setup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    public func setText(_ attributedText: NSAttributedString?) {
        isShowingPlaceholder = false
        self.attributedText = attributedText
    }

    private func setup() {
        self.markdownDelegate = MarkdownTextViewDelegate()
        self.delegate = markdownDelegate
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .backgroundColor
        self.textColor = .placeholderColor
        self.tintColor = .actionColor
        color = .bodyColor ?? .black
        isHighlighted = false
        isUnderlined = false
        activeFont = Fonts.defaultTextFont

        animator = UIDynamicAnimator(referenceView: self)
    }

    public var markdownDelegate: MarkdownTextViewDelegate? {
        didSet {
            self.delegate = markdownDelegate
        }
    }

    // MARK: - Text Functions

    private func changeTextPreservingRange(to value: NSAttributedString) {
        let range = selectedRange
        attributedText = value
        selectedRange = range
    }

    ///Inserts text in text view
    public override func insertText(_ text: String) {
        isShowingPlaceholder = false
        let backText = attributedText.smallBackwardSample(1, location: selectedRange.location).string
        let space = (text == " " && backText != "#" && backText != "-" && backText != ".")
        let mutableString = NSMutableAttributedString(attributedString: attributedText)

        let location = selectedRange.location
        //Delete any selected charactes
        mutableString.deleteCharacters(in: selectedRange)

        let writeAction = {
            if text.suffix(1) == "\n" {
                self.activeFont = self.activeFont.toStyle(.paragraph)
            }
            let newString = NSAttributedString(string: text, attributes: self.activeAttributes)
            mutableString.insert(newString, at: location)

            self.attributedText = mutableString
            self.selectedRange.location = location + text.count
        }

        //if breaking line check for lists
        if text.suffix(1) == "\n" {
            let backwardText = attributedText.smallBackwardSample(location: location)
            let backwardSlice = backwardText.split(separatedBy: "\n")

            let forwardText = attributedText.smallForwardSample(100, location: location)
            let forwardSlice = forwardText.split(separatedBy: "\n")

            //if forward has lists means it's a break in the middle, so continue
            if forwardSlice.count > 1, let list = forwardSlice[1].startsWithList(), forwardSlice[0].startsWithList() != nil {
                writeAction()
                addList(list)
            } else if let currentLine = backwardSlice.last, let list = currentLine.startsWithList() {
                //enters when current line is in a list, if length - 1 has kern means no text was provided, so stop list, else continue list
                if currentLine.hasKern(at: currentLine.length - 1) {
                    deleteBackward()
                } else {
                    writeAction()
                    addList(list)
                }
            } else {
                writeAction()
            }
        } else if space {
            super.insertText(text)
        } else {
            writeAction()  
        }

        let aroundSample = attributedText.smallAroundSample(100, location: selectedRange.location)
        let initialRange = aroundSample.1
        let initialNormalizedLocation = selectedRange.location - initialRange.location
        let newMutableString = NSMutableAttributedString(attributedString: aroundSample.0)
        let parseResult = MarkdownParser.parse(newMutableString)
        if !parseResult.0.isEmpty {
            var newLocation = initialNormalizedLocation
            parseResult.0.forEach { (range) in
                if range.location < initialNormalizedLocation {
                    if initialNormalizedLocation > range.location + range.length {
                        newLocation -= range.length
                    } else {
                        newLocation -= initialNormalizedLocation - range.location
                    }
                }
            }
            mutableString.replaceCharacters(in: initialRange, with: newMutableString)
            changeTextPreservingRange(to: mutableString)
            selectedRange.location = newLocation + aroundSample.1.location
            if let list = parseResult.1 as? ListStyle {
                addList(list)
            } else if let headerStyle = parseResult.1 as? FontStyle {
                activeFont = activeFont.toStyle(headerStyle)
            }
        }

        delegate?.textViewDidChange?(self)
    }

    ///Deletes the range or the last character
    public override func deleteBackward() {
        let mutableString = NSMutableAttributedString(attributedString: attributedText)
        if mutableString.length == 0 {
            return
        }

        var location: Int = selectedRange.location + selectedRange.length
        var range = selectedRange

        // TODO: selected range.length > 0 and deleted text makes part of list
        if selectedRange.length == 0 {
            location = selectedRange.location
            range = NSRange(location: max(0, selectedRange.location - 1), length: min(mutableString.length, 1))
            //if character beign deleted makes part of list deletes all the characters(Ex: 1., 11.)
            if mutableString.attributedSubstring(from: range).hasKern(at: 0) {
                while range.location > 0 && mutableString.attributedSubstring(from: range).hasKern(at: 0) {
                    range.location -= 1
                    range.length += 1
                }
                //Get forward text to know if it's in the middle of a list to know wether to delete the \n or not
                let forwardText = mutableString.smallForwardSample(1000, location: location)
                var forwardSlice = forwardText.split(separatedBy: "\n")
                let undoRange = {
                    range.location += 1
                    range.length -= 1
                }
                if forwardSlice.count > 1 {
                    //if is list, delete the \n
                    if let listType = forwardSlice[1].startsWithList() {
                        //if is numeric list, readjust all the next numbers
                        if listType == .numeric {
                            let deletedNum = mutableString.attributedSubstring(from: range).string
                                .replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: listType.indicator, with: "")
                            if var currentOccurrence = Int(deletedNum) {
                                currentOccurrence -= 1
                                let currentLine = forwardSlice.removeFirst()

                                var nextListsLocation = currentLine.length + location + 1
                                readjustList(in: mutableString, nextLines: &forwardSlice, from: &nextListsLocation, currentOccurrence: &currentOccurrence)
                            }
                        }
                    } else {
                        undoRange()
                    }
                } else {
                    if range.location != 0 {
                        undoRange()
                    }
                }
            }
        }

        mutableString.deleteCharacters(in: range)

        attributedText = mutableString
        selectedRange.location = max(0, location - range.length)
        delegate?.textViewDidChange?(self)
    }

    // MARK: List Function

    /**
     Calls the delegate method to add a list on the text.
     - Parameters:
     - type: The type of list to be added (bullet, numeric or quote)
     */
    public func addList(_ type: ListStyle, at location: Int? = nil) {
        //Checkin not placeholder
        if isShowingPlaceholder {
            return
        }
        //Where to start
        let targetLocation = location ?? selectedRange.location

        //Get all the previous to see if it's already part of a list
        let previousText = attributedText.smallBackwardSample(type == .numeric ? 1000 : 250, location: targetLocation)
        let previousSlice = previousText.split(separatedBy: "\n")

        var index = previousSlice.count - 1
        let lastLine = previousSlice[index]
        if let currentType = lastLine.startsWithList() {
            if currentType == type {
                return
            } else {
                //Replace all ocurrences of list
                let mutableString = NSMutableAttributedString(attributedString: attributedText)
                var listSlice: [NSAttributedString] = []
                var stillList = true
                var backestLocation = targetLocation

                //Get backward occurrences of list
                let backwardText = mutableString.smallBackwardSample(1000, location: targetLocation)
                var backwardSlice = backwardText.split(separatedBy: "\n")
                //Get backward of current line
                let currentLine = NSMutableAttributedString(attributedString: backwardSlice.removeLast())
                backestLocation -= currentLine.length
                while !backwardSlice.isEmpty && stillList {
                    let nextLine = backwardSlice.removeLast()
                    stillList = nextLine.startsWithList() == currentType
                    if stillList {
                        listSlice.insert(nextLine, at: 0)
                        backestLocation -= nextLine.length + 1
                    }
                }

                //Get forward occurences of list
                stillList = true
                let forwardText = mutableString.smallForwardSample(1000, location: targetLocation)
                var forwardSlice = forwardText.split(separatedBy: "\n")
                //Get forward of current line
                currentLine.append(forwardSlice.removeFirst())
                listSlice.append(currentLine)
                while !forwardSlice.isEmpty && stillList {
                    let nextLine = forwardSlice.removeFirst()
                    stillList = nextLine.startsWithList() == currentType
                    if stillList {
                        listSlice.append(nextLine)
                    }
                }

                var occurrence = 0
                readjustList(in: mutableString, nextLines: &listSlice, from: &backestLocation, currentOccurrence: &occurrence, toList: type)

                changeTextPreservingRange(to: mutableString)
                //Change location to final of the list due to complex math to get where it used to be
                selectedRange.location = backestLocation
                return
            }
        }
        index -= 1

        //If is numeric count how many appeared before
        var occurrence = 1
        while index >= 0 && previousSlice[index].startsWithList() == .numeric {
            index -= 1
            occurrence += 1
        }

        let position = targetLocation - lastLine.length

        let mutableString = NSMutableAttributedString(attributedString: attributedText)
        mutableString.insert(type.getAttributedString(occurrence: occurrence), at: position)
        let newLocation = selectedRange.location + (type == .numeric ? "\(occurrence)".count + 1 : 1)

        //If is numeric remake the next ones
        if type == .numeric {
            var readingLocation = newLocation
            let forwardText = mutableString.smallForwardSample(1000, location: readingLocation)
            var forwardSlice = forwardText.split(separatedBy: "\n")

            readingLocation += forwardSlice.removeFirst().length + 1

            readjustList(in: mutableString, nextLines: &forwardSlice, from: &readingLocation, currentOccurrence: &occurrence)
        }

        changeTextPreservingRange(to: mutableString)
        selectedRange.location = newLocation
    }

    private func readjustList(in string: NSMutableAttributedString,
                              nextLines: inout [NSAttributedString],
                              from readingLocation: inout Int,
                              currentOccurrence occurrence: inout Int,
                              toList: ListStyle = .numeric) {
        var stillList = true

        while !nextLines.isEmpty && stillList {
            occurrence += 1
            let nextLine = nextLines.removeFirst()
            let listType = nextLine.startsWithList()
            stillList = listType != nil
            if stillList {
                var range = NSRange(location: readingLocation, length: 1)
                var occurrenceString: NSAttributedString

                //Get all characters that has kern
                while range.location + range.length < string.length,
                      string.attributedSubstring(from: NSRange(location: readingLocation, length: range.length + 1)).hasKern(at: range.length) {
                    range.length += 1
                }
                //Replace them with the new list attributed string
                occurrenceString = toList.getAttributedString(occurrence: occurrence)

                string.replaceCharacters(in: range, with: occurrenceString)
                //Location += line.length - what we deleted + what we inserted + \n
                readingLocation += (nextLine.length - range.length + occurrenceString.length + 1)
            }
        }
    }
    
    // MARK: - UIResponderStandardEditActions
    
    private lazy var boldMenuItem: UIMenuItem = {
        return UIMenuItem(title: "Bold".localized(), action: #selector(toggleBoldface(_:)))
    }()
    
    private lazy var italicMenuItem: UIMenuItem = {
        return UIMenuItem(title: "Italic".localized(), action: #selector(toggleItalics(_:)))
    }()
    
    private lazy var underlineMenuItem: UIMenuItem = {
        return UIMenuItem(title: "Underline".localized(), action: #selector(toggleUnderline(_:)))
    }()
    
    private lazy var highlightMenuItem: UIMenuItem = {
        return UIMenuItem(title: "Highlight".localized(), action: #selector(toggleHighlight(_:)))
    }()
    
    public override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        let superCanPerformBold = super.canPerformAction(#selector(UIResponderStandardEditActions.toggleBoldface(_:)), withSender: sender)
        
        if superCanPerformBold {
            UIMenuController.shared.menuItems = [boldMenuItem, italicMenuItem, underlineMenuItem, highlightMenuItem]
        } else if action == Selector(("_showTextStyleOptions:")) {
            UIMenuController.shared.menuItems = nil
            return true
        }
        
        return super.canPerformAction(action, withSender: sender)
    }
    
    public override func toggleBoldface(_ sender: Any?) {
        self.setBold(!self.isBold)
    }
    
    public override func toggleItalics(_ sender: Any?) {
        self.setItalic(!self.isItalic)
    }
    
    public override func toggleUnderline(_ sender: Any?) {
        self.setUnderlined(!self.isUnderlined)
    }
    
    /**
     Toggles the highlight style information of the selected text.
     
     - Parameter sender: The object calling this method.
     
     Use this method to apply or remove style information to the currently selected content.
     */
    @objc public func toggleHighlight(_ sender: Any?) {
        self.setHighlighted(!self.isHighlighted)
    }
    
    /**
     Toggles the format style information of the selected text.
     
     - Parameter sender: The UIKeyCommand calling this method.
     
     Use this method to apply or remove style information to the currently selected content for boldface, italics and underline.
     */
    @objc public func toggleFormat(_ sender: UIKeyCommand) {
        switch sender.input {
        case "B":
            toggleBoldface(nil)
        case "I":
            toggleItalics(nil)
        case "U":
            toggleUnderline(nil)
        default:
            break
        }
    }
}
