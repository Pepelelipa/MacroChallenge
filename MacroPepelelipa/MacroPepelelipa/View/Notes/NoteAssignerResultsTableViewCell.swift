//
//  NoteAssignerResultsTableViewCell.swift
//  MacroPepelelipa
//
//  Created by Pedro Henrique Guedes Silveira on 16/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import MarkdownText
import Database

internal class NoteAssignerResultsTableViewCell: UITableViewCell {
    
    internal weak var notebook: NotebookEntity?
    
    internal var isTheSelectedCell: Bool = false {
        didSet {
            isSelectedImageView.isHidden = !isTheSelectedCell
        }
    }
        
    private var isSelectedImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "NoteAssignerCellCheck"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 0
        
        return imageView
    }()
    
    private lazy var notebookName: UILabel = {
        let label = UILabel()
        label.text = notebook?.name
        label.font = Fonts.defaultTextFont.toStyle(.h3)
        label.tintColor = UIColor.titleColor
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)

        return label
    }()
    
    private lazy var cellConstraints: [NSLayoutConstraint] = {
        [
            notebookName.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            notebookName.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            notebookName.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.4),
            notebookName.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5),
            
            isSelectedImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
            isSelectedImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            isSelectedImageView.widthAnchor.constraint(equalToConstant: 20),
            isSelectedImageView.heightAnchor.constraint(equalTo: isSelectedImageView.widthAnchor)  
        ] 
    }()
    
    internal init(notebook: NotebookEntity) {
        self.notebook = notebook
        super.init(style: .default, reuseIdentifier: NoteAssignerResultsTableViewCell.cellID())
        
        self.contentView.backgroundColor = UIColor.backgroundColor
        self.backgroundColor = UIColor.rootColor
        self.contentView.layer.cornerRadius = 10
        self.addSubview(isSelectedImageView)
        NSLayoutConstraint.activate(cellConstraints)
    }
    
    override func layoutMarginsDidChange() {
        super.layoutMarginsDidChange()
        self.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    override func layoutSubviews() {    
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal class func cellID() -> String {
        "NoteAssignerResultsTableViewCell"
    }
}
