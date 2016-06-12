//
//  ImageViewerViewController.swift
//  SmashTag
//
//  Created by Ali Abbas Jaffri on 12/06/2016.
//  Copyright © 2016 Ali Abbas Jaffri. All rights reserved.
//

import UIKit

class ImageViewerViewController: UIViewController, UIScrollViewDelegate
{
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var scrollView: UIScrollView!
    {
        didSet
        {
            scrollView?.contentSize = imageView.bounds.size
            scrollView.delegate = self
            scrollView.minimumZoomScale = 0.25
            scrollView.maximumZoomScale = 2.5
        }
    }
    private var imageView = UIImageView()
    
    private var image : UIImage?
        {
        get
        {
            return imageView.image
        }
        set
        {
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.bounds.size
            spinner?.stopAnimating()
        }
    }
    
    var imageURL : NSURL?
    {
        didSet
        {
            image = nil
            if view.window != nil
            {
                fetchImage()
            }
        }
    }
    
    private func fetchImage()
    {
        if let url = imageURL
        {
            spinner?.startAnimating()
            
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0))
            {
                let contentsOfURL = NSData(contentsOfURL: url)
                
                dispatch_async(dispatch_get_main_queue())
                {
                    if url == self.imageURL
                    {
                        if let imageData = contentsOfURL
                        {
                            self.image = UIImage(data: imageData)
                        }
                        else
                        {
                            self.spinner?.stopAnimating()
                        }
                    }
                }
            }
        }
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(imageView)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if image == nil
        {
            fetchImage()
        }
    }
}
