//
//  MoviesViewController.swift
//  FMDBTut
//
//  Created by Gabriel Theodoropoulos on 04/10/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

import UIKit


struct MovieInfo {
    var movieID: Int!
    var title: String!
    var category: String!
    var year: Int!
    var movieURL: String!
    var coverURL: String!
    var watched: Bool!
    var likes: Int!
}


class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: IBOutlet Properties
    @IBOutlet weak var tblMovies: UITableView!
    
    
    // MARK: Custom Properties
    
    var movies: [MovieInfo]!
    
    var selectedMovieIndex: Int!
    
    
    
    // MARK: Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tblMovies.delegate = self
        tblMovies.dataSource = self
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        movies = DBManager.shared.loadMovies()
        tblMovies.reloadData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let identifier = segue.identifier {
            if identifier == "idSegueMovieDetails" {
                let movieDetailsViewController = segue.destination as! MovieDetailsViewController
                movieDetailsViewController.movieID = movies[selectedMovieIndex].movieID
            }
        }
        
    }
    
    
    
    // MARK: UITableView Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (movies != nil) ? movies.count : 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let currentMovie = movies[indexPath.row]
        
        cell.textLabel?.text = currentMovie.title
        cell.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        
        (URLSession(configuration: URLSessionConfiguration.default)).dataTask(with: URL(string: currentMovie.coverURL)!, completionHandler: { (imageData, response, error) in
            if let data = imageData {
                DispatchQueue.main.async {
                    cell.imageView?.image = UIImage(data: data)
                    cell.layoutSubviews()
                }
            }
        }).resume()
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMovieIndex = indexPath.row
        performSegue(withIdentifier: "idSegueMovieDetails", sender: nil)
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if DBManager.shared.deleteMovie(withID: movies[indexPath.row].movieID) {
                movies.remove(at: indexPath.row)
                tblMovies.reloadData()
            }
        }
    }
    
}
