//
//  MarkupViewController.swift
//  MacroPepelelipa
//
//  Created by Lia Kassardjian on 17/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal class MarkupViewController: UIViewController {
    
    private lazy var textView: MarkupTextView = {
        return MarkupTextView(
            frame: .zero,
            delegate: self.textViewDelegate ?? MarkupTextViewDelegate()
        )
    }()
    
    var imageView: UIImageView!
    
    private var textViewDelegate: MarkupTextViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextView()
        
        imageView = UIImageView(image: UIImage(systemName: "ant.fill"))
        textView.addSubview(imageView)
    }
    
    override func viewDidLayoutSubviews() {
        NSLayoutConstraint.activate([
            textView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            textView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor),
            textView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            textView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor)
        ])
        
        imageView.frame = CGRect(x: 0, y: 50, width: 100, height: 100)
        
        let exclusionPath = UIBezierPath(rect: imageView.frame)
        textView.textContainer.exclusionPaths = [exclusionPath]
    }
    
    private func setUpTextView() {
        textViewDelegate = MarkupTextViewDelegate()
//        textViewDelegate?.markdownAttributesChanged = { [weak self](attributtedString, error) in
//            if let error = error {
//                NSLog("Error requesting -> \(error)")
//                return
//            }
//          
//            guard let attributedText = attributtedString else {
//                NSLog("No error nor string found")
//                return
//            }
//          
//            self?.textView.attributedText = attributedText
//        }
        self.view.addSubview(textView)
        self.textViewDelegate?.parsePlaceholder(on: self.textView)
    }

}
