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
        // Precisa adicionar o highlight em "Mac, iPhone e iPad"
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
        // Fazer highlight
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
        // Adicoinar a cor verde em "funcionalidades"
        resultText.append("Introduction Fifth Paragraph 05".localized().toFontWithDefaultColor(font: paragraphFont))
        
        return resultText
    }
    
    static func buildCustomizeTitle() -> NSAttributedString {
        return "Customize Note Title".localized().toFontWithDefaultColor(font: headerFont)
    }
    
    static func buildCustomizeText() -> NSAttributedString {
        let resultText = NSMutableAttributedString()
        let underlineNumber = NSNumber.init(value: NSUnderlineStyle.single.rawValue)
        
        resultText.append("Customize Note First Paragraph 01".localized().toFontWithDefaultColor(font: headerFont))
        resultText.append(breakLine)
        resultText.append(breakLine)
        resultText.append("Customize Note First Paragraph 02".localized().toFontWithDefaultColor(font: paragraphFont))
        resultText.append("Customize Note First Paragraph 03".localized().toFontWithDefaultColor(font: paragraphBoldFont))
        // Adicionar highlight
        resultText.append("Customize Note First Paragraph 04".localized().toFontWithDefaultColor(font: paragraphFont))
        resultText.append("Customize Note First Paragraph 05".localized().toFontWithDefaultColor(font: paragraphFont))
        let customize1P06 = "Customize Note First Paragraph 06".localized().toFontWithDefaultColor(font: paragraphFont)
        customize1P06.addAttribute(.underlineStyle, value: underlineNumber, range: NSRange(location: 0, length: customize1P06.length))
        resultText.append(customize1P06)
        resultText.append(breakLine)
        resultText.append("Customize Note Second Paragraph 01".localized().toFontWithDefaultColor(font: paragraphFont))
        resultText.append("Customize Note Second Paragraph 02".localized().toFontWithDefaultColor(font: paragraphBoldFont))
        // verde
        resultText.append("Customize Note Second Paragraph 03".localized().toFontWithDefaultColor(font: paragraphFont))
        // highligt
        resultText.append("Customize Note Second Paragraph 04".localized().toFontWithDefaultColor(font: paragraphFont))
        resultText.append("Customize Note Second Paragraph 05".localized().toFontWithDefaultColor(font: paragraphFont))
        resultText.append("Customize Note Second Paragraph 06".localized().toFontWithDefaultColor(font: paragraphBoldFont))
        resultText.append("Customize Note Second Paragraph 07".localized().toFontWithDefaultColor(font: paragraphItalicFont))
        let customize2P08 = "Customize Note First Paragraph 08".localized().toFontWithDefaultColor(font: paragraphFont)
        customize1P06.addAttribute(.underlineStyle, value: underlineNumber, range: NSRange(location: 0, length: customize1P06.length))
        resultText.append(customize2P08)
        resultText.append("Customize Note Second Paragraph 09".localized().toFontWithDefaultColor(font: paragraphFont))
        resultText.append("Customize Note Second Paragraph 10".localized().toFontWithDefaultColor(font: paragraphBoldFont))
        resultText.append("Customize Note Second Paragraph 11".localized().toFontWithDefaultColor(font: paragraphFont))
        resultText.append("Customize Note Second Paragraph 12".localized().toFontWithDefaultColor(font: paragraphBoldFont))
        resultText.append(breakLine)
        resultText.append("Customize Note Third Paragraph 01".localized().toFontWithDefaultColor(font: paragraphFont))
        resultText.append("Customize Note Third Paragraph 02".localized().toFontWithDefaultColor(font: paragraphBoldFont))
        resultText.append("Customize Note Third Paragraph 03".localized().toFontWithDefaultColor(font: paragraphItalicFont))
        resultText.append("Customize Note Third Paragraph 04".localized().toFontWithDefaultColor(font: paragraphBoldFont))
        resultText.append("Customize Note Third Paragraph 05".localized().toFontWithDefaultColor(font: paragraphItalicFont))
        resultText.append("Customize Note Third Paragraph 06".localized().toFontWithDefaultColor(font: paragraphFont))
        resultText.append("Customize Note Third Paragraph 07".localized().toFontWithDefaultColor(font: paragraphBoldFont))
        resultText.append("Customize Note Third Paragraph 08".localized().toFontWithDefaultColor(font: paragraphItalicFont))
        resultText.append(breakLine)
        resultText.append("Customize Note Forth Paragraph 01".localized().toFontWithDefaultColor(font: paragraphFont))
        resultText.append(breakLine)
        resultText.append(breakLine)
        resultText.append("Customize Note Fifth Paragraph 01".localized().toFontWithDefaultColor(font: headerFont))
        resultText.append(breakLine)
        resultText.append(breakLine)
        resultText.append("Customize Note Fifth Paragraph 02".localized().toFontWithDefaultColor(font: paragraphFont))
        resultText.append(breakLine)
        resultText.append("Customize Note Fifth Paragraph 03".localized().toFontWithDefaultColor(font: paragraphBoldFont))
        // A partir daqui precisa ser bullet
        resultText.append(breakLine)
        resultText.append("Customize Note Fifth Paragraph 04".localized().toFontWithDefaultColor(font: paragraphFont))
        let customize4P04 = "Customize Note Fifth Paragraph 05".localized().toFontWithDefaultColor(font: paragraphFont)
        customize4P04.addAttribute(.underlineStyle, value: underlineNumber, range: NSRange(location: 0, length: customize1P06.length))
        resultText.append(customize4P04)
        resultText.append(breakLine)
        resultText.append("Customize Note Fifth Paragraph 06".localized().toFontWithDefaultColor(font: paragraphFont))
        resultText.append("Customize Note Fifth Paragraph 07".localized().toFontWithDefaultColor(font: paragraphBoldFont))
        resultText.append(breakLine)
        resultText.append("Customize Note Fifth Paragraph 08".localized().toFontWithDefaultColor(font: paragraphFont))
        resultText.append("Customize Note Fifth Paragraph 09".localized().toFontWithDefaultColor(font: paragraphItalicFont))
        // fazer ser highlight
        resultText.append("Customize Note Fifth Paragraph 10".localized().toFontWithDefaultColor(font: paragraphFont))
        
        return resultText
    }
    
    static func buildIndexTitle() -> NSAttributedString {
        return "Index Note Title".localized().toFontWithDefaultColor(font: headerFont)
    }
    
    static func buildIndexText() -> NSAttributedString {
        let resultText = NSMutableAttributedString()
        let underlineNumber = NSNumber.init(value: NSUnderlineStyle.single.rawValue)
        
        resultText.append("Index First Paragraph 01".localized().toFontWithDefaultColor(font: headerFont))
        resultText.append(breakLine)
        resultText.append(breakLine)
        resultText.append("Index First Paragraph 02".localized().toFontWithDefaultColor(font: paragraphFont))
        resultText.append("Index First Paragraph 03".localized().toFontWithDefaultColor(font: paragraphBoldFont))
        resultText.append("Index First Paragraph 04".localized().toFontWithDefaultColor(font: paragraphFont))
        let index1P05 = "CIndex First Paragraph 05".localized().toFontWithDefaultColor(font: paragraphFont)
        index1P05.addAttribute(.underlineStyle, value: underlineNumber, range: NSRange(location: 0, length: index1P05.length))
        resultText.append(index1P05)
        resultText.append(breakLine)
        // deixar highlight
        resultText.append("Index First Paragraph 06".localized().toFontWithDefaultColor(font: paragraphFont))
        resultText.append(breakLine)
        // Parei em "Você pode criar vários cabeçalhos
        
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

