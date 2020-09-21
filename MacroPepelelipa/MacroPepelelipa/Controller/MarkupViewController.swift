//
//  MarkupViewController.swift
//  MacroPepelelipa
//
//  Created by Lia Kassardjian on 17/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal class MarkupViewController: UIViewController {
    
    private var textViewDelegate: MarkupTextViewDelegate?
    private lazy var textView: MarkupTextView = MarkupTextView(
        frame: .zero,
        delegate: self.textViewDelegate ?? MarkupTextViewDelegate()
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextView()
    }
    
    override func viewDidLayoutSubviews() {
        NSLayoutConstraint.activate([
            textView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            textView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor),
            textView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            textView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor)
        ])
    }
    
    private func setUpTextView() {
        textViewDelegate = MarkupTextViewDelegate()
        textViewDelegate?.markdownAttributesChanged = { [weak self](attributtedString, error) in
            if let error = error {
                NSLog("Error requesting -> \(error)")
                return
            }
          
            guard let attributedText = attributtedString else {
                NSLog("No error nor string found")
                return
            }
          
            self?.textView.attributedText = attributedText
        }
        self.view.addSubview(textView)
        self.textViewDelegate?.parsePlaceholder(on: self.textView)
    }

}
