//
//  NotebookIndexTableViewCell.swift
//  MacroPepelelipa
//
//  Created by Leonardo Oliveira on 17/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import Database

internal class NotebookIndexTableViewCell: UITableViewCell {
    
    // MARK: - Variables and Constants
    
    private let index: NotebookIndexEntity

    private let lessonLbl: UILabel = {
        let lbl = UILabel(frame: .zero)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.defaultHeader.toStyle(.h2)
        lbl.adjustsFontSizeToFitWidth = true

        return lbl
    }()
    
    private var selectedView: UIView = {
        let stdView = UIView(frame: .zero)
        stdView.layer.cornerRadius = 15
        stdView.backgroundColor = .actionColor
        stdView.translatesAutoresizingMaskIntoConstraints = false
        
        return stdView
    }()

    ///Title of the lesson
    internal var indexText: String? {
        get {
            return lessonLbl.text
        }
        set {
            lessonLbl.text = newValue
            
            if let value = newValue {
                self.accessibilityHint = String(format: "Index hint".localized(), value)
            }
        }
    }
    
    internal var indexNote: NoteEntity? {
        return index.note
    }
    
    // MARK: - Initializers

    internal init(index: NotebookIndexEntity) {
        self.index = index
        super.init(style: .default, reuseIdentifier: nil)
        self.backgroundColor = .clear
        
        if index.isTitle == true {
            lessonLbl.font = lessonLbl.font.withSize(20)
            lessonLbl.font = lessonLbl.font.bold()
        } else {
            lessonLbl.font = lessonLbl.font.withSize(18)
        }
        
        contentView.addSubview(selectedView)
        contentView.addSubview(lessonLbl)
        
        var title = index.index
        
        if title == "" {
            title = "Untitled".localized()
        }
        
        indexText = title
        setupConstraints()
    }

    internal required convenience init?(coder: NSCoder) {
        guard let index = coder.decodeObject(forKey: "index") as? NotebookIndexEntity else {
            return nil
        }
        self.init(index: index)
    }
    
    // MARK: - Override functions
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected && index.isTitle {
            selectedView.isHidden = false
            self.selectionStyle = .none
            lessonLbl.textColor = UIColor.white
        } else {
            selectedView.isHidden = true
            self.selectionStyle = .none
            lessonLbl.textColor = .titleColor
        }
    }
    
    // MARK: - Functions

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            lessonLbl.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            lessonLbl.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: index.isTitle ? 20 : 40),
            lessonLbl.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),
            lessonLbl.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            selectedView.leadingAnchor.constraint(equalTo: lessonLbl.leadingAnchor, constant: -10),
            selectedView.trailingAnchor.constraint(equalTo: lessonLbl.trailingAnchor, constant: 10),
            selectedView.heightAnchor.constraint(equalTo: lessonLbl.heightAnchor, multiplier: 1.0)
        ])
    }
}
