//
//  NetworkingRequestManager.swift
//  MarvelCharacters
//
//  Created by William Gomes on 08/11/2019.
//  Copyright © 2019 William Gomes. All rights reserved.
//

import Foundation

protocol NetworkingRequestManagerProtocol: URLRequestProtocol {
    
    var baseURL: String { get }
    var publicAPIKey: String { get }
    var relativePath: String { get }
    var params: [URLQueryItem]? { get }
}

enum NetworkingRequestManager: NetworkingRequestManagerProtocol {
    
    case getImages(page: Int, tag: String?)
    
    var baseURL: String {
        return "https://api.flickr.com/"
    }
    
    var publicAPIKey: String {
        return "f9cc014fa76b098f9e82f1c288379ea1"
    }

    var relativePath: String {
        
        return "services/rest/"
    }
    
    var params: [URLQueryItem]? {
        
        switch self {
        case .getImages(let page, let tag):
            
            var queryItems: [URLQueryItem] = []
            
            if let tag = tag {
                
                queryItems.append(URLQueryItem(name: "tags", value: "\(tag)"))
            }

            queryItems.append(URLQueryItem(name: "page", value: "\(page)"))
            queryItems.append(URLQueryItem(name: "method", value: "flickr.photos.search"))
            
            return queryItems
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        
        var queryItems = [URLQueryItem(name: "api_key", value: publicAPIKey),
                          URLQueryItem(name: "format", value: "json"),
                          URLQueryItem(name: "nojsoncallback", value: "1")]
        
        if let params = params {
            
            queryItems.append(contentsOf: params)
        }
        
        var urlComponents = URLComponents(string: "\(baseURL)\(relativePath)")!
        urlComponents.queryItems = queryItems

        var urlRequest = URLRequest(url: urlComponents.url!)
        urlRequest.timeoutInterval = 5
        urlRequest.cachePolicy = .returnCacheDataElseLoad
        
        return urlRequest
    }
}
