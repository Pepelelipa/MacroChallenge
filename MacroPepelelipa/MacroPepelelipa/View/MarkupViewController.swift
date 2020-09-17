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
        delegate: self.textViewDelegate ?? MarkupTextViewDelegate(renderer: MarkupRenderer(baseFont: .systemFont(ofSize: 16)))
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
        textViewDelegate = MarkupTextViewDelegate(renderer: MarkupRenderer(baseFont: .systemFont(ofSize: 16)))
        
        self.view.addSubview(textView)
    }

}
