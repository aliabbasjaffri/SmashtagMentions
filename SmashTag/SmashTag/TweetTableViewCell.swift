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
    
    var colors = [UIColor.brownColor() , UIColor.blueColor(), UIColor.redColor(), UIColor.darkGrayColor(), UIColor.purpleColor() , UIColor.orangeColor(), UIColor.magentaColor()]
    
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
            let tweetString = tweet.text as NSString
            
            tweetText?.text = tweet.text
            
            if tweetText?.text != nil
            {
                if (tweetString.containsString("#") || tweetString.containsString("@"))
                {
                    let attributedString = NSMutableAttributedString(string: tweet.text)
                    
                    let hashtags:[String] =  tweetString.componentsSeparatedByString(" ").filter({ $0.containsString("#") || $0.containsString("@") })
                    
                    for word in hashtags
                    {
                        let range = tweetString.rangeOfString(word)
                        let randomIndex = Int(arc4random_uniform(UInt32(colors.count)))
                        attributedString.addAttribute(NSForegroundColorAttributeName, value: colors[randomIndex], range: range)
                    }
                    tweetText.attributedText = attributedString
                }
                
                for _ in tweet.media
                {
                    tweetText.text! += " 📷"
                }
                
                for _ in tweet.urls
                {
                    tweetText.text! += "@@URL@@"
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
