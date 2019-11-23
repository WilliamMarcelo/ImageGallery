//
//  ParserProtocol.swift
//  MarvelCharacters
//
//  Created by William Gomes on 08/11/2019.
//  Copyright © 2019 William Gomes. All rights reserved.
//

import Foundation

protocol ParserProtocol {

    associatedtype ModelType: Codable

    func parseData(data: Data) -> Result<ModelType, Error>
}
