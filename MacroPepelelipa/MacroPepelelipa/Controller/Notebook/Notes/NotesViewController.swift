//
//  NotesViewController.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 21/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import Database

internal class NotesViewController: UIViewController, TextEditingDelegateObserver {

    internal private(set) weak var note: NoteEntity?
    internal init(note: NoteEntity) {
        self.note = note
        super.init(nibName: nil, bundle: nil)
        self.textField.attributedText = note.title
    }

    internal convenience required init?(coder: NSCoder) {
        guard let note = coder.decodeObject(forKey: "note") as? NoteEntity else {
            return nil
        }
        self.init(note: note)
    }

    private lazy var imageButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(named: "imageButton"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func textEditingDidBegin() {
        DispatchQueue.main.async {
            self.imageButton.isHidden = true
        }
    }
    
    func textEditingDidEnd() {
        DispatchQueue.main.async {
            self.imageButton.isHidden = false
        }
    }

    private lazy var btnBack: UIButton = {
        let btn = UIButton(frame: .zero)
        btn.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        btn.addTarget(self, action: #selector(btnBackTap(_:)), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tintColor = UIColor(named: "Highlight")

        return btn
    }()
    public var isBtnBackHidden: Bool {
        get {
            return btnBack.isHidden
        }
        set {
            btnBack.isHidden = newValue
        }
    }
    ///Go back to the previous step(opens the notebook index) according to the device and orientation
    @IBAction func btnBackTap(_ sender: UIButton) {
        let dev = UIDevice.current.userInterfaceIdiom
        if dev == .pad {
            splitViewController?.preferredDisplayMode = .oneOverSecondary
        } else {
            if UIDevice.current.orientation.isLandscape {
                splitViewController?.preferredDisplayMode = .oneOverSecondary
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    private lazy var textField: MarkupTextField = {
        let textField = MarkupTextField(frame: .zero, placeholder: "Your Title".localized(), paddingSpace: 4)
        textField.delegate = self.textFieldDelegate
        return textField
    }()
    private lazy var textFieldDelegate: MarkupTextFieldDelegate = {
        let delegate = MarkupTextFieldDelegate()
        delegate.observer = self
        return delegate
    }()
    private lazy var textView: MarkupTextView = MarkupTextView(frame: .zero, delegate: self.textViewDelegate)
    private lazy var textViewDelegate: MarkupTextViewDelegate? = {
        let delegate = MarkupTextViewDelegate()
        delegate.observer = self
        DispatchQueue.main.async {
            delegate.markdownAttributesChanged = { [unowned self](attributtedString, error) in
                if let error = error {
                    NSLog("Error requesting -> \(error)")
                    return
                }

                guard let attributedText = attributtedString else {
                    NSLog("No error nor string found")
                    return
                }

                self.textView.attributedText = attributedText
            }
            delegate.parsePlaceholder(on: self.textView)
        }
        return delegate
    }()
    private lazy var keyboardToolbar: MarkupToolBar = MarkupToolBar(frame: .zero, owner: textView, controller: self)

    public override func viewDidLoad() {
        view.addSubview(btnBack)
        let dev = UIDevice.current.userInterfaceIdiom
        if dev == .phone {
            btnBack.isHidden = UIDevice.current.orientation.isLandscape
        } else if dev == .pad {
            btnBack.isHidden = true
        }

        view.addSubview(textField)
        view.addSubview(textView)
        view.addSubview(imageButton)
        self.view.backgroundColor = UIColor(named: "Background")
        
        textView.inputAccessoryView = keyboardToolbar
    }

    public override func viewDidLayoutSubviews() {
        NSLayoutConstraint.activate([
            imageButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -150),
            imageButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            btnBack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            btnBack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20)
        ])

        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: self.textField.bottomAnchor, constant: 10),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            textField.heightAnchor.constraint(equalToConstant: 30),
            textField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 50 + btnBack.frame.height),
            textField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
}
