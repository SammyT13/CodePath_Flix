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
        // Do any additional setup after loading the view.
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
             // This will run when the network request returns
             if let error = error {
                    print(error.localizedDescription)
             } else if let data = data {
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    
                 self.movies = dataDictionary["results"] as! [[String:Any]] //downloads the movies
                 
                 self.tableView.reloadData() // this calls the functions
                    print(dataDictionary)

                    // TODO: Get the array of movies
                    // TODO: Store the movies in a property to use elsewhere
                    // TODO: Reload your table view data

             }
        }
        task.resume()
    }
    // first func is asking for a number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return movies.count
    }
    // second func is asking give me a cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell// this recycles a cell if it's offscreen and if it isn't it will create one
        
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


}

