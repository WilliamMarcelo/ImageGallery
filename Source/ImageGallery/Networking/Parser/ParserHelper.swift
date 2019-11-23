//
//  ParserHelper.swift
//  MarvelCharacters
//
//  Created by William Gomes on 19/11/2019.
//  Copyright © 2019 William Gomes. All rights reserved.
//

import Foundation

class ParserHelper {

    private init () { }
    
    static func parseJSONData<M: Codable>(rootNodeName: String? = nil,
                                          data: Data) -> Result<M, Error> {

        do {

            let jsonData: Data

            if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {

                if let nodeName = rootNodeName {

                    jsonData = try JSONSerialization.data(withJSONObject: json[nodeName] ?? [:],
                                                          options: .prettyPrinted)
                } else {

                    jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                }

            } else if let jsonArray = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [Any] {

                jsonData = try JSONSerialization.data(withJSONObject: jsonArray, options: .prettyPrinted)

            } else {

                return .failure(NSError.buildError(domain: "Parser",
                                                   code: 1,
                                                   title: "Parser Error",
                                                   description: "Unable to find the right JSONSerialization"))
            }

            let decoder = JSONDecoder()

            let parsedModel = try decoder.decode(M.self, from: jsonData)
            return .success(parsedModel)

        } catch {

            debugPrint(String(data: data, encoding: .utf8) ?? "No Data")
            debugPrint(error)

            return .failure(error)
        }
    }
}
