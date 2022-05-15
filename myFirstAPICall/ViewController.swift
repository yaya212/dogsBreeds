//
//  ViewController.swift
//  myFirstAPICall
//
//  Created by Yahya Emad on 03/04/2022.
//

import UIKit

class ViewController: UIViewController {

    //Outlets & properties
    @IBOutlet weak var imageViewOutlet: UIImageView!
    @IBOutlet weak var pickerViewOutlet: UIPickerView!
    var breeds:[String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        pickerViewOutlet.dataSource = self
        pickerViewOutlet.delegate = self
        DogsAPIHandler.fetchAllBreeds(completionHandler: handleAllBreedsResponse(retrievedBreeds:error:))
        
    }


    func handleImageFileResponse(image: UIImage?, error: Error?){
        DispatchQueue.main.async {
            self.imageViewOutlet.image = image
        }
    }
    
    
    func handleJSONResponse(retrivedJSON: DogAPIDataFormat?, error: Error?){
        guard let safeBreedJSONData = retrivedJSON else{
            return
        }
        
        let retrievedBreedImageURLString = safeBreedJSONData.message
        DogsAPIHandler.retrieveImage(with: retrievedBreedImageURLString, completionHandler: handleImageFileResponse(image:error:))
    }
    

    func handleAllBreedsResponse(retrievedBreeds:[String]?, error:Error?){
        guard let safeBreeds = retrievedBreeds else{
            return
        }
        breeds = safeBreeds
        
        //to reload the pickerView after the update of the breeds array
        DispatchQueue.main.async {
            self.pickerViewOutlet.reloadAllComponents()
        }
        
    }

}

extension ViewController: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let safeBreeds = breeds else{
            return 0
        }
        return safeBreeds.count
    }
}


extension ViewController: UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let safeBreeds = breeds else{
            return nil
        }
        return safeBreeds[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        guard let safeBreeds = breeds else{
            print("There are no breeds probably there is an error storing in an array!")
            return
        }
        
        //Here I want to make a call for requesting a random image for that selected breed
        let selectedBreedURLString = ConstantsFile.Endpoint.selectedBreedImageFromAllDogsCollectionURLPath(safeBreeds[row]).stringValue
        
        guard let selectedBreedURL = URL(string: selectedBreedURLString) else{
            return
        }
        DogsAPIHandler.handleJSON(for: selectedBreedURL, completionHandler: handleJSONResponse(retrivedJSON:error:))
    }
}
