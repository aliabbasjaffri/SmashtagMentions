//
//  TweetTableViewCell.swift
//  SmashTag
//
//  Created by Ali Abbas Jaffri on 30/05/2016.
//  Copyright © 2016 Ali Abbas Jaffri. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewCell: UITableViewCell
{
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var tweeter: UILabel!
    @IBOutlet weak var createdDate: UILabel!
    @IBOutlet weak var tweeterImage: UIImageView!
    
    var tweet : Twitter.Tweet?
    {
        didSet
        {
            updateUI()
        }
    }
    
    private func updateUI()
    {
        // reset any existing tweet information
        tweetText?.attributedText = nil
        tweeter?.text = nil
        tweeterImage?.image = nil
        createdDate?.text = nil
        
        // load new information from our tweet (if any)
        if let tweet = self.tweet
        {
            tweetText?.text = tweet.text
            if tweetText?.text != nil  {
                for _ in tweet.media {
                    tweetText.text! += " 📷"
                }
            }
            
            tweeter?.text = "\(tweet.user)" // tweet.user.description
            
            if let profileImageURL = tweet.user.profileImageURL
            {
                let url = profileImageURL
                
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0))
                {
                    let contentsOfURL = NSData(contentsOfURL: url)
                    
                    dispatch_async(dispatch_get_main_queue())
                    {
                        if url == profileImageURL
                        {
                            if let imageData = contentsOfURL
                            {
                                self.tweeterImage?.image = UIImage(data: imageData)
                            }
                        }
                    }
                
                }
            }
            
            let formatter = NSDateFormatter()
            if NSDate().timeIntervalSinceDate(tweet.created) > 24*60*60 {
                formatter.dateStyle = NSDateFormatterStyle.ShortStyle
            } else {
                formatter.timeStyle = NSDateFormatterStyle.ShortStyle
            }
            createdDate?.text = formatter.stringFromDate(tweet.created)
        }
        
    }
    
}
