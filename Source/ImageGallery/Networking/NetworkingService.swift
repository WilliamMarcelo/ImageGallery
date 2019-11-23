//
//  NetworkingService.swift
//  MarvelCharacters
//
//  Created by William Gomes on 19/11/2019.
//  Copyright © 2019 William Gomes. All rights reserved.
//

import Foundation

class NetworkingService<M: Codable> {
    
    func getItens(networkingRequestManager: NetworkingRequestManager,
                  onSuccess: @escaping (M) -> Void,
                  onError: @escaping (Error) -> Void) {

        NetworkingManager().request(networkingRequestManager: networkingRequestManager,
                                    parser: BaseParser<M>(),
                                    onSuccess: onSuccess,
                                    onError: onError)
    }
}
