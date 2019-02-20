//
//  SearchItem.swift
//  CustomSearchField
//
//  Created by Emrick Sinitambirivoutin on 20/02/2019.
//  Copyright © 2019 Emrick Sinitambirivoutin. All rights reserved.
//

import Foundation

class SearchItem {
    var attributedCityName: NSMutableAttributedString?
    var attributedCountryName: NSMutableAttributedString?
    var allAttributedName : NSMutableAttributedString?
    
    var cityName: String
    var countryName: String

    public init(cityName: String, countryName: String) {
        self.cityName = cityName
        self.countryName = countryName
    }
    
    public func getFormatedText() -> NSMutableAttributedString{
        allAttributedName = NSMutableAttributedString()
        allAttributedName!.append(attributedCityName!)
        allAttributedName!.append(NSMutableAttributedString(string: ", "))
        allAttributedName!.append(attributedCountryName!)
        
        return allAttributedName!
    }
    
    public func getStringText() -> String{
        return "\(cityName), \(countryName)"
    }

}
