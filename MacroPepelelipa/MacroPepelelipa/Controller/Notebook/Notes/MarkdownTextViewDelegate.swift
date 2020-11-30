//
//  MarkdownTextViewDelegate.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 03/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import MarkdownText

internal protocol MarkdownObserver: class {
    func didChangeSelection(_ textView: UITextView)
}

internal class AppMarkdownTextViewDelegate: MarkdownTextViewDelegate {
    
    private var markdownObservers: [MarkdownObserver] = []
    
    internal func addMarkdownObserver(_ observer: MarkdownObserver) {
        markdownObservers.append(observer)
    }
    
    internal func removeMarkdownObserver(_ observer: MarkdownObserver) {
        if let index = markdownObservers.firstIndex(where: { $0 === observer }) {
            markdownObservers.remove(at: index)
        }
    }

    private var textObservers: [TextEditingDelegateObserver] = []
    
    internal func addTextObserver(_ observer: TextEditingDelegateObserver) {
        textObservers.append(observer)
    }
    
    internal func removeTextObserver(_ observer: TextEditingDelegateObserver) {
        if let index = textObservers.firstIndex(where: { $0 === observer }) {
            textObservers.remove(at: index)
        }
    }

    override func textViewDidChangeSelection(_ textView: UITextView) {
        super.textViewDidChangeSelection(textView)
        for observer in markdownObservers {
            observer.didChangeSelection(textView)
        }
    }

    override func textViewDidBeginEditing(_ textView: UITextView) {
        super.textViewDidBeginEditing(textView)
        for observer in textObservers {
            observer.textEditingDidBegin()
        }
    }

    override func textViewDidEndEditing(_ textView: UITextView) {
        super.textViewDidEndEditing(textView)
        for observer in textObservers {
            observer.textEditingDidEnd()
        }
    }
}
