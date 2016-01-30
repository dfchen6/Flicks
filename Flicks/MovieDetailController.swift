//
//  MovieDetailController.swift
//  Flicks
//
//  Created by Difan Chen on 1/28/16.
//  Copyright © 2016 Difan Chen. All rights reserved.
//

import UIKit

class MovieDetailController: UIViewController {

    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var movieTitle: UILabel!
    var titleStringViaSegue: String!
    var overviewViaSegue: String!
    var imageURLViaSegue: NSURL!
    var movieViaSegue: NSDictionary!
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var overview: UITextView!
    @IBOutlet weak var imageDisplay: UIImageView!
    
    @IBOutlet weak var rating: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
        self.movieTitle.text = (movieViaSegue["title"] as! String)
        self.overview.text = (movieViaSegue["overview"] as! String)
        self.date.text = (movieViaSegue["release_date"] as! String)
        if let imageURL = NSURL(string: "http://image.tmdb.org/t/p/w500/" + (movieViaSegue["poster_path"] as? String)!) {
            imageDisplay.setImageWithURL(imageURL)
        }
        self.rating.text = ( String (movieViaSegue["vote_average"] as! Float32))
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
