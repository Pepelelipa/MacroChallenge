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
        return "Introduction Note Title".localized().toFontWithColor(font: headerFont)
    }
    
    static func buildIntroductionText() -> NSAttributedString {
        let resultText = NSMutableAttributedString()
        let underlineNumber = NSNumber.init(value: NSUnderlineStyle.single.rawValue)
        
        resultText.append("Introduction First Paragraph 01".localized().toFontWithColor(font: paragraphFont))
        resultText.append("Introduction First Paragraph 02".localized().toFontWithColor(font: paragraphBoldFont))
        resultText.append("Introduction First Paragraph 03".localized().toFontWithColor(font: paragraphFont))
        resultText.append("Introduction First Paragraph 04".localized().toFontWithColor(font: paragraphItalicFont))
        resultText.append("Introduction First Paragraph 05".localized().toFontWithColor(font: paragraphFont))
        resultText.append("Introduction First Paragraph 06".localized().toFontWithColor(font: paragraphItalicFont))
        
        resultText.append(breakLine)
        resultText.append(breakLine)
        resultText.append("Introduction Second Paragraph 01".localized().toFontWithColor(font: paragraphFont))
        let intro2P02 = "Introduction Second Paragraph 02".localized().toFontWithColor(font: paragraphFont)
        intro2P02.addAttribute(.underlineStyle, value: underlineNumber, range: NSRange(location: 0, length: intro2P02.length))
        resultText.append(intro2P02)
        resultText.append("Introduction Second Paragraph 03".localized().toFontWithColor(font: paragraphFont))
        
        resultText.append(breakLine)
        resultText.append(breakLine)
        // Precisa adicionar o highlight em "Mac, iPhone e iPad"
        resultText.append("Introduction Third Paragraph 01".localized().toFontWithColor(font: paragraphFont))
        resultText.append("Introduction Third Paragraph 02".localized().toFontWithColor(backgroundColor: .highlightColor, font: paragraphFont))
        resultText.append("Introduction Third Paragraph 03".localized().toFontWithColor(font: paragraphFont))
        resultText.append("Introduction Third Paragraph 04".localized().toFontWithColor(font: paragraphBoldFont))
        resultText.append("Introduction Third Paragraph 05".localized().toFontWithColor(font: paragraphFont))
        
        resultText.append(breakLine)
        resultText.append(breakLine)
        resultText.append("Introduction Fourth Paragraph 01".localized().toFontWithColor(font: paragraphFont))
        let intro4P02 = "Introduction Fourth Paragraph 02".localized().toFontWithColor(font: paragraphItalicFont)
        intro4P02.addAttribute(.underlineStyle, value: underlineNumber, range: NSRange(location: 0, length: intro4P02.length))
        // Fazer highlight
        resultText.append(intro4P02)
        resultText.append("Introduction Fourth Paragraph 03".localized().toFontWithColor(font: paragraphFont))
        let intro4P04 = "Introduction Fourth Paragraph 04".localized().toFontWithColor(backgroundColor: .highlightColor, font: paragraphItalicFont)
        intro4P04.addAttribute(.underlineStyle, value: underlineNumber, range: NSRange(location: 0, length: intro4P04.length))
        resultText.append(intro4P04)
        
        resultText.append(breakLine)
        resultText.append(breakLine)
        resultText.append("Introduction Fifth Paragraph 01".localized().toFontWithColor(font: paragraphFont))
        resultText.append("Introduction Fifth Paragraph 02".localized().toFontWithColor(font: paragraphBoldFont))
        resultText.append("Introduction Fifth Paragraph 03".localized().toFontWithColor(font: paragraphFont))
        resultText.append("Introduction Fifth Paragraph 04".localized().toFontWithColor(color: .notebookColors[4], font: paragraphFont))
        resultText.append("Introduction Fifth Paragraph 05".localized().toFontWithColor(font: paragraphFont))
        
        return resultText
    }
    
    static func buildCustomizeTitle() -> NSAttributedString {
        return "Customize Note Title".localized().toFontWithColor(font: headerFont)
    }
    
    static func buildCustomizeText() -> NSAttributedString {
        let resultText = NSMutableAttributedString()
        let underlineNumber = NSNumber.init(value: NSUnderlineStyle.single.rawValue)
        
        resultText.append("Customize Note First Paragraph 01".localized().toFontWithColor(font: headerFont))
        resultText.append(breakLine)
        resultText.append(breakLine)
        resultText.append("Customize Note First Paragraph 02".localized().toFontWithColor(font: paragraphFont))
        resultText.append("Customize Note First Paragraph 03".localized().toFontWithColor(font: paragraphBoldFont))
        // Adicionar highlight
        resultText.append("Customize Note First Paragraph 04".localized().toFontWithColor(font: paragraphFont))
        resultText.append("Customize Note First Paragraph 05".localized().toFontWithColor(font: paragraphFont))
        let customize1P06 = "Customize Note First Paragraph 06".localized().toFontWithColor(font: paragraphFont)
        customize1P06.addAttribute(.underlineStyle, value: underlineNumber, range: NSRange(location: 0, length: customize1P06.length))
        resultText.append(customize1P06)
        resultText.append(breakLine)
        resultText.append(breakLine)
        resultText.append("Customize Note Second Paragraph 01".localized().toFontWithColor(font: paragraphFont))
        resultText.append("Customize Note Second Paragraph 02".localized().toFontWithColor(font: paragraphBoldFont))
        resultText.append("Customize Note Second Paragraph 03".localized().toFontWithColor(color: .notebookColors[4], font: paragraphFont))
        // highligt
        resultText.append("Customize Note Second Paragraph 04".localized().toFontWithColor(font: paragraphFont))
        resultText.append("Customize Note Second Paragraph 05".localized().toFontWithColor(font: paragraphFont))
        resultText.append("Customize Note Second Paragraph 06".localized().toFontWithColor(font: paragraphBoldFont))
        resultText.append("Customize Note Second Paragraph 07".localized().toFontWithColor(font: paragraphItalicFont))
        let customize2P08 = "Customize Note First Paragraph 08".localized().toFontWithColor(font: paragraphFont)
        customize1P06.addAttribute(.underlineStyle, value: underlineNumber, range: NSRange(location: 0, length: customize1P06.length))
        resultText.append(customize2P08)
        resultText.append("Customize Note Second Paragraph 09".localized().toFontWithColor(font: paragraphFont))
        resultText.append("Customize Note Second Paragraph 10".localized().toFontWithColor(font: paragraphBoldFont))
        resultText.append("Customize Note Second Paragraph 11".localized().toFontWithColor(font: paragraphFont))
        resultText.append("Customize Note Second Paragraph 12".localized().toFontWithColor(font: paragraphBoldFont))
        resultText.append(breakLine)
        resultText.append(breakLine)
        resultText.append("Customize Note Third Paragraph 01".localized().toFontWithColor(font: paragraphFont))
        resultText.append("Customize Note Third Paragraph 02".localized().toFontWithColor(font: paragraphBoldFont))
        resultText.append("Customize Note Third Paragraph 03".localized().toFontWithColor(font: paragraphItalicFont))
        resultText.append("Customize Note Third Paragraph 04".localized().toFontWithColor(font: paragraphBoldFont))
        resultText.append("Customize Note Third Paragraph 05".localized().toFontWithColor(font: paragraphItalicFont))
        resultText.append("Customize Note Third Paragraph 06".localized().toFontWithColor(font: paragraphFont))
        resultText.append("Customize Note Third Paragraph 07".localized().toFontWithColor(font: paragraphBoldFont))
        resultText.append("Customize Note Third Paragraph 08".localized().toFontWithColor(font: paragraphItalicFont))
        resultText.append(breakLine)
        resultText.append(breakLine)
        resultText.append("Customize Note Forth Paragraph 01".localized().toFontWithColor(font: paragraphFont))
        resultText.append(breakLine)
        resultText.append(breakLine)
        resultText.append("Customize Note Fifth Paragraph 01".localized().toFontWithColor(font: headerFont))
        resultText.append(breakLine)
        resultText.append(breakLine)
        resultText.append("Customize Note Fifth Paragraph 02".localized().toFontWithColor(font: paragraphFont))
        resultText.append(breakLine)
        resultText.append(breakLine)
        resultText.append("Customize Note Fifth Paragraph 03".localized().toFontWithColor(font: paragraphBoldFont))
        // A partir daqui precisa ser bullet
        resultText.append(breakLine)
        resultText.append(breakLine)
        resultText.append("Customize Note Fifth Paragraph 04".localized().toFontWithBullet(font: paragraphFont))
        let customize4P04 = "Customize Note Fifth Paragraph 05".localized().toFontWithColor(font: paragraphFont)
        customize4P04.addAttribute(.underlineStyle, value: underlineNumber, range: NSRange(location: 0, length: customize4P04.length))
        resultText.append(customize4P04)
        resultText.append(breakLine)
        resultText.append(breakLine)
        resultText.append("Customize Note Fifth Paragraph 06".localized().toFontWithColor(font: paragraphFont))
        resultText.append("Customize Note Fifth Paragraph 07".localized().toFontWithColor(font: paragraphBoldFont))
        resultText.append(breakLine)
        resultText.append(breakLine)
        resultText.append("Customize Note Fifth Paragraph 08".localized().toFontWithColor(font: paragraphFont))
        resultText.append("Customize Note Fifth Paragraph 09".localized().toFontWithColor(font: paragraphItalicFont))
        // fazer ser highlight
        resultText.append("Customize Note Fifth Paragraph 10".localized().toFontWithColor(font: paragraphFont))
        
        return resultText
    }
    
    static func buildIndexTitle() -> NSAttributedString {
        return "Index Note Title".localized().toFontWithColor(font: headerFont)
    }
    
    static func buildIndexText() -> NSAttributedString {
        let resultText = NSMutableAttributedString()
        let underlineNumber = NSNumber.init(value: NSUnderlineStyle.single.rawValue)
        
        resultText.append("Index First Paragraph 01".localized().toFontWithColor(font: headerFont))
        resultText.append(breakLine)
        resultText.append(breakLine)
        resultText.append("Index First Paragraph 02".localized().toFontWithColor(font: paragraphFont))
        resultText.append("Index First Paragraph 03".localized().toFontWithColor(font: paragraphBoldFont))
        resultText.append("Index First Paragraph 04".localized().toFontWithColor(font: paragraphFont))
        let index1P05 = "Index First Paragraph 05".localized().toFontWithColor(font: paragraphFont)
        index1P05.addAttribute(.underlineStyle, value: underlineNumber, range: NSRange(location: 0, length: index1P05.length))
        resultText.append(index1P05)
        resultText.append(breakLine)
        resultText.append(breakLine)
        // deixar highlight
        resultText.append("Index First Paragraph 06".localized().toFontWithColor(font: paragraphFont))
        resultText.append(breakLine)
        resultText.append(breakLine)
        resultText.append("Index First Paragraph 07".localized().toFontWithColor(font: paragraphBoldFont))
        resultText.append("Index First Paragraph 08".localized().toFontWithColor(font: paragraphFont))
        let index1P09 = "Index First Paragraph 09".localized().toFontWithColor(font: paragraphFont)
        index1P09.addAttribute(.underlineStyle, value: underlineNumber, range: NSRange(location: 0, length: index1P09.length))
        resultText.append(index1P09)
        resultText.append("Index First Paragraph 10".localized().toFontWithColor(font: paragraphFont))
        resultText.append(breakLine)
        resultText.append(breakLine)
        resultText.append("Index First Paragraph 11".localized().toFontWithColor(color: .notebookColors[4], font: paragraphFont))
        resultText.append(breakLine)
        resultText.append(breakLine)
        resultText.append("Index Hierarchy Title".localized().toFontWithColor(font: headerFont))
        resultText.append(breakLine)
        resultText.append(breakLine)
        resultText.append("Index Hierarchy First Paragraph 01".localized().toFontWithColor(font: paragraphBoldFont))
        resultText.append("Index Hierarchy First Paragraph 02".localized().toFontWithColor(font: paragraphItalicFont))
        // Colocar highlight
        resultText.append("Index Hierarchy First Paragraph 03".localized().toFontWithColor(font: paragraphFont))
        resultText.append(breakLine)
        resultText.append(breakLine)
        // Deixar amarelo
        resultText.append("Index Hierarchy Second Paragraph 01".localized().toFontWithColor(font: paragraphFont))
        resultText.append("Index Hierarchy Second Paragraph 02".localized().toFontWithColor(font: paragraphFont))
        resultText.append("Index Hierarchy Second Paragraph 03".localized().toFontWithColor(font: paragraphBoldFont))
        resultText.append("Index Hierarchy Second Paragraph 04".localized().toFontWithColor(font: paragraphFont))
        // Deixar highlight
        resultText.append("Index Hierarchy Second Paragraph 05".localized().toFontWithColor(font: paragraphFont))
        resultText.append(breakLine)
        resultText.append(breakLine)
        resultText.append("Index Hierarchy Third Paragraph 01".localized().toFontWithColor(font: paragraphFont))
        let indexHierarchy3P02 = "Index Hierarchy Third Paragraph 02".localized().toFontWithColor(font: paragraphFont)
        indexHierarchy3P02.addAttribute(.underlineStyle, value: underlineNumber, range: NSRange(location: 0, length: indexHierarchy3P02.length))
        resultText.append(indexHierarchy3P02)
        resultText.append("Index Hierarchy Third Paragraph 03".localized().toFontWithColor(font: paragraphFont))
        
        return resultText
    }
    
    static func buildExamplesTitle() -> NSAttributedString {
        return "Examples Note 1 Title".localized().toFontWithColor(font: headerFont)
    }
    
    static func buildExamplesText() -> NSAttributedString {
        let resultText = NSMutableAttributedString()
        
        resultText.append("Examples First Header".localized().toFontWithColor(font: headerFont))
        resultText.append(breakLine)
        resultText.append(breakLine)
        resultText.append("Examples First Paragraph".localized().toFontWithColor(font: paragraphFont))
        
        return resultText
    }
    
}

