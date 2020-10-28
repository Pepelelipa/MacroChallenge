//
//  MarkdownEditor.swift
//  MacroPepelelipa
//
//  Created by Lia Kassardjian on 29/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

class MarkdownEditor {
    
    let markdownParser: MarkdownParser
    
    init(markdownParser: MarkdownParser) {
        self.markdownParser = markdownParser
    }
    
    // MARK: - Fonts
    
    /**
     This private method toggles a trait on the textview's attributed text.
     
     - Parameters:
        - trait: The trait to be toggled on the text.
        - textView: The UITextView which attributed text will receive a new font.
     */
    private func setFontTrait(trait: UIFontDescriptor.SymbolicTraits, _ textView: UITextView) {
        guard let attributedText = textView.attributedText else {
            return
        }
        
        let range = textView.selectedRange
        let mutableAttributedText = NSMutableAttributedString(attributedString: attributedText)
                
        guard let font = mutableAttributedText.attribute(.font, at: range.location, effectiveRange: nil) as? UIFont else {
            return
        }
        
        var newFont = markdownParser.font
        
        if font.fontDescriptor.symbolicTraits.contains(trait) {
            newFont = newFont.removeTrait(trait)
        } else {
            if trait == .traitItalic {
                newFont = font.italic() ?? markdownParser.font
            } else if trait == .traitBold {
                newFont = font.bold() ?? markdownParser.font
            }
        }
        
        mutableAttributedText.addAttribute(.font, value: newFont, range: range)
        textView.attributedText = mutableAttributedText
    }
    
    /**
     This method adds italic attributes on the UITextView based on the selected range.
     - Parameter textView: The UITextView which attributed text will receive new attributes.
     */
    internal func addItalic(on textView: UITextView) {
        setFontTrait(trait: .traitItalic, textView)
    }
    
    /**
     This method adds bold attributes on the UITextView based on the selected range.
     - Parameter textView: The UITextView which attributed text will receive new attributes.
     */
    internal func addBold(on textView: UITextView) {
        setFontTrait(trait: .traitBold, textView)
    }
    
    /**
     This method sets the text font for a UITextView attributed text within a given range.
     
     - Parameters:
        - font: The font for the attributed text in range.
        - range: A NSRange indicating the range for the new color.
        - textView: The UITextView which text will be changed.
     */
    internal func setTextFont(_ font: UIFont, in range: NSRange, _ textView: UITextView) {
        let attributedText = NSMutableAttributedString(attributedString: textView.attributedText)
        attributedText.addAttribute(.font, value: font, range: range)
        textView.attributedText = attributedText
    }
    
    // MARK: - Headers
    
    /**
     This method adds header attributes on the UITextView based on the selected range and the chosen style.
     
     - Parameters:
        - textView: The UITextView which attributed text will receive new attributes.
        - style: A case of the HeaderStyle enum declaring the chosen style.
     */
    internal func addHeader(on textView: UITextView, with style: HeaderStyle) {
        guard let attributedText = textView.attributedText else {
            return
        }
        
        switch style {
        case .h1:
            markdownParser.font = MarkdownHeader.firstHeaderFont
        case .h2:
            markdownParser.font = MarkdownHeader.secondHeaderFont
        case .h3:
            markdownParser.font = MarkdownHeader.thirdHeaderFont
        case .paragraph:
            markdownParser.font = MarkdownParser.defaultFont
        }
        
        let range = textView.selectedRange
        var location: Int = range.location
        
        if range.length == 0 && location > 0 {
            location = range.location - 1
        }
        
        var line = [findLineLocation(attributedString: attributedText, location: location)]
        
        if range.length > line[0].length + 1 {
            line.append(findLineLocation(attributedString: attributedText, location: location + range.length))
        }
        
        var headerRange = NSRange(location: 0, length: 0)
        var lenght: Int = line[0].length
        if line.count == 1 {
            if line[0].length == 1 {
                lenght = 0
            }
        } else {
            lenght = line[0].location + line[1].location + line[1].length
        }
        headerRange = NSRange(location: line[0].location, length: lenght)
        
        let mutableAttributedText = NSMutableAttributedString(attributedString: attributedText)
        
        if headerRange.location + headerRange.length > attributedText.length {
            headerRange.length = attributedText.length - headerRange.location
        }
        
        mutableAttributedText.addAttribute(.font, value: markdownParser.font, range: headerRange)
        textView.attributedText = mutableAttributedText
    }
    
    // MARK: - Colors
    
