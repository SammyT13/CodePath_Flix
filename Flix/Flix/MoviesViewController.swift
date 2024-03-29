//
//  MoviesViewController.swift
//  Flix
//
//  Created by Sammy Torres II on 9/12/22.
//

import UIKit
import AlamofireImage
// after controll drag add UITableViewDataSource & UITableViewDelegate
// fix issues with adding two func below
class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    // this comes after add tableView
    @IBOutlet weak var tableView: UITableView!
    
    var movies = [[String:Any]]() // creates an array - dictionary

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self // must add
        tableView.delegate = self  // must add
   
        // Added API copy
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
             // This will run when the network request returns
             if let error = error {
                    print(error.localizedDescription)
             } else if let data = data {
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    
                 // coded added for class//
                 self.movies = dataDictionary["results"] as! [[String:Any]] //downloads the movies from website
                 
                 self.tableView.reloadData() // this calls the functions
    

                    // TODO: Get the array of movies
                    // TODO: Store the movies in a property to use elsewhere
                    // TODO: Reload your table view data

             }
        }
        task.resume()
    } // End of copied API
    
    // First func is asking for a number of rows & prints out each row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return movies.count
    }
    // Second func is asking for a cell with the information for each row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell// this recycles a cell if it's offscreen and if it isn't it will create one
        // gets the movies (dealing with row & section)
        let movie = movies[indexPath.row];
        let title = movie["title"] as! String
        
        let synopsis = movie["overview"] as! String
        
        cell.titleLabel.text = title
        cell.synopsisLabel.text = synopsis
        
        // this is to get the images from the URL
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)
        
        cell.posterView.af_setImage(withURL: posterUrl!) // this will download the images

        return cell
    }
    
    // Navigation Function //
    
    // This func helps prepare to send data
    override func prepare (for segue: UIStoryboardSegue, sender: Any?) {
        
        // Finds the selected movie
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        let movie = movies[indexPath.row] // lets access to array
        
        // Passes the selected movie to the details view controller
        
        let detailsViewController = segue.destination as! MovieDetailsViewController // we cast it to 'MovieDetailsViewController'
        detailsViewController.movie = movie // this second 'movie' is referring to the above 'let movie'
        
        // to remove the 'still selected' on the app when we go back you add code below
        tableView.deselectRow(at: indexPath, animated: true)
        
    }


}

