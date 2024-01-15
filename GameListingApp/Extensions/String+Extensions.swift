//
//  String+Extensions.swift
//  GameListingApp
//
//  Created by Yiğithan Sönmez on 12.01.2024.
//

import Foundation

extension String {
    func convertIgdbPathToURLString(replaceOccurrencesOf: String = "", replaceWith: String = "") -> String{
        var inputString = self
        inputString.insert(contentsOf: "https:", at: inputString.startIndex)
        inputString = inputString.replacingOccurrences(of: replaceOccurrencesOf, with: replaceWith)
        return inputString
    }
}
