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
     This method adds italic attributes on the UITextView based on the selected range.
     
     - Parameters:
        - textView: The UITextView which attributed text will receive new attributes.
     */
    public func addItalic(on textView: UITextView) {
        guard let attributedText = textView.attributedText else {
            return
        }
        
        let range = textView.selectedRange
        
        let mutableAttributedText = NSMutableAttributedString(attributedString: attributedText)
        
        guard let newFontValue = markdownParser.font.italic() else {
            return
        }
        
        mutableAttributedText.addAttribute(.font, value: newFontValue, range: range)
        textView.attributedText = mutableAttributedText
    }
    
    /**
     This method removes all format attributes on the UITextView based on the selected range.
     
     - Parameters:
        - textView: The UITextView which attributed text will receive new attributes.
     */
    public func removesFormatAttributes(on textView: UITextView) {
        guard let attributedText = textView.attributedText else {
            return
        }
        
        let range = textView.selectedRange
        
        let mutableAttributedText = NSMutableAttributedString(attributedString: attributedText)
        
        mutableAttributedText.addAttribute(.font, value: markdownParser.font, range: range)
        textView.attributedText = mutableAttributedText
    }
    
    /**
     This method adds bold attributes on the UITextView based on the selected range.
     
     - Parameters:
        - textView: The UITextView which attributed text will receive new attributes.
     */
    public func addBold(on textView: UITextView) {
        guard let attributedText = textView.attributedText else {
            return
        }
        
        let range = textView.selectedRange
        
        let mutableAttributedText = NSMutableAttributedString(attributedString: attributedText)
        
        guard let newFontValue = markdownParser.font.bold() else {
            return
        }
        
        mutableAttributedText.addAttribute(.font, value: newFontValue, range: range)
        textView.attributedText = mutableAttributedText
    }
    
    /**
     This method adds header attributes on the UITextView based on the selected range and the chosen style.
     
     - Parameters:
        - textView: The UITextView which attributed text will receive new attributes.
        - style: A case of the HeaderStyle enum declaring the chosen style.
     */
    public func addHeader(on textView: UITextView, with style: HeaderStyle) {
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
    
    /**
     This method clears indicators on a line on the UITextView.
     
     - Parameter textView: The UITextView which text will be checked and changed in case of any found indicators.
     
     - Returns: True if any characters were cleared, false if none was cleared.
     */
    public func clearIndicatorCharacters(_ textView: UITextView) -> Bool {
        guard let attributedText = textView.attributedText else {
            return false
        }
        
        let lenght = attributedText.length
    
        guard lenght > 0 else {
            return false
        }
        
        let lineInfo = findLineLocation(attributedString: attributedText, location: lenght - 1)
        
        var lineLenght = lineInfo.length
        let location = lineInfo.location
        var indicatorFound = false
        var textFound = false
        
        if lineLenght == 1 {
            lineLenght = 0
        }
        
        let line = attributedText.attributedSubstring(from: NSRange(location: location, length: lineLenght))
        
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
            breakLine(textView, range: NSRange(location: location + lineLenght - 1, length: 1))
        } else {
            if indicatorFound {
                clearLine(textView, range: NSRange(location: location, length: lineLenght))
                return true
            }
        }
        
        return false
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
}
