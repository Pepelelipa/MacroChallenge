//
//  MarkupTextViewDelegate.swift
//  MacroPepelelipa
//
//  Created by Lia Kassardjian on 17/09/20.
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
//            let end = textView.attributedText.string.endIndex
//            var index = textView.attributedText.string.index(before: end)
//            var string = textView.attributedText.string[index]
//            while !string.isNewline {
//                index = textView.attributedText.string.index(before: index)
//                string = textView.attributedText.string[index]
//            }
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
    
    private func continueBulletList(on textView: UITextView) {
        if !MarkdownList.isList {
            return
        }
        
        let attributedText = NSMutableAttributedString(attributedString: textView.attributedText)
        
        let attributedString = NSMutableAttributedString(string: "* ")
        MarkdownList.formatListStyle(
            attributedString,
            range: NSRange(location: 0, length: attributedString.length),
            level: 1
        )
        
        attributedText.append(attributedString)
        textView.attributedText = attributedText
    }
    
    private func continueNumericList(on textView: UITextView) {
        if !MarkdownNumeric.isNumeric {
             return
        }
        
        MarkdownNumeric.updateNumber(isBackspace: isBackspace)
        
        let attributedText = NSMutableAttributedString(attributedString: textView.attributedText)
        
        let attributedString = NSMutableAttributedString(string: "2. ")
        MarkdownNumeric.formatListStyle(
            attributedString,
            range: NSRange(location: 0, length: attributedString.length),
            level: 1
        )
        
        attributedText.append(attributedString)
        textView.attributedText = attributedText
    }
    
    private func continueQuote(on textView: UITextView) {
        if !MarkdownQuote.isQuote {
             return
        }
                
        let attributedText = NSMutableAttributedString(attributedString: textView.attributedText)
        
        let attributedString = NSMutableAttributedString(string: "> ")
        MarkdownQuote.formatQuoteStyle(
            attributedString,
            range: NSRange(location: 0, length: attributedString.length - 1),
            level: 1
        )

        attributedText.append(attributedString)
        textView.attributedText = attributedText
    }
    
    public func clearIndicatorCharacters(_ textView: UITextView) {
        let attributedText = textView.attributedText
        
        guard let lenght = attributedText?.length, lenght > 0 else {
            return
        }
        
        var lineLenght = 0
        var location = lenght - 1
        var indicatorFound = false
        var textFound = false
        
        while location > 0 {
            if let substring = attributedText?.attributedSubstring(from: NSRange(location: location, length: 1)) {
                if substring.string[substring.string.startIndex].isNewline {
                    break
                }
                location -= 1
                lineLenght += 1
            } else {
                break
            }
        }
        
        guard let line = attributedText?.attributedSubstring(from: NSRange(location: location, length: lineLenght)) else {
            return
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
        
        if indicatorFound && !textFound {
           clearLine(textView, range: NSRange(location: location, length: lineLenght))
        }
    }
    
    private func clearLine(_ textView: UITextView, range: NSRange) {
        let attributedText = NSMutableAttributedString(attributedString: textView.attributedText)
        
        var location = range.location
        
        if attributedText.attributedSubstring(from: NSRange(location: range.location, length: 1)).string == "\n" {
            location += 1
        }
        
        attributedText.replaceCharacters(in: NSRange(location: location, length: 3), with: "")
        textView.attributedText = attributedText
    }
    
}
