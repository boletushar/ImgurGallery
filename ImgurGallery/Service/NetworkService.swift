//
//  NetworkService.swift
//  ImgurGallery
//
//  Created by Tushar on 19/8/18.
//  Copyright © 2018 bole.tushar.imgurapp. All rights reserved.
//

import Foundation

class NetworkService {
    
    static let shared = NetworkService()
    
    func fetchResultsForQuery(_ query: String, callback:@escaping (_ results : Array<ImgurModel>?, _ error : Error?) -> ()) {
        
        // Create a URL to find top images of the week with user search query
        let url = URL(string: "\(Constants.APIData.baseAPI)/\(Constants.APIData.apiVersion)/gallery/search/top/week/1?q=\(query)".addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)!)
        
        // Create a request object to add header Authorization and its value
        var request = URLRequest(url: url!)
        let authorizationKey = "Client-ID ".appending(Constants.ImgurData.clientID)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(authorizationKey, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode {
                
                guard let dataResponse = data, error == nil else {
                    print(error?.localizedDescription ?? "Response error")
                    callback(nil, nil)
                    return
                }
                
                do {
                    
                    var results = [ImgurModel]()
                    let jsonResponse = try JSONSerialization.jsonObject(with: dataResponse, options: []) as! [String: Any]
                    
                    if let resultsArray = jsonResponse["data"] as? [[String: Any]] {
                        
                        for result in resultsArray {
                            
                            let model = ImgurModel(result)
                            results.append(model)
                        }
                    }
                    
                    callback(results, nil)
                    
                } catch let parsingError {
                    print("Error ", parsingError)
                }
                
            } else {
                callback(nil, error)
            }
            
        }.resume()
    }
}
