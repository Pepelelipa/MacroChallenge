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
    
    static func buildIntroductionTitle() -> NSAttributedString {
        return "Introduction Note Title".localized().toFontWithDefaultColor(font: headerFont)
    }
    
    static func buildIntroductionText() -> NSAttributedString {
        let resultText = NSMutableAttributedString()
        
        resultText.append("Introduction First Header".localized().toFontWithDefaultColor(font: headerFont))
        resultText.append(breakLine)
        resultText.append(breakLine)
        resultText.append("Introduction First Paragraph".localized().toFontWithDefaultColor(font: paragraphFont))
        resultText.append(breakLine)
        resultText.append(breakLine)
        resultText.append("Introduction Second Paragraph".localized().toFontWithDefaultColor(font: paragraphFont))
        resultText.append(breakLine)
        resultText.append(breakLine)
        resultText.append("Introduction Third Paragraph".localized().toFontWithDefaultColor(font: paragraphFont))
        resultText.append(breakLine)
        resultText.append(breakLine)
        resultText.append("Introduction Fourth Paragraph".localized().toFontWithDefaultColor(font: paragraphFont))
        
        resultText.append(breakLine)
        resultText.append(breakLine)
        resultText.append("Introduction Second Header".localized().toFontWithDefaultColor(font: headerFont))
        resultText.append(breakLine)
        resultText.append(breakLine)
        resultText.append("Introduction Fifth Paragraph".localized().toFontWithDefaultColor(font: paragraphFont))
        resultText.append(breakLine)
        resultText.append(breakLine)
        resultText.append("Introduction Sixth Paragraph".localized().toFontWithDefaultColor(font: paragraphFont))
        
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
