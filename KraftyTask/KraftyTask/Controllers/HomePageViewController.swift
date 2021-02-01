//
//  HomePageViewController.swift
//  KraftyTask
//
//  Created by BHAVANI on 31/01/21.
//  Copyright © 2021 BHAVANI. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController {

     // MARK : - Properties
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var movies = [MoviesResults]()
    var trendingMovies = [MoviesResults]()
    
    // MARK : - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NowPlayingMovies()
        TrendingMovies()
        // Do any additional setup after loading the view.
        let NowPlayingLayout = NowPlayingMoviesFlowLayout (
            cellsPerRow: 2,
            minimumInteritemSpacing: 15,
            minimumLineSpacing: 15,
            sectionInset: UIEdgeInsets(top: 15, left: 10, bottom: 15, right: 10)
            
        )
        collectionView.collectionViewLayout = NowPlayingLayout
        NowPlayingLayout.scrollDirection = .horizontal
    }
     func NowPlayingMovies() {
        let queryItems:[String:String] = ["api_key": "5688b453baca3fa2250dea6884f11853", "language": "en-US"]
        APIService.shared.GET(endpoint: APIService.Endpoint.nowPlaying,headers: [:],queryItems: queryItems) { (result:Result<NowPlayingMovies, APIService.APIError>) in
            switch result{
            case let .success(response):
                guard let movies = response.results else {return}
                self.movies = movies
                print("\(self.movies.count)")
                self.collectionView.reloadData()
                break
            case let .failure(error):
                print(error.localizedDescription)
                
            }
        }
        
    }
     func TrendingMovies() {
      let queryItems:[String:String] = ["api_key": "5688b453baca3fa2250dea6884f11853"]
        
        
        APIService.shared.GET(endpoint: APIService.Endpoint.trending,headers: [:],queryItems: queryItems) { (result:Result<TrendingMovies,APIService.APIError>) in
            print("hello hai")
           
            switch result {
            
            case let .success(response):
                
                guard let movies = response.results else { return }
                self.trendingMovies = movies
                print("\(self.trendingMovies.count)")
                self.tableView.reloadData()
                break
                
            case let .failure(error):
                
                print(error.localizedDescription)
                break
                
            }
        }
        
    }

    
}

// Mark : - UITableViewDelegate Methods

extension HomePageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return self.trendingMovies.count
       // return 10
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "TrendingMoviesTVCell", for: indexPath) as! TrendingMoviesTVCell
        cell.configure(trendingMovies[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(identifier: "MovieDetailsViewController") as! MovieDetailsViewController
       vc.movie = self.trendingMovies[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
class TrendingMoviesTVCell: UITableViewCell{
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var img2: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        rating.layer.cornerRadius = rating.frame.height/2
        rating.clipsToBounds = true
    }
    
   func configure(_ item: Any?) {
    
        guard let movie = item as? MoviesResults else { return }
        self.movieName.text = movie.title
        //self.type.text = movie.
        self.rating.text = String(format: "★ %.1f", movie.vote_average ?? 0)
        do{
            img.image =  try UIImage(data: Data(contentsOf: URL(string:"\(ImageBaseURL)\(movie.poster_path ?? " ")")!))
        }catch{
            print("image not found")
        }
    
    }
}

// Mark : - UICollectionViewDelegate Methods

extension HomePageViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "NowPlayingMoviesCVCell", for: indexPath) as! NowPlayingMoviesCVCell
        cell.configure(movies[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(identifier: "MovieDetailsViewController") as! MovieDetailsViewController
        vc.movie = self.movies[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
class NowPlayingMoviesCVCell: UICollectionViewCell{
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var movieName: UILabel!
    
    @IBOutlet weak var rating: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        rating.layer.cornerRadius = rating.frame.height/2
        rating.clipsToBounds = true
    }
    func configure(_ item: Any?) {
    
        guard let movie = item as? MoviesResults else { return }
        self.movieName.text = movie.title
        self.rating.text = String(format: "★ %.1f", movie.vote_average ?? 0)
        do{
            img.image =  try UIImage(data: Data(contentsOf: URL(string:"\(ImageBaseURL)\(movie.poster_path ?? " ")")!))
        }catch{
            print("image not found")
        }
    
    }
    
}
