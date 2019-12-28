//
//  Networking.swift
//  Automobiles
//
//  Created by Macbook on 27.12.2019.
//  Copyright © 2019 Valentin Shapovalov. All rights reserved.
//

import Foundation
import Alamofire

class Network {
    
    /// Downloading data efrom nenwork and serialization to array of `Brand`
    func loadBrands(completion: @escaping ([Brand]?, Error?) -> Void) {
        
        let url = "http://www.mocky.io/v2/5db959e43000005a005ee206"
        
        AF.request(url, method: .post, headers: nil).responseData(completionHandler: {
            (dataRresponse) in
            if let error = dataRresponse.error {
                print("Error received requestiong data: \(error.localizedDescription)")
                completion(nil, error)
            }
            
            guard let data = dataRresponse.data else {
                print("No data in response")
                return completion(nil, nil)}
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let result = try decoder.decode(Container<Brand>.self, from: data)
                completion(result.data, nil)
            } catch {
                print("Failed to decode JSON: \(error.localizedDescription)")
                completion(nil, error)
            }
        })
        
    }
    
    /// Downloading data from nenwork and serialization to array of `Model`
    func loadModels(completion: @escaping ([Model]?, Error?) -> Void) {
        
        let url = "http://www.mocky.io/v2/5db9630530000095005ee272"
        
        AF.request(url, method: .get, headers: nil).responseData(completionHandler: {
            (dataRresponse) in
            if let error = dataRresponse.error {
                print("Error received requestiong data: \(error.localizedDescription)")
                completion(nil, error)
            }
            
            guard let data = dataRresponse.data else {
                print("No data in response")
                completion(nil, nil)
                return }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let result = try decoder.decode(Container<Model>.self, from: data)
                completion(result.data, nil)
            } catch {
                print("Failed to decode JSON: \(error.localizedDescription)")
                completion(nil, error)
            }
        })
    }
}

