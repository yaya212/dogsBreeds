//
//  BreedsListFormat.swift
//  myFirstAPICall
//
//  Created by Yahya Emad on 09/04/2022.
//

import Foundation

struct BreedsListFormat:Codable{
    let status: String
    //if you are expecting a JSON response with unexpected non static keyNames then you better provide their format and it is easy to think of it as a dictionary
    let message: [String: [String]]
}
