//
//  OnboardingViewController.swift
//  MacroPepelelipa
//
//  Created by Paula Leite on 12/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

class OnboardingPageViewController: UIPageViewController {
    
    private lazy var pageControl: UIPageControl = {
        let pg = UIPageControl(frame: .zero)
    
        pg.currentPageIndicatorTintColor = UIColor.actionColor
        pg.pageIndicatorTintColor = UIColor.toolsColor
        
        pg.translatesAutoresizingMaskIntoConstraints = false
        
        return pg
    }()
    
//    private lazy var containerView: UIView = {
//        let contView = UIView(frame: .zero)
//        contView.translatesAutoresizingMaskIntoConstraints = false
//
//        return contView
//    }()
    
    private lazy var skipButton: UIBarButtonItem = {
        
        let btn = UIBarButtonItem(title: "Skip".localized(), style: .plain, target: self, action: #selector(openWorkspace))
        btn.tintColor = UIColor.actionColor
        
        btn.accessibilityHint = "Skip hint".localized()
        
        return btn
    }()
    
    private lazy var backgoundButtonView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.actionColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var startButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.tintColor = UIColor.backgroundColor
        button.setTitle("Start".localized(), for: .normal)
        button.titleLabel?.font = UIFont.defaultHeader.toStyle(.h3)
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
    
    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: .none)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
 
        view.backgroundColor = UIColor.formatColor
    }
    
    @objc func openWorkspace(sender: UITapGestureRecognizer) {
        let view = WorkspaceSelectionViewController()
        view.modalPresentationStyle = .fullScreen
        self.navigationController?.setViewControllers([view], animated: true)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    private func setViews() {
        let titles = ["Organisation".localized(), "Text".localized(), "Markdown".localized(), "Devices".localized(), "Transcript".localized()]
        
        let subtitles = ["Organisation subtitle".localized(), "Text subtitle".localized(), "Markdown subtitle".localized(), "Devices subtitle".localized(), "Transcript subtitle".localized()]
        
        let images = ["Workspace Image".localized(), "Format Image".localized(), "Markdown Image".localized(), "Devices Image", "Transcript Image".localized()]
        
        for i in 0 ..< titles.count {
            let page = OnboardingViewController(title: titles[i], subtitle: subtitles[i], imageName: images[i])
            pages.append(page)
        }
        
    }
    
    private func setFixedConstraints() {
        NSLayoutConstraint.activate([
//            containerView.topAnchor.constraint(equalTo: view.topAnchor),
//            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            pageControl.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20),
            pageControl.heightAnchor.constraint(equalToConstant: 20),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
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
                // go to next page in array
                return self.pages[viewControllerIndex + 1]
            } else {
                // wrap to first page in array
                return self.pages.first
            }
        }
        return nil
        
    }
    
}
