//
//  String+Extensions.swift
//  GameListingApp
//
//  Created by Yiğithan Sönmez on 12.01.2024.
//

import Foundation
import Alamofire

extension String {
    func convertIgdbPathToURLString(replaceOccurrencesOf: String = "", replaceWith: String = "") -> String{
        var inputString = self
        inputString.insert(contentsOf: "https:", at: inputString.startIndex)
        inputString = inputString.replacingOccurrences(of: replaceOccurrencesOf, with: replaceWith)
        return inputString
    }
}

extension String: ParameterEncoding {
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
}
