//
//  MoviesViewController.swift
//  Flicks
//
//  Created by Difan Chen on 1/14/16.
//  Copyright © 2016 Difan Chen. All rights reserved.
//

import AFNetworking
import UIKit
import MBProgressHUD

class MoviesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var movies: [NSDictionary]?
    var filteredMovies: [NSDictionary]?
    var endpoint: String!
    
    // MARK: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        uiCustomize()
        let refreshControl = UIRefreshControl()
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self

        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        loadData()
    }
    
    // MARK: - Helpers
    func uiCustomize() {
        let nav = self.navigationController?.navigationBar
        let search = self.searchBar!
        search.barStyle = UIBarStyle.Black
        nav?.barStyle = UIBarStyle.Black
    }
    
    func loadData() {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)

        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string:"https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
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
                            NSLog("response: \(responseDictionary)")
                            self.movies = responseDictionary["results"] as? [NSDictionary]
                            self.filteredMovies = self.movies
                            self.tableView.reloadData()
                            MBProgressHUD.hideHUDForView(self.view, animated: true)
                    }
                }
        });
        task.resume()
    }
}

extension MoviesViewController: UITableViewDelegate {
    
}

extension MoviesViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let filteredMovies = filteredMovies {
            return filteredMovies.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        let movie = filteredMovies![indexPath.row]
        let title = movie["title"] as! String
        if let posterPath = movie["backdrop_path"] as? String {
            let baseUrl = "http://image.tmdb.org/t/p/w500/"
            let imageURL = NSURL(string: baseUrl + posterPath)
            cell.posterView.setImageWithURL(imageURL!)
        }
        cell.titlelabel.text = title
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath
        indexPath: NSIndexPath) {
            self.performSegueWithIdentifier("showView", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender:
        AnyObject?) {
            if (segue.identifier == "showView") {
                let upcoming: MovieDetailController = segue.destinationViewController
                    as! MovieDetailController
                let indexPath = self.tableView.indexPathForSelectedRow!
                let movie = filteredMovies![indexPath.row]
                upcoming.movieViaSegue = movie
                self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
            }
    }
}

extension MoviesViewController: UISearchBarDelegate {
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        loadData()
        refreshControl.endRefreshing()
    }
    
    // This method updates filteredData based on the text in the Search Box
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        // When there is no text, filteredData is the same as the original data
        if searchText.isEmpty {
            filteredMovies = movies
        } else {
            filteredMovies = movies!.filter({(dataItem: NSDictionary) -> Bool in
                let title = dataItem["title"] as! String
                if title.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil {
                    return true
                } else {
                    return false
                }
            })
        }
        tableView.reloadData()
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        view.endEditing(true)
    }
}
