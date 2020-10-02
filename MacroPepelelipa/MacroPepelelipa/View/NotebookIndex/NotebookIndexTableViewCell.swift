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
    private let index: NotebookIndexEntity

    private let lessonLbl: UILabel = {
        let lbl = UILabel(frame: .zero)
        lbl.translatesAutoresizingMaskIntoConstraints = false

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
        }
    }

    init(index: NotebookIndexEntity) {
        self.index = index
        super.init(style: .default, reuseIdentifier: nil)
        self.backgroundColor = .backgroundColor
        
        if index.isTitle == true {
            lessonLbl.font = lessonLbl.font.withSize(20)
            lessonLbl.font = lessonLbl.font.bold()
        } else {
            lessonLbl.font = lessonLbl.font.withSize(18)
        }
        
        contentView.addSubview(selectedView)
        contentView.addSubview(lessonLbl)
        indexText = index.index
        setupConstraints()
    }

    required convenience init?(coder: NSCoder) {
        guard let index = coder.decodeObject(forKey: "index") as? NotebookIndexEntity else {
            return nil
        }
        self.init(index: index)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected == true {
            selectedView.isHidden = false
            self.selectionStyle = .none
            lessonLbl.textColor = .backgroundColor
        } else {
            selectedView.isHidden = true
            self.selectionStyle = .none
            lessonLbl.textColor = .titleColor
        }
    }

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
