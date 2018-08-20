//
//  GalleryViewModel.swift
//  ImgurGallery
//
//  Created by Tushar on 19/8/18.
//  Copyright © 2018 bole.tushar.imgurapp. All rights reserved.
//

import Foundation
import SDWebImage

class GalleryViewModel {
    
    var searchResults : [ImgurModel]?
    var filteredSearchResults : [ImgurModel]?
    
    var queryString : String?
    
    func getResultsForQuery(_ query: String, callback:@escaping (_ results : Array<ImgurModel>?, _ error : Error?) -> ()) {
        
        // If user enters same query string again then just return the previous results array
        if let q = queryString, q.elementsEqual(query) && (searchResults?.count)! > 0 {
            callback(searchResults!, nil)
        }
        
        // If new query is fired then cancel all the downloads for previous downloads
        SDWebImageDownloader.shared().cancelAllDownloads()
        
        // Fetch new results for query
        self.queryString = query
        NetworkService.shared.fetchResultsForQuery(query) { (results, error) in
            self.searchResults = results?.sorted{ $0.datetime > $1.datetime }
            callback(results, error)
        }
    }
    
    func filterResultsWithEvenSum() {
        
        // Filter the results where the sum (“points”, “score” and “topic_id”) is even number
        if let results = self.searchResults, results.count > 0 {
            self.filteredSearchResults = self.searchResults?.filter {
                return $0.isSumEven == true
            }
        }
    }
}
