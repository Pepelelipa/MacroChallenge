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
    
    private weak var viewController: NotesViewController?
    private weak var textView: MarkdownTextView?
    
    internal private(set) lazy var formatView: MarkdownFormatView? = {
        guard let textView = self.textView, let viewController = self.viewController else {
            return nil
        }
        
        return MarkdownFormatView(frame: CGRect(x: 0, y: 0, width: preferredContentSize.width, height: preferredContentSize.height), owner: textView, receiver: viewController)
    }()
    
    // MARK: - Initializers

    internal init(owner: MarkdownTextView? = nil, viewController: NotesViewController? = nil, size: CGSize) {
        super.init(nibName: nil, bundle: nil)
        self.viewController = viewController
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
}
