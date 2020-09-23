//
//  NotesViewController.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 21/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

public class NotesViewController: UIViewController {

    private lazy var btnBack: UIButton = {
        let btn = UIButton(frame: .zero)
        btn.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        btn.addTarget(self, action: #selector(btnBackTap(_:)), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tintColor = UIColor(named: "Highlight")

        return btn
    }()
    
    private var textField: MarkupTextField = {
        return MarkupTextField(frame: .zero, placeholder: "Your Title".localized(), paddingSpace: 4)
    }()
    
    private lazy var keyboardToolbar: MarkupToolBar = {
        return MarkupToolBar(frame: .zero, owner: textView, controller: self)
    }()
    
    private lazy var textView: MarkupTextView = {
        return MarkupTextView(
            frame: .zero,
            delegate: self.textViewDelegate ?? MarkupTextViewDelegate()
        )
    }()
    
    private var textViewDelegate: MarkupTextViewDelegate?
    
    var imageView: UIImageView!

    public var isBtnBackHidden: Bool {
        get {
            return btnBack.isHidden
        }
        set {
            btnBack.isHidden = newValue
        }
    }

    public override func viewDidLoad() {
        view.addSubview(btnBack)
        let dev = UIDevice.current.userInterfaceIdiom
        if dev == .phone {
            btnBack.isHidden = UIDevice.current.orientation.isLandscape
        } else if dev == .pad {
            btnBack.isHidden = true
        }
        
        setUpTextView()
        setUpTextField()
        self.view.backgroundColor = UIColor(named: "Background")
        
        imageView = UIImageView(image: UIImage(systemName: "ant.fill"))
        textView.addSubview(imageView)
        
        textView.inputAccessoryView = keyboardToolbar
    }

    public override func viewDidLayoutSubviews() {
        NSLayoutConstraint.activate([
            btnBack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            btnBack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20)
        ])
        
        setUpTextFieldConstraints()
        setUpTextViewConstraints()
        
        imageView.frame = CGRect(x: 0, y: 50, width: 100, height: 100)
        
        let exclusionPath = UIBezierPath(rect: imageView.frame)
        textView.textContainer.exclusionPaths = [exclusionPath]
    }
    
    /**
     This method is responsible for setting the title UITextField on the main view.
     */
    private func setUpTextField() {
        self.view.addSubview(textField)
    }
    
    /**
     This method sets the UITextView that will receive the markup text. The method sets the UITextView delegate and sets the attributed text of the view. Also, the method calls the delegate function that displays the placeholder.
     */
    private func setUpTextView() {
        textViewDelegate = MarkupTextViewDelegate()
        textViewDelegate?.markdownAttributesChanged = { [weak self](attributtedString, error) in
            if let error = error {
                NSLog("Error requesting -> \(error)")
                return
            }
          
            guard let attributedText = attributtedString else {
                NSLog("No error nor string found")
                return
            }
          
            self?.textView.attributedText = attributedText
        }
        self.view.addSubview(textView)
        self.textViewDelegate?.parsePlaceholder(on: self.textView)
    }
    
    /**
     This private function sets the constraints for the UITextView on the screen.
     */
    private func setUpTextViewConstraints() {
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: self.textField.bottomAnchor, constant: 10),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    /**
     This private function sets the constraints for the UITextField on the screen.
     */
    private func setUpTextFieldConstraints() {
        NSLayoutConstraint.activate([
            textField.heightAnchor.constraint(equalToConstant: 30),
            textField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 50 + btnBack.frame.height),
            textField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }

    ///Go back to the previous step(opens the notebook index) according to the device and orientation
    @IBAction func btnBackTap(_ sender: UIButton) {
        let dev = UIDevice.current.userInterfaceIdiom
        if dev == .pad {
            splitViewController?.preferredDisplayMode = .primaryOverlay
        } else {
            if UIDevice.current.orientation.isLandscape {
                splitViewController?.preferredDisplayMode = .primaryOverlay
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
