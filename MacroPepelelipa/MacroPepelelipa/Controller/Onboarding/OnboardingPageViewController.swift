//
//  OnboardingViewController.swift
//  MacroPepelelipa
//
//  Created by Paula Leite on 12/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

class OnboardingPageViewController: UIPageViewController {
    
    // MARK: - Variables and Constants
    
    private lazy var onboardingPageViewDataSource = OnboardingPageViewControllerDataSource(pages: pages)
    
    private lazy var onboardingPageViewDelegeta = OnboardingPageViewControllerDelegate {
        if let viewController = self.viewControllers?.first,
           let index = self.onboardingPageViewDataSource.indexFor(viewController) {
            self.pageControl.currentPage = index
            self.pageControl.isHidden = index == 4
            self.startButton.isHidden = index != 4
        }
    }
    
    private lazy var pageControl: UIPageControl = {
        let pg = UIPageControl(frame: .zero)
    
        pg.currentPageIndicatorTintColor = UIColor.actionColor
        pg.pageIndicatorTintColor = UIColor.toolsColor
        pg.addTarget(self, action: #selector(pgControlValueChanged(_:)), for: .valueChanged)
        
        pg.translatesAutoresizingMaskIntoConstraints = false
        
        return pg
    }()
    
    private lazy var skipButton: UIBarButtonItem = {
        let btn = UIBarButtonItem(title: "Skip".localized(), style: .plain, target: self, action: #selector(openWorkspace))
        btn.tintColor = UIColor.actionColor
        
        btn.accessibilityHint = "Skip hint".localized()
        
        return btn
    }()

    private lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.tintColor = UIColor.placeholderColor
        button.setBackgroundImage(UIImage(systemName: "xmark.circle"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(dismiss(_:)), for: .touchUpInside)
        button.accessibilityLabel = "Dismiss pop-up label".localized()
        button.accessibilityHint = "Dismiss collection pop-up hint".localized()
        return button
    }()
    
    private lazy var startButton: UIButton = {
        let button = RoundCornerButton(textColor: UIColor(named: "Action"), fillColor: .clear, borderColor: UIColor(named: "Action"), cornerRadius: 10)
        button.setTitle("Begin".localized(), for: .normal)
        button.titleLabel?.font = UIFont.defaultHeader.toParagraphFont()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(openWorkspace), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var page: UIView = {
        let pg = UIView(frame: .zero)
        pg.translatesAutoresizingMaskIntoConstraints = false
        
        return pg
    }()
    
    private lazy var pages: [UIViewController] = {
        var pg = [UIViewController]()
        let titles = ["Organization title".localized(), "Text title".localized(), "Markdown title".localized(), "Devices title".localized(), "Transcript title".localized()]
        
        let subtitles = ["Organization subtitle".localized(), "Text subtitle".localized(), "Markdown subtitle".localized(), "Devices subtitle".localized(), "Transcript subtitle".localized()]
        
        let images = ["Workspace Image".localized(), "Format Image".localized(), "Markdown Image".localized(), "Devices Image", "Transcript Image".localized()]
        
        for i in 0 ..< titles.count {
            let page = OnboardingViewController(title: titles[i], subtitle: subtitles[i], imageName: images[i])
            pg.append(page)
        }
        
        return pg
    }()
    
    // MARK: - Initializer
    
    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: .none)
    }
    
    required init?(coder: NSCoder) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: .none)
    }
    
    // MARK: - Override functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = onboardingPageViewDataSource
        self.delegate = onboardingPageViewDelegeta
        
        view.addSubview(dismissButton)

        if navigationController != nil {
            dismissButton.isHidden = true
            self.navigationController?.navigationBar.isTranslucent = true
            self.navigationController?.navigationBar.backgroundColor = .clear
            self.navigationItem.rightBarButtonItem = skipButton
        }
        
        let initialPage = 0
        setViewControllers([pages[initialPage]], direction: .forward, animated: true, completion: nil)
        
        pageControl.numberOfPages = self.pages.count
        pageControl.currentPage = initialPage
        view.addSubview(pageControl)
        setFixedConstraints()
        view.addSubview(startButton)
        setButtonConstraints()
        startButton.isHidden = true

        view.backgroundColor = UIColor.formatColor
    }
    
    // MARK: - @objc functions

    @objc func dismiss(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    /**
     In this function the app opens the workspace once the user has tapped the currect button
     - Parameter sender: UITapGesturRecognizer
     */
    @objc func openWorkspace(sender: UITapGestureRecognizer) {
        if let navControl = self.navigationController {
            let view = WorkspaceSelectionViewController()
            view.modalPresentationStyle = .fullScreen
            navControl.setViewControllers([view], animated: true)
            navControl.popToRootViewController(animated: true)
        } else {
            self.dismiss(animated: true)
        }
    }
    
    /**
     This is where the page changes in regard to the pressing of the buttons in the page control.
     */
    @objc func pgControlValueChanged(_ sender: UIPageControl) {
        var direction: UIPageViewController.NavigationDirection?
        if let viewController = viewControllers?.first,
           let index = pages.firstIndex(of: viewController) {
            direction = sender.currentPage > index ? .forward : .reverse
        }
        setViewControllers([pages[sender.currentPage]], direction: direction ?? .forward, animated: true)
        
        if sender.currentPage == 4 {
            self.startButton.isHidden = false
            self.pageControl.isHidden = true
        } else {
            self.startButton.isHidden = true
            self.pageControl.isHidden = false
        }
    }
    
    // MARK: - Functions
    
    /**
    Adding the constraints to the page control inside the view.
     */
    private func setFixedConstraints() {
        
        let orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
    
        if orientation == .portrait {
            NSLayoutConstraint.activate([
                pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40)
            ])
        } else {
            NSLayoutConstraint.activate([
                pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30)
            ])
        }
        
        NSLayoutConstraint.activate([
            pageControl.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20),
            pageControl.heightAnchor.constraint(equalToConstant: 20),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            dismissButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            dismissButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            dismissButton.widthAnchor.constraint(equalToConstant: 35),
            dismissButton.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
    
    /**
    Adding the constraints to the button that opens the application.
     */
    private func setButtonConstraints() {
        
        let orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
    
        if orientation == .portrait {
            NSLayoutConstraint.activate([
                startButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40)
            ])
        } else {
            NSLayoutConstraint.activate([
                startButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30)
            ])
        }
        
        NSLayoutConstraint.activate([
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            startButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.06)
        ])
    }
}
