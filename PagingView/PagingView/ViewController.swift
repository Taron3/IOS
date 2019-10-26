//
//  ViewController.swift
//  PagingView
//
//  Created by 3 on 10/23/19.
//  Copyright © 2019 Taron. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
    var pageScrollView: UIScrollView!
    var imageScrollView: UIScrollView!
    var imageView: UIImageView!
    var tap: UITapGestureRecognizer!
    
    var pageControl: UIPageControl!
    
    var page: Int {
        return Int(pageScrollView.contentOffset.x / pageScrollView.frame.width)
    }
    
    var currentImageView: UIImageView {
        guard pageScrollView.subviews.count != 0 else {
            return imageView
        }

        return pageScrollView.subviews[page].subviews.first as! UIImageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurePageScrollView()
        configureImageScrollView()
        configurePageControl()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        pageScrollView.setContentOffset(CGPoint(x: 1000, y: 0), animated: true)
    }
    
    func configurePageScrollView() {
        pageScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - 100.0))
        
        pageScrollView.isPagingEnabled = true
        pageScrollView.contentSize = CGSize(width: 10.0 * pageScrollView.bounds.width, height: 0)
        pageScrollView.delegate = self
        view.addSubview(pageScrollView)
    }
    
    func configureImageScrollView() {
        var x = 0
        let y = 0
        let w = pageScrollView.frame.width
        let h = pageScrollView.frame.height

        for _ in 1...10 {
            imageScrollView = UIScrollView(frame: CGRect(x: CGFloat(x), y: CGFloat(y), width: w, height: h) )
            
            imageScrollView.delegate = self
            imageScrollView.minimumZoomScale = 0.3
            imageScrollView.maximumZoomScale = 8
            
            pageScrollView.addSubview(imageScrollView)
            
            imageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: w, height: h) )
            imageScrollView.addSubview(imageView)
            
            initDoubleTapGesture(for: imageScrollView)
            
            getImage()
     
            x = x + Int(w)
        }
        
    }
    
    func getImage() {
        guard let image = UIImage(named: "image") else {
            return
        }
        
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageScrollView.contentSize = imageView.bounds.size
        
        centerContent()
    }
    
    
    func configurePageControl() {
        pageControl = UIPageControl(frame: CGRect(x: 0,
                                                  y: view.bounds.size.height - CGFloat(50),
                                                  width: view.bounds.width,
                                                  height: 50.0))
        pageControl.numberOfPages = 10
        pageControl.addTarget(self,
                              action: #selector(changePage(sender:)),
                              for: .valueChanged)
        pageControl.pageIndicatorTintColor = UIColor.red
        pageControl.currentPageIndicatorTintColor = UIColor.blue
        view.addSubview(pageControl)
    }
    
    @objc func changePage(sender: UIPageControl) {
        let offsetX = CGFloat(sender.currentPage) * CGFloat(pageScrollView.frame.width)
        pageScrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
    
    func initDoubleTapGesture(for view: UIView) {
        tap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(tap:)))
        tap.numberOfTapsRequired = 2
        
        view.addGestureRecognizer(tap)
    }

    @objc func handleDoubleTap(tap: UITapGestureRecognizer) {
        let currentImageScrollView = pageScrollView.subviews[page] as! UIScrollView
        
        if currentImageScrollView.zoomScale > currentImageScrollView.minimumZoomScale {
            currentImageScrollView.setZoomScale(currentImageScrollView.minimumZoomScale, animated: true)
        } else {
            let location = tap.location(in: currentImageView)
            let rect = CGRect(x: location.x, y: location.y, width: 100, height: 100)
            currentImageScrollView.zoom(to: rect, animated: true)
        }
    }
    
    func centerContent() {
        let imageViewSize = currentImageView.frame.size
        let currentImageScrollView = pageScrollView.subviews[page] as! UIScrollView
        
        var vertical: CGFloat = 0
        var horizontal: CGFloat = 0
        if imageViewSize.width < imageScrollView.bounds.size.width  {
            vertical = (imageScrollView.bounds.size.width - imageViewSize.width) / 2.0
        }
        
        if imageViewSize.height < imageScrollView.bounds.size.height  {
            horizontal = (imageScrollView.bounds.size.height - imageViewSize.height) / 2.0
        }
        
        currentImageScrollView.contentInset = UIEdgeInsets(top: vertical,
                                                           left: horizontal,
                                                           bottom: vertical,
                                                           right: horizontal)
    }
    

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = page
        
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return currentImageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerContent()
    }
        
    
}

