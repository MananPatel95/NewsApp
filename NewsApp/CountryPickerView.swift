//
//  CountryPickerView.swift
//  NewsApp
//
//  Created by Manan Patel on 2021-05-17.
//

import UIKit

class CountryPickerView: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

   //picker view
    lazy var categoryPickerView: UIPickerView = {
        let pv = UIPickerView()
        pv.backgroundColor = UIColor.systemBackground
        return pv
    }()
    
    weak var delegate: NewsViewController?
    
    var allCountries = [
        "ar":"Argentina",
        "au":"Australia",
        "br":"Brazil",
        "ca":"Canada",
        "cn":"China",
        "fr":"France",
        "de":"Germany",
        "gb":"Great Britain",
        "it":"Italy",
        "in":"India",
        "jp":"Japan",
        "kr":"Korea",
        "mx":"Mexico",
        "no":"Norway",
        "ru":"Russia",
        "se":"Sweden",
        "us":"United States"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(categoryPickerView)
        categoryPickerView.delegate = self
        categoryPickerView.dataSource = self
        categoryPickerView.translatesAutoresizingMaskIntoConstraints = false
        categoryPickerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        categoryPickerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        categoryPickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        categoryPickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
    }


    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return allCountries.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Array(allCountries.values)[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate?.setCountry(forCountry:  Array(allCountries.keys)[row])
        dismiss(animated: true, completion: nil)
    }
}

protocol CountryPickerViewChangeCountryDelegate: CountryPickerView {
    func setCountry(forCountry country: String)
}
