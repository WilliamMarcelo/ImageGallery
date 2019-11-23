//
//  NetworkingManager.swift
//  MarvelCharacters
//
//  Created by William Gomes on 08/11/2019.
//  Copyright © 2019 William Gomes. All rights reserved.
//

import Foundation

struct NetworkingManager {

    func request<P: ParserProtocol>(networkingRequestManager: NetworkingRequestManagerProtocol,
                                    parser: P,
                                    onSuccess: @escaping (P.ModelType) -> Void,
                                    onError: @escaping (Error) -> Void) {
        
        do {
            
            let urlRequest = try networkingRequestManager.asURLRequest()
            
            let task = URLSession.shared.dataTask(with: urlRequest, completionHandler: { data, urlResponse, error in
                
                do {
                    
                    let data = try self.validateResponse(data: data, urlResponse: urlResponse, error: error)
                    
                    let result = parser.parseData(data: data)
                    
                    DispatchQueue.main.async {

                        switch result {
                            
                        case .success(let parsedModel):
                            
                            onSuccess(parsedModel)
                            
                        case .failure(let error):
                            
                            onError(error)
                        }
                    }
                    
                } catch {
                    
                    DispatchQueue.main.async {

                        onError(error)
                    }
                }
            })
            
            task.resume()
            
        } catch {
            
            onError(error)
        }
    }
    
    private func validateResponse(data: Data?, urlResponse: URLResponse?, error: Error?) throws -> Data {
        
        if let response = urlResponse as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
            
            throw NSError.buildError(domain: "Server",
                                     code: response.statusCode,
                                     title: "Server Error",
                                     description: "")
        }

        if let error = error {
            
            throw error

        } else if let data = data {
            
            return data

        } else {

            throw NSError.buildError(domain: "Response", code: 001, title: "Response Error", description: "No data")
        }
    }
}
