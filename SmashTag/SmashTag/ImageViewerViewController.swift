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
            scrollView?.contentSize = imageView.frame.size
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
            scrollView?.contentSize = imageView.frame.size
            spinner?.stopAnimating()
        }
    }
    @IBAction func backButton(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
