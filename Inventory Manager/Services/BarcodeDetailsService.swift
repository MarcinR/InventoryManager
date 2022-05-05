//
//  BarcodeMonsterService.swift
//  Inventory Manager
//
//  Created by Marcin Ratajczak on 13/04/2022.
//  Copyright © 2022 A. All rights reserved.
//

import Foundation

public enum InternalError: Error {
    case customError(message: String)
}
// TODO: create sepearate class for error
extension InternalError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .customError(let message):
            return message
        }
    }
}


enum BarcodeDetailsActionResult {
    case success(BarcodeProductDetails?)
    case error(Error)
}

protocol BarcodeDetailsService {
    func getMonsterDBDetailsForBarcode(barcode: String, completion: @escaping (BarcodeDetailsActionResult)->())
    func getBooksDBDetailsForBarcode(barcode: String, completion: @escaping (BarcodeDetailsActionResult)->())
}

class BarcodeDetailsServiceImp: BarcodeDetailsService {
    
    private let decoder = JSONDecoder()
    
    func getMonsterDBDetailsForBarcode(barcode: String, completion: @escaping (BarcodeDetailsActionResult)->()) {
        
        guard let url = URL(string:"https://barcode.monster/api/" + barcode) else {
            completion(.error(InternalError.customError(message:"Invalid URL")))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            let customError = InternalError.customError(message: "Invalid API respoinse")
            guard let data = data else {
                completion(.error(error ?? customError))
                return
            }
            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                      let name = json["description"] as? String
                else {
                          completion(.success(nil))
                          return
                      }
                let imageAddress =  json["image_url"] as? String
                let trimmedName = name.replacingOccurrences(of: "(from barcode.monster)", with: "")
                let details = BarcodeProductDetails(code: barcode, image_url: imageAddress, name: trimmedName, details: nil)
                completion(.success(details))
            } catch(let parsingError) {
                completion(.error(parsingError))
            }        }.resume()
    }
    
    func getBooksDBDetailsForBarcode(barcode: String, completion: @escaping (BarcodeDetailsActionResult)->()) {
        guard let url = URL(string:"https://openlibrary.org/isbn/" + barcode + ".json") else {
            completion(.error(InternalError.customError(message:"Invalid URL")))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            let customError = InternalError.customError(message: "Invalid API respoinse")
            guard let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode),
                  let data = data
            else {
                completion(.error(error ?? customError))
                return
            }
            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                      let name = json["title"] as? String
                else {
                          completion(.success(nil))
                          return
                      }
                let details = BarcodeProductDetails(code: barcode, image_url: nil, name: name, details: "book")
                completion(.success(details))
            } catch(let parsingError) {
                completion(.error(parsingError))
            }        }.resume()
    }
}
