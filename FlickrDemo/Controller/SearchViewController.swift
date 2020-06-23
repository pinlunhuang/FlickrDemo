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
        searchKeywordInput.delegate = self
        resultPerPageInput.delegate = self
        setUpView()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(tapGestureRecognizer:)))
        view.addGestureRecognizer(tap)
        checkTextFieldsIsEmpty()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "搜尋照片"
    }
    
    @IBAction func searchClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "showSearchResult", sender: self)
    }
    
    //MARK: - Custom func

    func setUpView() {
        searchButton.backgroundColor = #colorLiteral(red: 0.007509642746, green: 0.4820441008, blue: 0.9983070493, alpha: 1)
        searchButton.tintColor = .white
        searchButton.layer.cornerRadius = 5
    }
    
    func checkTextFieldsIsEmpty() {
        self.searchButton.isEnabled = false
        searchKeywordInput.addTarget(self, action: #selector(textFieldsIsNotEmpty),
                                 for: .editingChanged)
        resultPerPageInput.addTarget(self, action: #selector(textFieldsIsNotEmpty),
                                 for: .editingChanged)
    }
    
    //MARK: - @objc custom func
    
    @objc func dismissKeyboard(tapGestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func textFieldsIsNotEmpty(sender: UITextField) {
        sender.text = sender.text?.trimmingCharacters(in: .whitespaces)
        guard
            let keyword = searchKeywordInput.text, !keyword.isEmpty,
            let perPage = resultPerPageInput.text, !perPage.isEmpty
            else {
                self.searchButton.isEnabled = false
                return
            }
        self.searchButton.isEnabled = true
    }
    
    //MARK: - Segue Preparation

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
}
