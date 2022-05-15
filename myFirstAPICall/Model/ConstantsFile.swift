//
//  ConstantsFile.swift
//  myFirstAPICall
//
//  Created by Yahya Emad on 03/04/2022.
//

import Foundation

struct ConstantsFile{
    enum Endpoint{
        case randomImageFromAllDogsCollection
        case allBreedsFromAllDogsCollection
        //Associated property with some variable passed to this case and can be used later
        case selectedBreedImageFromAllDogsCollectionURLPath(String)
        //current object with the given case will have its rawValue retrieved.
        //computed variables are accessed by typing "enumName.caseName.computedVariable
        var url: URL{
            return URL(string: self.stringValue)!
        }
        
        var stringValue: String{
            switch self {
            case .randomImageFromAllDogsCollection:
                return "https://dog.ceo/api/breeds/image/random"
            case .allBreedsFromAllDogsCollection:
                return "https://dog.ceo/api/breeds/list/all"
            case .selectedBreedImageFromAllDogsCollectionURLPath(let breed):
                return "https://dog.ceo/api/breed/\(breed)/images/random"
            }
        }
    }
}
