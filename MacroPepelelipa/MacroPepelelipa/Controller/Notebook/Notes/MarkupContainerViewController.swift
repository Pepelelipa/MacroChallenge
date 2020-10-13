//
//  MarkupContainerViewController.swift
//  MacroPepelelipa
//
//  Created by Paula Leite on 08/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

class MarkupContainerViewController: UIViewController {
    
    internal private(set) lazy var formatView: MarkupFormatView? = {
        guard let textView = self.textView, let delegate = self.delegate, let viewController = self.viewController else {
            return nil
        }
        
        return MarkupFormatView(frame: CGRect(x: 0, y: 0, width: preferredContentSize.width, height: preferredContentSize.height), owner: textView, delegate: delegate, viewController: viewController)
    }()
    
    private weak var viewController: NotesViewController?
    private weak var textView: MarkupTextView?
    private weak var delegate: MarkupFormatViewDelegate?

    internal init(owner: MarkupTextView? = nil, delegate: MarkupFormatViewDelegate? = nil, viewController: NotesViewController? = nil, size: CGSize) {
        super.init(nibName: nil, bundle: nil)
        self.viewController = viewController
        self.textView = owner
        self.delegate = delegate
        self.preferredContentSize = size
    }
    
    required convenience init?(coder: NSCoder) {
        self.init(size: CGSize())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.backgroundColor
        
        if let format = formatView {
            view.addSubview(format)
            format.createConstraints()
        }
    }
    
    override func viewWillLayoutSubviews() {
        formatView?.setCornerRadius()
    }
}
