//
//  TutorialNotesHelper.swift
//  MacroPepelelipa
//
//  Created by Karina Paula on 09/10/21.
//  Copyright © 2021 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

struct TutorialNotesHelper {
    
    static let breakLine = NSAttributedString(string: "\n")
    static let headerFont = UIFont.merriweather?.toFirstHeaderFont() ?? UIFont.defaultHeader
    static let paragraphFont = UIFont.merriweather?.toParagraphFont() ?? UIFont.defaultFont
    static let paragraphBoldFont = UIFont.merriweather?.toParagraphFont().bold() ?? UIFont.defaultFont
    static let paragraphUnderlinedFont = UIFont.merriweather?.toParagraphFont() ?? UIFont.defaultFont
    static let paragraphItalicFont = UIFont.merriweather?.toParagraphFont().italic() ?? UIFont.defaultFont
    
    static func buildIntroductionTitle() -> NSAttributedString {
        return "Introduction Note Title".localized().toFontWithDefaultColor(font: headerFont)
    }
    
    static func buildIntroductionText() -> NSAttributedString {
        let resultText = NSMutableAttributedString()
        let underlineNumber = NSNumber.init(value: NSUnderlineStyle.single.rawValue)
        
        resultText.append("Introduction First Paragraph 01".localized().toFontWithDefaultColor(font: paragraphFont))
        resultText.append("Introduction First Paragraph 02".localized().toFontWithDefaultColor(font: paragraphBoldFont))
        resultText.append("Introduction First Paragraph 03".localized().toFontWithDefaultColor(font: paragraphFont))
        resultText.append("Introduction First Paragraph 04".localized().toFontWithDefaultColor(font: paragraphItalicFont))
        resultText.append("Introduction First Paragraph 05".localized().toFontWithDefaultColor(font: paragraphFont))
        resultText.append("Introduction First Paragraph 06".localized().toFontWithDefaultColor(font: paragraphItalicFont))
        
        resultText.append(breakLine)
        resultText.append(breakLine)
        resultText.append("Introduction Second Paragraph 01".localized().toFontWithDefaultColor(font: paragraphFont))
        let intro2P02 = "Introduction Second Paragraph 02".localized().toFontWithDefaultColor(font: paragraphFont)
        intro2P02.addAttribute(.underlineStyle, value: underlineNumber, range: NSRange(location: 0, length: intro2P02.length))
        resultText.append(intro2P02)
        resultText.append("Introduction Second Paragraph 03".localized().toFontWithDefaultColor(font: paragraphFont))
        
        resultText.append(breakLine)
        resultText.append(breakLine)
        resultText.append("Introduction Third Paragraph 01".localized().toFontWithDefaultColor(font: paragraphFont))
        resultText.append("Introduction Third Paragraph 02".localized().toFontWithDefaultColor(font: paragraphFont))
        resultText.append("Introduction Third Paragraph 03".localized().toFontWithDefaultColor(font: paragraphFont))
        resultText.append("Introduction Third Paragraph 04".localized().toFontWithDefaultColor(font: paragraphBoldFont))
        resultText.append("Introduction Third Paragraph 05".localized().toFontWithDefaultColor(font: paragraphFont))
        
        resultText.append(breakLine)
        resultText.append(breakLine)
        resultText.append("Introduction Fourth Paragraph 01".localized().toFontWithDefaultColor(font: paragraphFont))
        let intro4P02 = "Introduction Fourth Paragraph 02".localized().toFontWithDefaultColor(font: paragraphItalicFont)
        intro4P02.addAttribute(.underlineStyle, value: underlineNumber, range: NSRange(location: 0, length: intro4P02.length))
        resultText.append(intro4P02)
        resultText.append("Introduction Fourth Paragraph 03".localized().toFontWithDefaultColor(font: paragraphFont))
        let intro4P04 = "Introduction Fourth Paragraph 04".localized().toFontWithDefaultColor(font: paragraphItalicFont)
        intro4P04.addAttribute(.underlineStyle, value: underlineNumber, range: NSRange(location: 0, length: intro4P04.length))
        resultText.append(intro4P04)
        
        resultText.append(breakLine)
        resultText.append(breakLine)
        resultText.append("Introduction Fifth Paragraph 01".localized().toFontWithDefaultColor(font: paragraphFont))
        resultText.append("Introduction Fifth Paragraph 02".localized().toFontWithDefaultColor(font: paragraphBoldFont))
        resultText.append("Introduction Fifth Paragraph 03".localized().toFontWithDefaultColor(font: paragraphFont))
        let intro5P04 = "Introduction Fifth Paragraph 04".localized().toFontWithDefaultColor(font: paragraphFont)
        resultText.append(intro5P04)
        resultText.append("Introduction Fifth Paragraph 05".localized().toFontWithDefaultColor(font: paragraphFont))
        
        return resultText
    }
    
    static func buildCustomizeTitle() -> NSAttributedString {
        return "Customize Note Title".localized().toFontWithDefaultColor(font: headerFont)
    }
    
    static func buildCustomizeText() -> NSAttributedString {
        let resultText = NSMutableAttributedString()
        
        resultText.append("Customize First Header".localized().toFontWithDefaultColor(font: headerFont))
        resultText.append(breakLine)
        resultText.append(breakLine)
        resultText.append("Customize First Paragraph".localized().toFontWithDefaultColor(font: paragraphFont))
        resultText.append(breakLine)
        resultText.append(breakLine)
        resultText.append("Customize Second Paragraph".localized().toFontWithDefaultColor(font: paragraphFont))
        resultText.append(breakLine)
        resultText.append(breakLine)
        resultText.append("Customize Third Paragraph".localized().toFontWithDefaultColor(font: paragraphFont))
        resultText.append(breakLine)
        resultText.append(breakLine)
        resultText.append("Customize Fourth Paragraph".localized().toFontWithDefaultColor(font: paragraphFont))
        
        return resultText
    }
    
    static func buildIndexTitle() -> NSAttributedString {
        return "Index Note Title".localized().toFontWithDefaultColor(font: headerFont)
    }
    
    static func buildIndexText() -> NSAttributedString {
        let resultText = NSMutableAttributedString()
        
        resultText.append("Index First Header".localized().toFontWithDefaultColor(font: headerFont))
        resultText.append(breakLine)
        resultText.append(breakLine)
        resultText.append("Index First Paragraph".localized().toFontWithDefaultColor(font: paragraphFont))
        
        return resultText
    }
    
    static func buildExamplesTitle() -> NSAttributedString {
        return "Examples Note Title".localized().toFontWithDefaultColor(font: headerFont)
    }
    
    static func buildExamplesText() -> NSAttributedString {
        let resultText = NSMutableAttributedString()
        
        resultText.append("Examples First Header".localized().toFontWithDefaultColor(font: headerFont))
        resultText.append(breakLine)
        resultText.append(breakLine)
        resultText.append("Examples First Paragraph".localized().toFontWithDefaultColor(font: paragraphFont))
        
        return resultText
    }
    
}

