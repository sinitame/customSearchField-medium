//
//  CustomSearchTextField.swift
//  CustomSearchField
//
//  Created by Emrick Sinitambirivoutin on 19/02/2019.
//  Copyright © 2019 Emrick Sinitambirivoutin. All rights reserved.
//

import UIKit

class CustomSearchTextField: UITextField{
    
    var dataList : [SearchItem] = [SearchItem]()
    var resultsList : [SearchItem] = [SearchItem]()
    var tableView: UITableView?
    
    
    
    // Connecting the new element to the parent view
    open override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        tableView?.removeFromSuperview()
        
    }
    
    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        self.addTarget(self, action: #selector(CustomSearchTextField.textFieldDidChange), for: .editingChanged)
        self.addTarget(self, action: #selector(CustomSearchTextField.textFieldDidBeginEditing), for: .editingDidBegin)
        self.addTarget(self, action: #selector(CustomSearchTextField.textFieldDidEndEditing), for: .editingDidEnd)
        self.addTarget(self, action: #selector(CustomSearchTextField.textFieldDidEndEditingOnExit), for: .editingDidEndOnExit)
    }
    
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        buildSearchTableView()
        
    }
    
    
    //////////////////////////////////////////////////////////////////////////////
    // Text Field related methods
    //////////////////////////////////////////////////////////////////////////////
    
    @objc open func textFieldDidChange(){
        print("Text changed ...")
        filter()
        updateSearchTableView()
        tableView?.isHidden = false
    }
    
    @objc open func textFieldDidBeginEditing() {
        print("Begin Editing")
    }
    
    @objc open func textFieldDidEndEditing() {
        print("End editing")

    }
    
    @objc open func textFieldDidEndEditingOnExit() {
        print("End on Exit")
    }
    
    
    // MARK : Filtering methods
    
    fileprivate func filter() {
        
        resultsList = []
        
        for i in 0 ..< dataList.count {
            
            let item = dataList[i]

            let cityFilterRange = (item.cityName as NSString).range(of: text!, options: .caseInsensitive)
            let countryFilterRange = (item.countryName as NSString).range(of: text!, options: .caseInsensitive)
                
            if cityFilterRange.location != NSNotFound {
                item.attributedCityName = NSMutableAttributedString(string: item.cityName)
                item.attributedCountryName = NSMutableAttributedString(string: item.countryName)
                
                item.attributedCityName!.setAttributes([.font: UIFont.boldSystemFont(ofSize: 17)], range: cityFilterRange)
                if countryFilterRange.location != NSNotFound {
                    item.attributedCountryName!.setAttributes([.font: UIFont.boldSystemFont(ofSize: 17)], range: countryFilterRange)
                }
                
                resultsList.append(item)
            }
            
        }
        
        tableView?.reloadData()
    }
    

}

extension CustomSearchTextField: UITableViewDelegate, UITableViewDataSource {
    

    //////////////////////////////////////////////////////////////////////////////
    // Table View related methods
    //////////////////////////////////////////////////////////////////////////////
    
    
    // MARK: TableView creation and updating
    
    // Create SearchTableview
    func buildSearchTableView() {

        if let tableView = tableView {
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CustomSearchTextFieldCell")
            tableView.delegate = self
            tableView.dataSource = self
            self.window?.addSubview(tableView)

        } else {
            addData()
            print("tableView created")
            tableView = UITableView(frame: CGRect.zero)
        }
        
        updateSearchTableView()
    }
    
    // Updating SearchtableView
    func updateSearchTableView() {
        
        if let tableView = tableView {
            superview?.bringSubviewToFront(tableView)
            var tableHeight: CGFloat = 0
            tableHeight = tableView.contentSize.height
            
            // Set a bottom margin of 10p
            if tableHeight < tableView.contentSize.height {
                tableHeight -= 10
            }
            
            // Set tableView frame
            var tableViewFrame = CGRect(x: 0, y: 0, width: frame.size.width - 4, height: tableHeight)
            tableViewFrame.origin = self.convert(tableViewFrame.origin, to: nil)
            tableViewFrame.origin.x += 2
            tableViewFrame.origin.y += frame.size.height + 2
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                self?.tableView?.frame = tableViewFrame
            })
            
            //Setting tableView style
            tableView.layer.masksToBounds = true
            tableView.separatorInset = UIEdgeInsets.zero
            tableView.layer.cornerRadius = 5.0
            tableView.separatorColor = UIColor.lightGray
            tableView.backgroundColor = UIColor.white.withAlphaComponent(0.4)
            
            if self.isFirstResponder {
                superview?.bringSubviewToFront(self)
            }
            
            tableView.reloadData()
        }
    }
    
    
    
    // MARK: TableViewDataSource methods
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(resultsList.count)
        return resultsList.count
    }
    
    // MARK: TableViewDelegate methods
    
    //Adding rows in the tableview with the data from dataList

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomSearchTextFieldCell", for: indexPath) as UITableViewCell
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.attributedText = resultsList[indexPath.row].getFormatedText()
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected row")
        self.text = resultsList[indexPath.row].getStringText()
        tableView.isHidden = true
        self.endEditing(true)
    }
    

    // MARK: Early testing methods
    func addData(){
        let a = SearchItem(cityName: "Paris",countryName: "France")
        let b = SearchItem(cityName: "Porto",countryName: "France")
        let c = SearchItem(cityName: "Pavard",countryName: "France")
        let d = SearchItem(cityName: "Parole",countryName: "France")
        let e = SearchItem(cityName: "Paria",countryName: "France")
        
        dataList.append(a)
        dataList.append(b)
        dataList.append(c)
        dataList.append(d)
        dataList.append(e)
    }
    
}
