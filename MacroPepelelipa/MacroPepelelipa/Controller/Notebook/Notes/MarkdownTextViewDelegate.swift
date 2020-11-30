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

fileprivate struct MarkdownObserverReference {
    weak var value: MarkdownObserver?
}

internal class AppMarkdownTextViewDelegate: MarkdownTextViewDelegate {
    
    private var markdownObservers: [MarkdownObserverReference] = []
    
    internal func addMarkdownObserver(_ observer: MarkdownObserver) {
        let reference = MarkdownObserverReference(value: observer)
        markdownObservers.append(reference)
    }
    
    internal func removeMarkdownObserver(_ observer: MarkdownObserver) {
        if let index = markdownObservers.firstIndex(where: { $0.value === observer }) {
            markdownObservers.remove(at: index)
        }
    }

    private var textObservers: [TextEditingDelegateObserverReference] = []
    
    internal func addTextObserver(_ observer: TextEditingDelegateObserver) {
        let reference = TextEditingDelegateObserverReference(value: observer)
        textObservers.append(reference)
    }
    
    internal func removeTextObserver(_ observer: TextEditingDelegateObserver) {
        if let index = textObservers.firstIndex(where: { $0.value === observer }) {
            textObservers.remove(at: index)
        }
    }

    override func textViewDidChangeSelection(_ textView: UITextView) {
        super.textViewDidChangeSelection(textView)
        for observer in markdownObservers {
            observer.value?.didChangeSelection(textView)
        }
        markdownObservers.removeAll(where: { $0.value == nil })
    }

    override func textViewDidBeginEditing(_ textView: UITextView) {
        super.textViewDidBeginEditing(textView)
        for observer in textObservers {
            observer.value?.textEditingDidBegin()
        }
        textObservers.removeAll(where: { $0.value == nil })
    }

    override func textViewDidEndEditing(_ textView: UITextView) {
        super.textViewDidEndEditing(textView)
        for observer in textObservers {
            observer.value?.textEditingDidEnd()
        }
        textObservers.removeAll(where: { $0.value == nil })
    }
}
