//
//  ImagurViewController.swift
//  ImgurGallery
//
//  Created by Tushar on 19/8/18.
//  Copyright © 2018 bole.tushar.imgurapp. All rights reserved.
//

import UIKit

class ImagurViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var evenSumSwitch: UISwitch!
    
    @IBOutlet weak var tableView: UITableView!
    let viewModel : GalleryViewModel = GalleryViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        // By default the switch is OFF
        self.evenSumSwitch.isOn = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func switchButtonClicked(_ sender: UISwitch) {
        
        // If filter switch is ON
        if self.evenSumSwitch.isOn {
            
            // Filter the results to display
            if let results = viewModel.searchResults, results.count > 0 {
                viewModel.filterResultsWithEvenSum()
            } else {
                // If no results are there to filter show error message
                AlertError.showMessage(title: "Error", msg: "No results availble to filter. Please search with query and then filter.")
                self.evenSumSwitch.isOn = false
                return
            }
        }
        // Reload the table view
        self.tableView.reloadData()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension ImagurViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        textField.addSubview(activityIndicator)
        activityIndicator.frame = textField.bounds
        activityIndicator.startAnimating()
        
        viewModel.getResultsForQuery(textField.text!) {
            results, error in
            
            DispatchQueue.main.async {
                activityIndicator.removeFromSuperview()
            }
            
            if results == nil {
                print("Unknown error")
                return
            }
            
            if let error = error {
                print("Error searching : \(error)")
                return
            }
            
            DispatchQueue.main.async {
                
                if let rs = results, rs.count > 0 {
                    
                    // Refresh tableview
                    self.tableView.reloadData()
                } else {
                    
                    // Show error for emty results
                    AlertError.showMessage(title: "Error", msg: "No results found for given query. Please try with different search query.")
                }
            }
        }
        
        textField.text = nil
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - UITableViewDataSource
extension ImagurViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! ImgurTableViewCell
        
        // Show results from filtered array if switch is ON
        if self.evenSumSwitch.isOn {
            let data = viewModel.filteredSearchResults![indexPath.row]
            cell.set(data: data)
        } else {
            let data = viewModel.searchResults![indexPath.row]
            cell.set(data: data)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Returning the row count based on switch status
        if self.evenSumSwitch.isOn {
            if let results = viewModel.filteredSearchResults, results.count > 0 {
                return results.count
            }
        } else {
            if let results = viewModel.searchResults, results.count > 0 {
                return results.count
            }
        }
        
        return 0
    }
}
