//
//  MovieDetailsViewController.swift
//  Flix
//
//  Created by Sammy Torres II on 9/15/22.
//

import UIKit
import AlamofireImage // this is the library that helps us download the image

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet weak var backdropView: UIImageView!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    
    // this 'movie' is a dictionary and now we have a property
    var movie: [String:Any]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        titleLabel.text = movie["title"] as? String
        titleLabel.sizeToFit() // this grows the labels
        synopsisLabel.text = movie["overview"] as? String
        synopsisLabel.sizeToFit() // this grows the label
        
        // this is to get the images from the URL (copy & paste from MoviesViewController)
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        // this is for the poster
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)
        // remove 'cell'
        posterView.af_setImage(withURL: posterUrl!)
        
        // this is for the background
        let backdropPath = movie["backdrop_path"] as! String
        // we changed the width below from 'baseUrl' to get a better resolution
        let backdropUrl = URL(string: "https://image.tmdb.org/t/p/w780" + backdropPath)
        
        backdropView.af_setImage(withURL: backdropUrl!)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
