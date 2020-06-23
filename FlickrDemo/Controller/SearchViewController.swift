//
//  SearchViewController.swift
//  FlickrDemo
//
//  Created by Pinlun on 2020/6/22.
//  Copyright © 2020 pinlun. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchKeywordInput: UITextField!
    @IBOutlet weak var resultPerPageInput: UITextField!
    
    @IBOutlet weak var searchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(tapGestureRecognizer:)))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "搜尋照片"
        
//        searchButton.isEnabled = ((searchKeywordInput.text?.count ?? 0) > 0)
//            && ((resultConfigPerPageInput.text?.count ?? 0) > 0)
//        if searchButton.isEnabled {
//            searchButton.alpha = 1
//        } else {
//            searchButton.alpha = 0.5
//        }
    }
    
    @IBAction func searchClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "showSearchResult", sender: self)
    }
    
    func setUpView() {
        searchButton.backgroundColor = #colorLiteral(red: 0.007509642746, green: 0.4820441008, blue: 0.9983070493, alpha: 1)
        searchButton.tintColor = .white
        searchButton.layer.cornerRadius = 5
    }
    
    @objc func dismissKeyboard(tapGestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSearchResult" {
            let resultVC = segue.destination as! ResultViewController
            let keyword = self.searchKeywordInput.text
            let perPage = self.resultPerPageInput.text
            resultVC.keyword = keyword ?? ""
            resultVC.perPage = perPage ?? ""
        }
   }

}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case searchKeywordInput:
            resultPerPageInput.becomeFirstResponder()
        case resultPerPageInput:
            textField.resignFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textField == searchKeywordInput else { return true }
        let keywordLength = (textField.text?.count ?? 0) - range.length + string.count
        
//        guard textField == resultConfigPerPageInput else { return true }
//        let perPageLength = (textField.text?.count ?? 0) - range.length + string.count
        
        searchButton.isEnabled = keywordLength > 0
        
        return true
    }
}
