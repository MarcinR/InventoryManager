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
    case success(BarcodeMonsterDetails)
    case error(Error)
}

protocol BarcodeDetailsService {
    func getDetailsForBarcode(barcode: String, completion: @escaping (BarcodeDetailsActionResult)->())
}

class BarcodeDetailsServiceImp: BarcodeDetailsService {
    
    private let decoder = JSONDecoder()
    
    func getDetailsForBarcode(barcode: String, completion: @escaping (BarcodeDetailsActionResult)->()) {
        
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
                let details = try self.decoder.decode(BarcodeMonsterDetails.self, from: data)
                completion(.success(details))
            } catch(let parsingError) {
                completion(.error(parsingError))
            }        }.resume()
    }
    
}