    /**
     This method adds background color attribute on the UITextView based on the selected range.
     - Parameter textView: The UITextView which attributed text will receive new attributes.
     */
    internal func setBackgroundColor(on textView: UITextView) {
        guard let attributedText = textView.attributedText else {
            return
        }
        
        let range = textView.selectedRange
        let mutableAtrributedText = NSMutableAttributedString(attributedString: attributedText)
        
        guard let color = mutableAtrributedText.attribute(.backgroundColor, at: range.location, effectiveRange: nil) as? UIColor else {
            return
        }
        
        var newColor = MarkdownCode.defaultHighlightColor
        
        if color == newColor {
            newColor = UIColor.backgroundColor ?? markdownParser.backgroundColor
            markdownParser.backgroundColor = newColor
        }
                
        mutableAtrributedText.addAttribute(.backgroundColor, value: newColor, range: range)
        textView.attributedText = mutableAtrributedText
    }
    
    /**
     This method sets the text color for a UITextView attributed text within a given range.
     
     - Parameters:
        - color: The color for the attributed text in range.
        - range: A NSRange indicating the range for the new color.
        - textView: The UITextView which text will be changed.
     */
    internal func setTextColor(_ color: UIColor, in range: NSRange, _ textView: UITextView) {
        let attributedText = NSMutableAttributedString(attributedString: textView.attributedText)
        attributedText.addAttribute(.foregroundColor, value: color, range: range)
        textView.attributedText = attributedText
    }
    
    // MARK: - Lists
    
    /**
     This method adds a bullet to the UITextView and calls the parser's formatting methods.
     
     - Parameters:
        - textView: The UITextView that will be formatted.
        - lineCleared: A boolean indicating if a line break is needed or not.
     */
    internal func addBulletList(on textView: UITextView, _ lineCleared: Bool) {
        let attributedText = NSMutableAttributedString(attributedString: textView.attributedText)
        
        if !MarkdownList.isList && !lineCleared {
            attributedText.append(NSAttributedString(string: "\n"))
        }

        let attributedString = NSMutableAttributedString(string: "* ")
        MarkdownList.formatListStyle(
            attributedString,
            range: NSRange(location: 0, length: attributedString.length),
            level: 1
        )

        attributedText.append(attributedString)
        textView.attributedText = attributedText
    }
    
    /**
     This method adds a numeric list to the UITextView and calls the parser's formatting methods.
     
     - Parameters:
        - textView: The UITextView that will be formatted.
        - lineCleared: A boolean indicating if a line break is needed or not.
     */
    internal func addNumericList(on textView: UITextView, _ lineCleared: Bool) {
        let attributedText = NSMutableAttributedString(attributedString: textView.attributedText)
        
        if !MarkdownNumeric.isNumeric && !lineCleared {
            attributedText.append(NSAttributedString(string: "\n"))
        }

        let attributedString = NSMutableAttributedString(string: "2. ")
        MarkdownNumeric.formatListStyle(
            attributedString,
            range: NSRange(location: 0, length: attributedString.length),
            level: 1
        )

        attributedText.append(attributedString)
        textView.attributedText = attributedText
    }
    
    /**
     This method adds a quote to the UITextView and calls the parser's formatting methods.
     
     - Parameters:
        - textView: The UITextView that will be formatted.
        - lineCleared: A boolean indicating if a line break is needed or not.
     */
    internal func addQuote(on textView: UITextView, _ lineCleared: Bool) {
        let attributedText = NSMutableAttributedString(attributedString: textView.attributedText)
        
        if !MarkdownQuote.isQuote && !lineCleared {
            attributedText.append(NSAttributedString(string: "\n"))
        }

        let attributedString = NSMutableAttributedString(string: "> ")
        MarkdownQuote.formatQuoteStyle(
            attributedString,
            range: NSRange(location: 0, length: attributedString.length),
            level: 1
        )

        attributedText.append(attributedString)
        textView.attributedText = attributedText
    }

    /**
     This method finds indicator characters and text in an NSAttributedString whitin a NSRange.
     
     - Parameters:
        - attributedText: The NSAttributedString that will be checked.
        - range: The NSRange that will be used to check the NSAttributedString.
     
     - Returns: A tuple containing two booleans. The first one indicates if any text was found in the range and the second indicates if a list indicator was found.
     */
    internal func findIndicatorCharacters(attributedText: NSAttributedString, range: NSRange) -> (textFound: Bool, indicatorFound: Bool) {
        let line = attributedText.attributedSubstring(from: range)
        var indicatorFound = false
        var textFound = false
        
        for index in 0..<range.length {
            let char = line.attributedSubstring(from: NSRange(location: index, length: 1))
            
            if char.string != "\n" {
                let quote = MarkdownQuote.checkQuoteIndicator(attributedText: char)
                let numeric = MarkdownNumeric.checkNumericIndicator(attributedText: char)
                let list = MarkdownList.checkListIndicator(attributedText: char)
                
                if quote || numeric || list {
                    indicatorFound = true
                } else if char.string != " " {
                    textFound = true
                }
            }
        }
        
        return (textFound, indicatorFound)
    }

