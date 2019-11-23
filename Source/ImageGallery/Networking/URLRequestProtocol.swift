//
//  URLRequestProtocol.swift
//  MarvelCharacters
//
//  Created by William Gomes on 08/11/2019.
//  Copyright © 2019 William Gomes. All rights reserved.
//

import Foundation

protocol URLRequestProtocol {

    func asURLRequest() throws -> URLRequest
}

extension URLRequestProtocol {

    var urlRequest: URLRequest? {

        return try? asURLRequest()
    }
}

extension URLRequest: URLRequestProtocol {

    func asURLRequest() throws -> URLRequest { return self }
}
