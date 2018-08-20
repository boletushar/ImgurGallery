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
        
        if let q = queryString, q.elementsEqual(query) && (searchResults?.count)! > 0 {
            callback(searchResults!, nil)
        }
        
        // If new query is fired then cancel all the downloads for previous downloads
        SDWebImageDownloader.shared().cancelAllDownloads()
        
        // Fetch new
        self.queryString = query
        NetworkService.shared.fetchResultsForQuery(query) { (results, error) in
            self.searchResults = results
            callback(results, error)
        }
    }
    
    func filterResultsWithEvenSum() {
        
        if let results = self.searchResults, results.count > 0 {
            self.filteredSearchResults = self.searchResults?.filter {
                return $0.isSumEven == true
            }
        }
    }
}
