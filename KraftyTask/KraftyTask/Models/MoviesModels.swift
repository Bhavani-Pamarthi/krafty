//
//  MoviesModels.swift
//  KraftyTask
//
//  Created by BHAVANI on 31/01/21.
//  Copyright © 2021 BHAVANI. All rights reserved.
//

import Foundation
// MARK : - Now Playing Movies Model

struct NowPlayingMovies : Codable {
    let dates : Date?
    let page : Int?
    let results : [MoviesResults]?
    let total_pages : Int?
    let total_results : Int?
    
}

struct MoviesResults : Codable {
    
    let adult : Bool?
    let backdrop_path : String?
    let genre_ids : [Int]?
    let id : Int?
    let original_language : String?
    let original_title : String?
    let overview : String?
    let popularity : Double?
    let media_type : String?
    let poster_path : String?
    let release_date : String?
    let title : String?
    let video : Bool?
    let vote_average : Double?
    let vote_count : Int?
    
}

// MARK : - Trending Movies Model

struct TrendingMovies : Codable {
    
   
    let page : Int?
    let results : [MoviesResults]?
    let total_pages : Int?
    let total_results : Int?
    
}

struct Date : Codable {
    
    let maximum : String?
    let minimum : String?
    
}

// MARK : - Get Movie Details Model

struct GetMovieDetails : Codable {
    
    let adult : Bool?
    let backdrop_path : String?
    let genre_ids : [Details]?
    let id : Int?
    let original_language : String?
    let original_title : String?
    let overview : String?
    let popularity : Double?
    let poster_path : String?
    let release_date : String?
    let title : String?
    let video : Bool?
    let vote_average : Double?
    let vote_count : Int?
}

struct Details : Codable {
    
    
    let id : Int?
    let name : String?
}
// MARK : - Get Person Details Model
struct GetPersonDetails : Codable {
    
    let cast : [MoviesResults]?
    let id : Int?
    
    
}

//struct PersonDetails : Codable {
//    
//    let adult : Bool?
//    let backdrop_path : String?
//    let genre_ids : [Int]?
//    let id : Int?
//    let original_language : String?
//    let original_title : String?
//    let overview : String?
//    let popularity : Double?
//    let poster_path : String?
//    let release_date : String?
//    let title : String?
//    let video : Bool?
//    let vote_average : Double?
//    let vote_count : Int?
//    let credit_id : String?
//    
//}
