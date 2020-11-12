//
//  OnboardingViewController.swift
//  MacroPepelelipa
//
//  Created by Paula Leite on 12/11/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {
    private lazy var pageControl: UIPageControl = {
        let page = UIPageControl(frame: .zero)
        page.translatesAutoresizingMaskIntoConstraints = false
        
        return page
    }()
    
    private lazy var containerView: UIView = {
        let contView = UIView(frame: .zero)
        contView.translatesAutoresizingMaskIntoConstraints = false
        
        return contView
    }()
    
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
    
    private lazy var titleLabel: UILabel = {
        let lbl = UILabel(frame: .zero)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        return lbl
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let lbl = UILabel(frame: .zero)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        return lbl
    }()
    
    private lazy var imageView: UIImageView = {
        let img = UIImageView(frame: .zero)
        img.translatesAutoresizingMaskIntoConstraints = false
        
        return img
    }()
    
    var scrollView: UIScrollView?
    var views = [UIView]()
    var scrollWidth: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.backgroundColor = .clear
        
        self.navigationItem.rightBarButtonItem = skipButton
        
        setFixedConstraints()
        setViews()
        view.backgroundColor = .backgroundColor
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setScrollView()
        setPageControl()
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
        
        let page1 = configureView(title: titles[0], subtitle: subtitles[0], imageName: images[0])
        let page2 = configureView(title: titles[1], subtitle: subtitles[1], imageName: images[1])
        let page3 = configureView(title: titles[2], subtitle: subtitles[2], imageName: images[2])
        let page4 = configureView(title: titles[3], subtitle: subtitles[3], imageName: images[3])
        let page5 = configureView(title: titles[4], subtitle: subtitles[4], imageName: images[4])
        
        views.append(page1)
        views.append(page2)
        views.append(page3)
        views.append(page4)
        views.append(page5)
    }
    
    private func configureView(title: String, subtitle: String, imageName: String) -> UIView {
        setContainerConstraints()
        
        titleLabel.text = title
        titleLabel.font = UIFont.defaultHeader.toStyle(.h3)
        titleLabel.textColor = UIColor.bodyColor
        titleLabel.textAlignment = .left
        
        subtitleLabel.text = title
        subtitleLabel.numberOfLines = 2
        subtitleLabel.font = UIFont.defaultHeader.toStyle(.paragraph)
        subtitleLabel.textColor = UIColor.bodyColor
        subtitleLabel.textAlignment = .left
        
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = .scaleAspectFit
        
        page.addSubview(titleLabel)
        page.addSubview(subtitleLabel)
        page.addSubview(imageView)
        
        return page
    }
    
    private func setScrollView() {
        scrollView  = UIScrollView(frame: containerView.bounds)
        scrollWidth = containerView.frame.size.width
        guard let scrollView = scrollView else {
            return }
        containerView.addSubview(scrollView)
        
        for index in 0..<views.count {
            views[index].frame.origin.x = CGFloat(index) * containerView.frame.size.width
            scrollView.addSubview(views[index])
        }
        scrollView.contentSize = CGSize(width: Int(view.frame.size.width)*views.count, height: 0)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        scrollView.delegate = self
    }
    
    private func setPageControl() {
        pageControl.currentPage = 0
        pageControl.numberOfPages = views.count
    }
    
    private func setContainerConstraints() {
        NSLayoutConstraint.activate([
            page.topAnchor.constraint(equalTo: containerView.topAnchor),
            page.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            page.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            page.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            page.heightAnchor.constraint(equalTo: containerView.heightAnchor),
            page.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            
            imageView.topAnchor.constraint(equalTo: page.topAnchor, constant: 60),
            imageView.leadingAnchor.constraint(equalTo: page.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: page.trailingAnchor, constant: 20),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 60),
            titleLabel.leadingAnchor.constraint(equalTo: page.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: page.trailingAnchor, constant: 20),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            subtitleLabel.leadingAnchor.constraint(equalTo: page.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: page.trailingAnchor, constant: 20),
            subtitleLabel.bottomAnchor.constraint(equalTo: page.bottomAnchor)
            
        ])
    }
    
    private func setFixedConstraints() {
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            pageControl.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: 40)
        ])
    }
}

extension OnboardingViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            setIndicatorForCurrentPage()
        }
        
        func setIndicatorForCurrentPage() {
            guard let scrollView = scrollView else {
                return
            }
            let page = (scrollView.contentOffset.x)/scrollWidth
            pageControl.currentPage = Int(page)
            
            if pageControl.currentPage == 4 {
                navigationItem.rightBarButtonItem = nil
                startButton.isHidden = false
            }
    }
}
