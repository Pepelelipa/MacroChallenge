//
//  SplitViewController.swift
//  MacroPepelelipa
//
//  Created by Leonardo Oliveira on 17/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import Database

internal class SplitViewController: UISplitViewController, NotebookIndexDelegate {

    private let master: NotebookIndexViewController
    private lazy var navController: UINavigationController = {
        let nav = UINavigationController(rootViewController: master)
        nav.isNavigationBarHidden = true
        return nav
    }()
    
    private let detail: NotesViewController

    internal init(notebook: NotebookEntity) {
        master = NotebookIndexViewController(notebook: notebook)
        let note: NoteEntity
        if let lastNote = notebook.notes.last {
            note = lastNote
        } else {
            do {
                note = try DataManager.shared().createNote(in: notebook)
                note.title = NSAttributedString(string: "Lesson".localized())
                try note.save()
            } catch {
                fatalError("Num deu")
            }
        }
        detail = NotesViewController(note: note)
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
        viewControllers = [navController, detail]
        master.delegate = self
        preferredDisplayMode = .oneOverSecondary
    }

    internal required convenience init?(coder: NSCoder) {
        guard let notebook = coder.decodeObject(forKey: "notebook") as? NotebookEntity else {
            return nil
        }
        self.init(notebook: notebook)
    }

    func indexShouldDismiss() {
        self.dismiss(animated: true)
    }

    func indexWillAppear() {
        detail.isBtnBackHidden = true
    }

    func indexWillDisappear() {
        detail.isBtnBackHidden = false
    }

    ///Animates the dismissal with our custom animation
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        if flag {
            let transition = CATransition()
            transition.duration = 0.4
            transition.type = CATransitionType.fade
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            self.view.window?.layer.add(transition, forKey: kCATransition)
        }
        super.dismiss(animated: false, completion: completion)
    }
}
