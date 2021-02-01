//
//  MovieDetailsViewController.swift
//  KraftyTask
//
//  Created by BHAVANI on 31/01/21.
//  Copyright © 2021 BHAVANI. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    // MARK : - Properties
    
    @IBOutlet weak var persondetailsCV: UICollectionView!
    @IBOutlet weak var backgroundImg: UIImageView!
    @IBOutlet weak var playBtnView: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var movieType: UILabel!
    @IBOutlet weak var info: UITextView!
    
    var movies1 = GetMovieDetails?.self
    var movies2 = [MoviesResults]()
    var movietype = [Details]()
    var movie: Any?
    
    // MARK : - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //MovieDetailsMovies()
        GetPersonDetailsMovies()
       
        
        rating.layer.cornerRadius = rating.frame.height/2
        rating.clipsToBounds = true
        playBtnView.layer.cornerRadius = playBtnView.frame.height/2
        playBtnView.clipsToBounds = true
       
        let personDetailsLayout = GetPersonDetailsFlowLayout (
            cellsPerRow: 3,
            minimumInteritemSpacing: 15,
            minimumLineSpacing: 15,
            sectionInset: UIEdgeInsets(top: 15, left: 10, bottom: 15, right: 10)
        )
        persondetailsCV.collectionViewLayout = personDetailsLayout
        personDetailsLayout.scrollDirection = .horizontal
        guard let movie = self.movie as? MoviesResults else { return }
        name.text = movie.original_title
        self.rating.text = String(format: "★ %.1f", movie.vote_average ?? 0)
        self.info.text = movie.overview
        do{
            backgroundImg.image =  try UIImage(data: Data(contentsOf: URL(string:"\(ImageBaseURL)\(movie.backdrop_path ?? " ")")!))
        }catch{
            print("image not found")
        }
        
    }
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
  
    
    func GetPersonDetailsMovies() {
      let queryItems:[String:String] = ["api_key": "5688b453baca3fa2250dea6884f11853"]
     //   let headers:[String:String] = ["person_id":"53"]
        
        APIService.shared.GET(endpoint: APIService.Endpoint.personDetails,headers: [:],queryItems: queryItems) { (result:Result<GetPersonDetails,APIService.APIError>) in
            print("hello hai")
           
            switch result {
            
            case let .success(response):
                
                guard let movies = response.cast else { return }
                self.movies2 = movies
                print("\(self.movies2.count)")
                self.persondetailsCV.reloadData()
                break
                
            case let .failure(error):
                
                print(error.localizedDescription)
                break
                
            }
        }
        
    }

}

// Mark : - UICollectionViewDelegate Methods

extension MovieDetailsViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return self.movies2.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.persondetailsCV.dequeueReusableCell(withReuseIdentifier: "GetPersonDetailsCVCell", for: indexPath) as! GetPersonDetailsCVCell
        cell.configure(movies2[indexPath.row])
        return cell
    }
    
    
}
class GetPersonDetailsCVCell: UICollectionViewCell{
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var name: UILabel!
    func configure(_ item: Any?) {
    
        guard let movie = item as? MoviesResults else { return }
        self.name.text = movie.title
        do{
            img.image =  try UIImage(data: Data(contentsOf: URL(string:"\(ImageBaseURL)\(movie.poster_path ?? " ")")!))
        }catch{
            print("image not found")
        }
    
    }

}
