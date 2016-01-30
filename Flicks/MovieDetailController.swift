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
    
    @IBOutlet weak var webView: UIWebView!
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
        
        let movieID = String (movieViaSegue["id"] as! Int)

        var movieVideo: [NSDictionary]?
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        var youtubeKey = "EIELwayIIT4"
        let url = NSURL(string:"https://api.themoviedb.org/3/movie/" + movieID + "/videos?api_key=\(apiKey)")
        print(url)
        let request = NSURLRequest(URL: url!)
        
        // Configure session so that completion handler is executed on main UI thread
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            movieVideo = responseDictionary["results"] as! [NSDictionary]
                            print(movieVideo)
                            let oneMovie = movieVideo![0]
                            youtubeKey = oneMovie["key"] as! String
                            var youtubeUrl = "http://www.youtube.com/embed/"
                            youtubeUrl += youtubeKey
                            let frame = 0
                            let Code:NSString = "<iframe width=\(self.webView.frame.width) height=\(self.webView.frame.height) src=\(youtubeUrl) frameborder=\(frame) allowfullscreen></iframe>"
                            self.webView.loadHTMLString(Code as String, baseURL: nil)
                    }
                }
        });
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
