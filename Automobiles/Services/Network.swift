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
    
    
    
    func loadBrands(completion: @escaping ([Brand]?) -> Void) {
        
        let url = "http://www.mocky.io/v2/5db959e43000005a005ee206"
        
        AF.request(url, method: .post, headers: nil).responseData(completionHandler: {
            (dataRresponse) in
            if let error = dataRresponse.error {
                print("Error received requestiong data: \(error.localizedDescription)")
                completion(nil)
            }
            
            guard let data = dataRresponse.data else {
                print("No data in response")
                return completion(nil)}
            
            if let decoded = self.decodeJSON(type: BrandContainer.self, from: data) {
                completion(decoded.data) } else {
                print("Failed to decode JSON")
                completion(nil)
            }
        })
    }
    
    
    func loadModels(completion: @escaping ([Model]?) -> Void) {
        
        let url = "http://www.mocky.io/v2/5db9630530000095005ee272"
        
        AF.request(url, method: .get, headers: nil).responseData(completionHandler: {
            (dataRresponse) in
            if let error = dataRresponse.error {
                print("Error received requestiong data: \(error.localizedDescription)")
                completion(nil)
            }
            
            guard let data = dataRresponse.data else {
                print("No data in response")
                return completion(nil)}
            
            if let decoded = self.decodeJSON(type: ModelContainer.self, from: data) {
                completion(decoded.data) } else {
                print("Failed to decode JSON")
                completion(nil)
            }
        })
    }
    
    
    private func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let data = from, let response = try? decoder.decode(type.self, from: data) else { return nil }
        return response
    }
}

