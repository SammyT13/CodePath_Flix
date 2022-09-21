//
//  MovieGridViewController.swift
//  Flix
//
//  Created by Sammy Torres II on 9/19/22.
//

import UIKit
import AlamofireImage

class MovieGridViewController: UIViewController, UICollectionViewDataSource,
                               UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    // movie property
    var movies = [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // creating a layout object
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        // working with layout
        
        layout.minimumLineSpacing = 4 // controls the space in between the rows
        layout.minimumInteritemSpacing = 4 // controls the space between columns
        // continue working with layout: this configures based on user's phone
        let width = (view.frame.size.width - layout.minimumLineSpacing * 2)  / 3 //captures the width value of a phone
        layout.itemSize = CGSize(width: width, height: width * 3 / 2)
        
        // Added API copy
        let url = URL(string: "https://api.themoviedb.org/3/movie/297762/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")! // changed to 'Wonder Woman' ID 297762
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
                
                // this gets the data from the internet and reloads
                self.collectionView.reloadData()
                
                // TODO: Get the array of movies
                // TODO: Store the movies in a property to use elsewhere
                // TODO: Reload your table view data
                
            }
        }
        task.resume()
    } // End of copied API
    
    // This is to count however many movies (items) there are
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieGridCell", for: indexPath) as! MovieGridCell
        // this is to get the movies (items) // doesn't have row & section like Table View
        let movie = movies[indexPath.item]
        
        // code is from 'MoviesViewController' which is similar for the 'Collection View'
        
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)
        
        cell.posterView.af_setImage(withURL: posterUrl!)
        
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Finds the selected movie
        let cell = sender as! UICollectionViewCell
        let indexPath = collectionView.indexPath(for: cell)!
        // TO DO: might need to change 'row' to 'item'
        let movie = movies[indexPath.row]
        
        // Passes the selected movie to the 'PosterMovieDetailsController'
        
        let posterDetailsViewController = segue.destination as! PosterMovieDetailsViewController
        posterDetailsViewController.movie = movie
        
    }
    
    
}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

