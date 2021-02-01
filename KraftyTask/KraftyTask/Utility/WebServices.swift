//
//  WebServices.swift
//  KraftyTask
//
//  Created by BHAVANI on 31/01/21.
//  Copyright © 2021 BHAVANI. All rights reserved.
//

import Foundation
import UIKit

struct APIService {
    
    let baseURL = URL(string: "https://api.themoviedb.org/3/")!
    static let shared = APIService()
    let decoder = JSONDecoder()
    
    enum APIError: Error {
        
        case noResponse
        case jsonDecodingError(error: Error)
        case networkError(error: Error)
        case internetError(error: Error)
        case invalidEndpoint
        case unAuthorized

       }
    enum Endpoint {
        case nowPlaying
        case trending
        case movieDetails
        case personDetails

        func path() -> String {
            switch self {
            case .nowPlaying:
                return "movie/now_playing"
            case .trending:
                return "trending/movie/week"
            case .movieDetails:
                return "movie"
            case .personDetails:
                //return "people/get-person-movie-credits"
                return "person/53/movie_credits"
            }
        }
    }

    
    /// ---------------------------------
    /// GET Request
    /// ---------------------------------

    func GET<T: Codable>(endpoint: Endpoint, headers:[String:String], queryItems:[String:String],completionHandler: @escaping (Result<T, APIError>) -> Void) {
        
        if  CheckInternet.Connection() {
            
            let requestURL = baseURL.appendingPathComponent(endpoint.path())
            
            guard var urlComponents = URLComponents(url: requestURL, resolvingAgainstBaseURL: true) else {
                completionHandler(.failure(.invalidEndpoint))
                return
            }
            urlComponents.queryItems = queryItems.map { URLQueryItem(name: $0, value: $1) }
            
            guard let url = urlComponents.url else {
                completionHandler(.failure(.invalidEndpoint))
                return
            }
            
            let config = URLSessionConfiguration.default
            config.httpAdditionalHeaders = headers
            
            let session = URLSession(configuration: config)
            
            let task = session.dataTask(with: url) { data, res, error in
                
                
//                guard let statusCode = (res as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
//                    completionHandler(.failure(.networkError(error: error!)))
//                    return
//                }
                
                guard let data = data else {
                    DispatchQueue.main.async {
                        completionHandler(.failure(.noResponse))
                    }
                    return
                }
                guard error == nil else {
                    DispatchQueue.main.async {
                        completionHandler(.failure(.networkError(error: error!)))
                    }
                    return
                }

                do {
                    let object = try self.decoder.decode(T.self, from: data)
                    DispatchQueue.main.async {
                        completionHandler(.success(object))
                        print("\(object)")
                    }
                } catch let error {
                    DispatchQueue.main.async {
                        #if DEBUG
                        print("JSON Decoding Error: \(error)")
                        #endif
                        completionHandler(.failure(.jsonDecodingError(error: error)))
                    }
                }
                
            }
            task.resume()
            
       }
        else {
            let error = NSError(domain: "No Internet", code: 404, userInfo: [:])
            completionHandler(.failure(.internetError(error: error)))
        }
        
    }
    
}
