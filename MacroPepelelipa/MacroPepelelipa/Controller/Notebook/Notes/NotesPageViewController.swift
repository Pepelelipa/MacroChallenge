//
//  NotesPageViewController.swift
//  MacroPepelelipa
//
//  Created by Leonardo Oliveira on 02/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//


import UIKit
import Database

internal class NotesPageViewController: UIPageViewController {
    
    internal private(set) var notes: [NoteEntity] = []
    private var pageControl: UIPageControl = UIPageControl(frame: .zero)
    
    internal init(notes: [NoteEntity]) {
        self.notes = notes
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: .none)
    }

    internal convenience required init?(coder: NSCoder) {
        guard let notes = coder.decodeObject(forKey: "notes") as? [NoteEntity] else {
            return nil
        }
        self.init(notes: notes)
    }

    override func viewDidLoad() {
        view.backgroundColor = .clear
        setupPageControl()
    }

    private func setupPageControl() {
        self.pageControl.numberOfPages = notes.count
        self.pageControl.currentPage = 0
        self.pageControl.isUserInteractionEnabled = true

        view.addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            pageControl.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor)
        ])
    }
}
