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
    
    private lazy var pageControl: UIPageControl = {
        let pg = UIPageControl(frame: .zero)
    
        pg.currentPageIndicatorTintColor = UIColor.actionColor
        pg.pageIndicatorTintColor = UIColor.toolsColor
        
        pg.translatesAutoresizingMaskIntoConstraints = false
        
        return pg
    }()
    
    private lazy var skipButton: UIBarButtonItem = {
        
        let btn = UIBarButtonItem(title: "Skip".localized(), style: .plain, target: self, action: #selector(openWorkspace))
        btn.tintColor = UIColor.actionColor
        
        btn.accessibilityHint = "Skip hint".localized()
        
        return btn
    }()
    
    private lazy var backgroundButtonView: UIView = {
        let backView = UIView(frame: .zero)
        backView.backgroundColor = UIColor.actionColor
        
        backView.layer.cornerRadius = 30
        
        backView.translatesAutoresizingMaskIntoConstraints = false
        return backView
    }()
    
    private lazy var startButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.tintColor = UIColor.bodyColor
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
    
    private var pages = [UIViewController]()
    
    // MARK: - Initializer
    
    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: .none)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate = self
    
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.backgroundColor = .clear
        self.navigationItem.rightBarButtonItem = skipButton
        
        let initialPage = 0
        setViews()
        setViewControllers([pages[initialPage]], direction: .forward, animated: true, completion: nil)
        
        pageControl.numberOfPages = self.pages.count
        pageControl.currentPage = initialPage
        view.addSubview(pageControl)
        setFixedConstraints()
        view.addSubview(backgroundButtonView)
        view.addSubview(startButton)
        setButtonConstraints()
        startButton.isHidden = true
        backgroundButtonView.isHidden = true

        view.backgroundColor = UIColor.formatColor
    }
    
    // MARK: - @objc functions
    
    @objc func openWorkspace(sender: UITapGestureRecognizer) {
        let view = WorkspaceSelectionViewController()
        view.modalPresentationStyle = .fullScreen
        self.navigationController?.setViewControllers([view], animated: true)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - Functions
    
    private func setViews() {
        let titles = ["Organisation title".localized(), "Text title".localized(), "Markdown title".localized(), "Devices title".localized(), "Transcript title".localized()]
        
        let subtitles = ["Organisation subtitle".localized(), "Text subtitle".localized(), "Markdown subtitle".localized(), "Devices subtitle".localized(), "Transcript subtitle".localized()]
        
        let images = ["Workspace Image".localized(), "Format Image".localized(), "Markdown Image".localized(), "Devices Image", "Transcript Image".localized()]
        
        for i in 0 ..< titles.count {
            let page = OnboardingViewController(title: titles[i], subtitle: subtitles[i], imageName: images[i])
            pages.append(page)
        }
        
    }
    
    private func setFixedConstraints() {
        NSLayoutConstraint.activate([
            
            pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            pageControl.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20),
            pageControl.heightAnchor.constraint(equalToConstant: 20),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setButtonConstraints() {
        NSLayoutConstraint.activate([
            backgroundButtonView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            backgroundButtonView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.06),
            backgroundButtonView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backgroundButtonView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            
            startButton.centerXAnchor.constraint(equalTo: backgroundButtonView.centerXAnchor),
            startButton.centerYAnchor.constraint(equalTo: backgroundButtonView.centerYAnchor),
            startButton.widthAnchor.constraint(equalTo: backgroundButtonView.widthAnchor),
            startButton.heightAnchor.constraint(equalTo: backgroundButtonView.heightAnchor)
        ])
    }
}

extension OnboardingPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let viewControllers = pageViewController.viewControllers {
            if let viewControllerIndex = self.pages.firstIndex(of: viewControllers[0]) {
                self.pageControl.currentPage = viewControllerIndex
            }
        }
        
        if pageControl.currentPage == 4 {
            startButton.isHidden = false
            backgroundButtonView.isHidden = false
        } else {
            startButton.isHidden = true
            backgroundButtonView.isHidden = true
        }
    }
}

extension OnboardingPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let viewControllerIndex = self.pages.firstIndex(of: viewController) {
            if viewControllerIndex == 0 {
                return self.pages.last
            } else {
                return self.pages[viewControllerIndex - 1]
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let viewControllerIndex = self.pages.firstIndex(of: viewController) {
            if viewControllerIndex < self.pages.count - 1 {
                return self.pages[viewControllerIndex + 1]
            } else {
                return self.pages.first
            }
        }
        return nil
        
    }
    
}
