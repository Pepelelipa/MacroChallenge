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
        label.font = UIFont.defaultFont.toStyle(.h1)
        label.tintColor = UIColor.red
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor.rootColor
        configureContents()
    }
    
    internal required convenience init?(coder: NSCoder) {
        guard let reuseIdentifier = coder.decodeObject(forKey: "reuseIdentifier") as? String? else {
            self.init(reuseIdentifier: nil)
            return 
        }
        self.init(reuseIdentifier: reuseIdentifier)
    }
    
    func configureContents() {

        contentView.addSubview(title)

        NSLayoutConstraint.activate([
            
            title.heightAnchor.constraint(equalToConstant: 40),
            title.widthAnchor.constraint(equalToConstant: 200),
            title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10)
        ])
    }
    
    internal class func cellID() -> String {
        "noteAssignerResultSectionHeader"
    }
}