    /**
     This method clears indicators on a line on the UITextView.
     - Parameter textView: The UITextView which text will be checked and changed in case of any found indicators.
     - Returns: True if any characters were cleared, false if none was cleared.
     */
    internal func clearIndicatorCharacters(_ textView: UITextView) -> NSRange? {
        guard let attributedText = textView.attributedText else {
            return nil
        }
        
        let lenght = attributedText.length
        var cursor = textView.selectedRange.location
    
        guard lenght > 0 else {
            return nil
        }
        
        cursor -= cursor == lenght ? 1 : 0
        cursor -= cursor != 0 ? 1 : 0
        
        var range = findLineLocation(attributedString: attributedText, location: cursor)
        
        if range.length == 1 {
            range.length = 0
        }
        
        let info = findIndicatorCharacters(attributedText: attributedText, range: range)
        
        if info.textFound {
            breakLine(textView, range: NSRange(location: range.location + range.length - 1, length: 1))
        } else {
            if info.indicatorFound {
                clearLine(textView, range: NSRange(location: range.location, length: range.length))
                return range
            }
        }
        
        return nil
    }
    
    /**
     This method fins the location and the lenght of an line on a NSAttributedString, based on an initial location.
     
     - Parameters:
        - attributedString: The NSAttributedString that will be checked.
        - location: The initial location to start looking for the line
     - Returns: A NSRange indicating where a line starts and ends.
     */
    private func findLineLocation(attributedString: NSAttributedString, location: Int) -> NSRange {
        var line = NSRange(location: location, length: 0)
        
        while line.location > 0 {
            let substring = attributedString.attributedSubstring(from: NSRange(location: line.location, length: 1))
            if substring.string[substring.string.startIndex].isNewline {
                
                line.location += 1
                
                if line.length > 0 {
                    line.length -= 1
                }
                
                break
            }
            line.location -= 1
            line.length += 1
        }
        
        var tempLocation = location + 1
        while tempLocation <= attributedString.length {
            if tempLocation == attributedString.length {
                line.length += 1
                break
            }
            
            let substring = attributedString.attributedSubstring(from: NSRange(location: tempLocation, length: 1))
            if substring.string[substring.string.startIndex].isNewline {
                break
            }
            line.length += 1
            tempLocation += 1
        }
        return line
    }
    
    /**
     This method deletes the caracters from the range's location on the UITextView.
     
     - Parameters:
        - textView: The UITextView which text will be changed.
        - range: The NSRange from which the characters will be deleted.
     */
    private func clearLine(_ textView: UITextView, range: NSRange) {
        let attributedText = NSMutableAttributedString(attributedString: textView.attributedText)
        
        var location = range.location
        
        if attributedText.attributedSubstring(from: NSRange(location: range.location, length: 1)).string == "\n" {
            location += 1
        }
        
        var lenght = 3
        if location + lenght > attributedText.length {
            lenght = attributedText.length - location
        }
        attributedText.replaceCharacters(in: NSRange(location: location, length: lenght), with: "")
        textView.attributedText = attributedText
    }
    
    /**
     This method add a line break on a location on the UITextView.
     
     - Parameters:
        - textView: The UITextView which text will be change.
        - range: The NSRange on which the line break will be added.
     */
    private func breakLine(_ textView: UITextView, range: NSRange) {
        let attributedText = NSMutableAttributedString(attributedString: textView.attributedText)
        
        var location = range.location
        
        if attributedText.attributedSubstring(from: NSRange(location: range.location, length: 1)).string == "\n" {
            location += 1
        }
        
        attributedText.replaceCharacters(in: NSRange(location: location, length: 1), with: "\n")
        textView.attributedText = attributedText
    }

    /**
     This method checks if list indicator characters should be deleted or not.
     
     - Parameter textView: The UITextView which text will be checked.
     - Returns: A boolean indicating if any characters should be deleted or not.
     */
    internal func shouldDeleteIndicatorCharacters(_ textView: UITextView) -> Bool {
        guard let attributedText = textView.attributedText,
              attributedText.length > 0 else {
            return false
        }
        
        var cursor = textView.selectedRange
        
        if cursor.location > 0 {
            if cursor.location == attributedText.length {
                cursor.location -= 1
            }
            cursor.location -= 1
        }
        
        guard cursor.location > 0 else {
            return false
        }
        
        var range = findLineLocation(attributedString: attributedText, location: cursor.location)
        
        if range.length == 1 {
            range.length = 0
        }
        
        guard range.location + range.length <= attributedText.length else {
            return false
        }

        let info = findIndicatorCharacters(attributedText: attributedText, range: range)
        
        if range.length <= 4 && info.indicatorFound && !info.textFound {
            return true
        }
        
        return false
    }
}
