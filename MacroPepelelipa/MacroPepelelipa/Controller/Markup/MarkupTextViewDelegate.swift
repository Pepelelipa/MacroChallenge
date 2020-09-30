//
//  MarkupTextViewDelegate.swift
//  MacroPepelelipa
//
//  Created by Lia Kassardjian, 
//             Leonardo Amorim de Oliveira and 
//             Pedro Henrique Guedes Silveira on 17/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal class MarkupTextViewDelegate: NSObject, UITextViewDelegate {
    
    private let markdownParser: MarkdownParser
    public var markdownAttributesChanged: ((NSAttributedString?, Error?) -> Void)?
    private var placeholder: String
    private var isShowingPlaceholder: Bool
    private var isBackspace: Bool
    private var range: NSRange?
    private var lastWrittenText: String

    internal weak var observer: TextEditingDelegateObserver?
    internal weak var textBoxObserver: TextBoxEditingDelegateObserver?

    override init() {
        markdownParser = MarkdownParser(color: UIColor(named: "Body") ?? .black)
        isShowingPlaceholder = false
        isBackspace = false
        placeholder = "Start writing here".localized()
        lastWrittenText = ""
    }
    
    /**
     This method displays the placeholder with the correct color on an UITextView.
     
     - Parameter textView: The UITextView on which the placeholder will be displayed.
     */
    public func parsePlaceholder(on textView: UITextView) {
        textView.attributedText = NSAttributedString(string: placeholder)
        textView.font = markdownParser.font
        isShowingPlaceholder = true
        textView.textColor = UIColor(named: "Placeholder")
    }
        
    func textViewDidChange(_ textView: UITextView) {
        if textView.attributedText.string.last == "\n" && !isBackspace {
            continueBulletList(on: textView)
            continueNumericList(on: textView)
            continueQuote(on: textView)
        }
        
        if let range = range {
            markdownAttributesChanged?(markdownParser.parse(textView.attributedText, range: range, isBackspace: isBackspace), nil)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let char = text.cString(using: String.Encoding.utf8) else {
            return false
        }
        
        let backspace = strcmp(char, "\\b")
        if backspace == -92 {
            self.isBackspace = true
        } else {
            self.isBackspace = false
        }
        
        if lastWrittenText == "\n" && text == "\n" {
            if MarkdownList.isList {
                MarkdownList.isList = false
            }
            
            if MarkdownNumeric.isNumeric {
                MarkdownNumeric.isNumeric = false
            }
            
            if MarkdownQuote.isQuote {
                MarkdownQuote.isQuote = false
            }
        }
        lastWrittenText = text
        
        self.range = range
        
        return true
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if isShowingPlaceholder {
            textView.attributedText = NSAttributedString(string: "")
            textView.textColor = markdownParser.color
            isShowingPlaceholder = false
        }
        return true
    }
    
    /**
     This method continues to add a Bullet List on the UITextView if a Bullet List was already started.
     
     - Parameter textView: The UITextView on which will be added the Bullet List.
     */
    private func continueBulletList(on textView: UITextView) {
        if MarkdownList.isList {
            addBulletList(on: textView, true)
        }
    }
    
    /**
     This method continues to add a Numeric List on the UITextView if a Numeric List was already started.
     
     - Parameter textView: The UITextView on which will be added the Numeric List.
     */
    private func continueNumericList(on textView: UITextView) {
        if MarkdownNumeric.isNumeric {
            MarkdownNumeric.updateNumber(isBackspace: isBackspace)
            addNumericList(on: textView, true)
        }
    }
    
    /**
     This method continues to add a Quotes on the UITextView if a Quote was already started.
     
     - Parameter textView: The UITextView on which will be added the Quote.
     */
    private func continueQuote(on textView: UITextView) {
        if MarkdownQuote.isQuote {
            addQuote(on: textView, true)
        }
    }
    
    /**
     This method adds a bullet to the UITextView and calls the parser's formatting methods.
     
     - Parameters:
        - textView: The UITextView that will be formatted.
        - lineCleared: A boolean indicating if a line break is needed or not.
     */
    public func addBulletList(on textView: UITextView, _ lineCleared: Bool) {
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
    public func addNumericList(on textView: UITextView, _ lineCleared: Bool) {
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
    public func addQuote(on textView: UITextView, _ lineCleared: Bool) {
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
     This method clears indicators on a line on the UITextView.
     
     - Parameter textView: The UITextView which text will be checked and changed in case of any found indicators.
     
     - Returns: True if any characters were cleared, false if none was cleared.
     */
    public func clearIndicatorCharacters(_ textView: UITextView) -> Bool {
        let attributedText = textView.attributedText
        
        guard let lenght = attributedText?.length, lenght > 0 else {
            return false
        }
        
        let lineInfo = findLineLocation(attributedString: attributedText, lenght: lenght)
        
        let lineLenght = lineInfo.lineLenght
        let location = lineInfo.location
        var indicatorFound = false
        var textFound = false
        
        guard let line = attributedText?.attributedSubstring(from: NSRange(location: location, length: lineLenght)) else {
            return false
        }
        
        for index in 0..<lineLenght {
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
        
        if textFound {
            breakLine(textView, range: NSRange(location: location + lineLenght, length: 1))
        } else {
            if indicatorFound {
                clearLine(textView, range: NSRange(location: location, length: lineLenght))
                return true
            }
        }
        
        return false
    }
    
    /**
     This method fins the location and the lenght of an line on a NSAttributedString, based on its full lenght.
     
     - Parameters:
        - attributedString: The NSAttributedString that will be checked.
        - lenght: The lenght of the attributed string.
     
     - Returns: A tuple containing the location of the line and its lenght.
     */
    private func findLineLocation(attributedString: NSAttributedString?, lenght: Int) -> (location: Int, lineLenght: Int) {
        var line: (location: Int, lineLenght: Int) = (lenght - 1, 0)
        
        while line.location > 0 {
            if let substring = attributedString?.attributedSubstring(from: NSRange(location: line.location, length: 1)) {
                if substring.string[substring.string.startIndex].isNewline {
                    break
                }
                line.location -= 1
                line.lineLenght += 1
            } else {
                break
            }
        }
        
        return line
    }
    
    /**
     This method deletes the caracters from the range's location on the UITextView.
     
     - Parameters:
        - textView: The UITextView which text will be change.
        - range: The NSRange from which the characters will be deleted.
     */
    private func clearLine(_ textView: UITextView, range: NSRange) {
        let attributedText = NSMutableAttributedString(attributedString: textView.attributedText)
        
        var location = range.location
        
        if attributedText.attributedSubstring(from: NSRange(location: range.location, length: 1)).string == "\n" {
            location += 1
        }
        
        attributedText.replaceCharacters(in: NSRange(location: location, length: 3), with: "")
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
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        observer?.textEditingDidBegin()
        textBoxObserver?.textViewDidBeginEditing()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        observer?.textEditingDidEnd()
    }
}
