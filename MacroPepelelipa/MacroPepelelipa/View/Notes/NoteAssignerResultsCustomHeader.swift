//
//  NoteAssignerResultsCustomHeader.swift
//  MacroPepelelipa
//
//  Created by Pedro Henrique Guedes Silveira on 18/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import Foundation
import UIKit

class NoteAssignerResultsCustomHeader: UITableViewHeaderFooterView {
        
    internal var title: UILabel = {
        let label = UILabel()  
        label.font = UIFont.defaultFont.toStyle(.paragraph)
        label.tintColor = UIColor.red
        label.text = "OIEEEE"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor.rootColor
        configureContents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureContents() {

        contentView.addSubview(title)

        NSLayoutConstraint.activate([
            
            title.heightAnchor.constraint(equalToConstant: 40),
            title.widthAnchor.constraint(equalToConstant: 200),
            title.topAnchor.constraint(equalTo: contentView.topAnchor),
            title.leadingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    internal class func cellID() -> String {
        "noteAssignerResultSectionHeader"
    }
}
