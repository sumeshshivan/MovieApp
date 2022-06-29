//
//  BaseResponse.swift
//  TMDB
//
//  Created by sumesh shivan on 09/03/22.
//

import Foundation

struct BaseResponse<DataType: Decodable>: Decodable {
    var Response: String
    var Search: DataType?
    var totalResults: String
}
