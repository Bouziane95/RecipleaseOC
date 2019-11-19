//
//  FakeResponseData.swift
//  ReciPleaseOCTests
//
//  Created by Bouziane Bey on 12/11/2019.
//  Copyright © 2019 Bouziane Bey. All rights reserved.
//

import Foundation

class MockResponseData{
    
    static let responseOK = HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
    static let responseKO = HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!, statusCode: 500, httpVersion: nil, headerFields: nil)!
    
    //In order to access the protocol Error, we have to create a class and instantiate it
    class APIError : Error{}
    static let error = APIError()
    static let recipeIncorrectData = "Error".data(using: .utf8)!
    
    static var recipeCorrectData : Data{
        let bundle = Bundle(for: MockResponseData.self)
        let url = bundle.url(forResource: "recipe", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }
}
