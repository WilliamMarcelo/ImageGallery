//
//  BaseParser.swift
//  MarvelCharacters
//
//  Created by William Gomes on 19/11/2019.
//  Copyright © 2019 William Gomes. All rights reserved.
//

import Foundation

class BaseParser<M: Codable>: ParserProtocol {

    private let rootPath: String?

    init(rootPath: String? = "photos") {

        self.rootPath = rootPath
    }

    func parseData(data: Data) -> Result<M, Error> {

        return ParserHelper.parseJSONData(rootNodeName: rootPath, data: data)
    }
}
