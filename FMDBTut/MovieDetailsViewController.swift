//
//  MovieDetailsViewController.swift
//  FMDBTut
//
//  Created by Gabriel Theodoropoulos on 04/10/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    // MARK: IBOutlet Properties
    
    @IBOutlet weak var imgMovieCover: UIImageView!
    
    @IBOutlet weak var btnMovieTitle: UIButton!
    
    @IBOutlet weak var lblCategory: UILabel!
    
    @IBOutlet weak var lblMovieYear: UILabel!
    
    @IBOutlet weak var swWatched: UISwitch!
    
    @IBOutlet weak var stLikes: UIStepper!
    
    @IBOutlet weak var lblLikeDescription: UILabel!
    
    
    // MARK: Custom Properties
    
    var movieID: Int!
    
    var movieInfo: MovieInfo!

    
    // MARK: Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let id = movieID {
            DBManager.shared.loadMovie(withID: id, completionHandler: { (movie) in
                DispatchQueue.main.async {
                    if movie != nil {
                        self.movieInfo = movie
                        self.setValuesToViews()
                    }
                }
            })
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    // MARK: Custom Methods
    
    
    func setValuesToViews() {
        (URLSession(configuration: URLSessionConfiguration.default)).dataTask(with: URL(string: movieInfo.coverURL)!, completionHandler: { (downloadedData, response, error) in
            DispatchQueue.main.async {
                if let data = downloadedData {
                    self.imgMovieCover.image = UIImage(data: data)
                }
            }
        }).resume()
        
        
        btnMovieTitle.setTitle(movieInfo.title, for: UIControlState.normal)
        
        lblCategory.text = movieInfo.category
        
        lblMovieYear.text = "\(movieInfo.year!)"
        
        swWatched.isOn = movieInfo.watched
        
        stLikes.value = Double(movieInfo.likes)
        lblLikeDescription.text = messageForLikes()
    }
    
    
    func messageForLikes() -> String {
        switch movieInfo.likes {
        case 0:
            return "I didn't like it at all."
            
        case 1:
            return "Interesting, but not exciting."
            
        case 2:
            return "Nice movie!"
            
        default:
            return "I loved it!"
        }
    }
    
    
    
    
    // MARK: IBAction Methods
    
    @IBAction func updateWatchedState(_ sender: AnyObject) {
        movieInfo.watched = swWatched.isOn
    }
    
    
    @IBAction func changeNumberOfLikes(_ sender: AnyObject) {
        movieInfo.likes = Int(stLikes.value)
        lblLikeDescription.text = messageForLikes()
    }
    
    
    @IBAction func saveChanges(_ sender: AnyObject) {
        DBManager.shared.updateMovie(withID: movieInfo.movieID, watched: movieInfo.watched, likes: movieInfo.likes)
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func openMovieWebpage(_ sender: AnyObject) {
        UIApplication.shared.open(URL(string: movieInfo.movieURL)!, options: [:], completionHandler: nil)
    }
    
    
}
