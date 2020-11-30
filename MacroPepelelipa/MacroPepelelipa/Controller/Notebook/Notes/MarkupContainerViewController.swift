//
//  MarkupContainerViewController.swift
//  MacroPepelelipa
//
//  Created by Paula Leite on 08/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import MarkdownText

internal class MarkupContainerViewController: UIViewController {
    
    // MARK: - Variables and Constants
    
    private weak var formattingDelegate: FormattingDelegate?
    private weak var textView: MarkdownTextView?
    
    internal private(set) lazy var formatView: MarkdownFormatView? = {
        guard let textView = self.textView, let formattingDelegate = self.formattingDelegate else {
            return nil
        }
        
        return MarkdownFormatView(frame: CGRect(x: 0, y: 0, width: preferredContentSize.width, height: preferredContentSize.height), owner: textView, receiver: formattingDelegate)
    }()
    
    // MARK: - Initializers

    internal init(owner: MarkdownTextView? = nil, formattingDelegate: FormattingDelegate? = nil, size: CGSize) {
        super.init(nibName: nil, bundle: nil)
        self.formattingDelegate = formattingDelegate
        self.textView = owner
        self.preferredContentSize = size
    }
    
    internal required convenience init?(coder: NSCoder) {
        self.init(size: CGSize())
    }
    
    // MARK: - Override functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.backgroundColor
        
        if let format = formatView {
            view.addSubview(format)
            format.createConstraints()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        formatView?.setCornerRadius()
    }
    
    override func viewWillLayoutSubviews() {
        formatView?.setCornerRadius()
    }
}
