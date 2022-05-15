//
//  DogsAPIHandler.swift
//  myFirstAPICall
//
//  Created by Yahya Emad on 03/04/2022.
//

import Foundation
import UIKit

struct DogsAPIHandler{
    
    //here we put "@escaping" because we are sure that the code passed into the closure will run after this "retrieveImage" function is finished.
    static func retrieveImage(with url:String, completionHandler: @escaping (UIImage?, Error?) -> Void){
        
        guard let safeURL = URL(string: url) else{
            return
        }
        let task = URLSession.shared.dataTask(with: safeURL) { data, response, error in
            guard let safeData = data else{
                //here since we faced an error in the data we need to set the image to nil and pass the error received to the comnpletionHandler.
                completionHandler(nil, error)
                return
            }
            
            let downloadedRandomDogImage = UIImage(data: safeData)
            
            //When the image is retrieved whether it is Error or not we call the completionHandler here. Here since we passed the data test then we pass the image and set the error parameter to nil.
            completionHandler(downloadedRandomDogImage, nil)
        }
        task.resume()
    }
    
    
    static func handleJSON(for url:URL,completionHandler: @escaping (DogAPIDataFormat?, Error?) -> Void){
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let safeData = data else{
                print("No data or error occured.")
                return
            }
            
//            print(safeData)
            
            //MARK: - Method1: Represent JSON objects using "JSONSerialization" which converts it into a dictionary and deal with it the same way you deal with dictionaries. It works fine with simple JSON data but it can get messy with more complex JSON data.
            
            //throws an exception because the data could be an invalid JSON data so we need to put it in a do catch block
            //since the retrieved value from the method can be any Foundation Object then we need to force downCast it to a dictionary
//            do{
//                //Here we are force downcasting to a dictionary of keys having "String" dataTypes and values having "Any" dataType
//
//                let json = try JSONSerialization.jsonObject(with: safeData, options: []) as! [String: Any]
//
//                //here we are certain that the data has passed the JSONSerialization test and has been converted successfully now we parse the data. Since we get returned a key named "message" having the image URL, then we retrieve it as follows.
//
//                let retrievedURL = json["message"] as! String
////                print(retrievedURL)
//                self.retrieveImage(with:retrievedURL)
//
//            }
//            catch{
//                print(error)
//            }
            
            //MARK: - Method2: Using the "Codable" protocol which converts the JSON object to a struct and then you extract data from the struct individually
            
            let decoder = JSONDecoder()
            do{
                let retrievedData = try decoder.decode(DogAPIDataFormat.self, from: safeData)
                completionHandler(retrievedData, nil)

            }catch{
                completionHandler(nil, error)
                print(error)
            }
            
            
            //since the response is not an image file then it will not work. The return is a JSON file instead.
            
        }
        
        task.resume()
    }
    
    
    static func fetchAllBreeds(completionHandler: @escaping([String]?, Error?)-> Void){
        let allBreedsEndpoint = ConstantsFile.Endpoint.allBreedsFromAllDogsCollection.url
        let task = URLSession.shared.dataTask(with: allBreedsEndpoint) { data, response, error in
            guard let safeData = data else{
                completionHandler(nil, error)
                return
            }
            
            let decoder = JSONDecoder()
            do{
                let allBreeds = try decoder.decode(BreedsListFormat.self, from: safeData)
                let breedNames = allBreeds.message.keys.map({$0})
                completionHandler(breedNames, nil)
            }catch{
                completionHandler(nil, error)
                print(error)
            }
            
        }
        task.resume()
    }
    
   /* static func fetchImageFor(selectedBreed:String){
        guard var selectedBreedURL = URL(string: ConstantsFile.Endpoint.selectedBreedImageFromAllDogsCollectionURLPath.rawValue)else{
            print("Invalid URL.")
            return
        }
        ////breed/hound/images/random
        selectedBreedURL.appendPathComponent("api")
        selectedBreedURL.appendPathComponent("breed")
        selectedBreedURL.appendPathComponent(selectedBreed)
        selectedBreedURL.appendPathComponent("images")
        selectedBreedURL.appendPathComponent("random")
        
        print("SelectedURL: \(selectedBreedURL)")
    }
    */
}
