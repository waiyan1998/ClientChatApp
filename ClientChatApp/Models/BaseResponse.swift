//
//  User.swift
//  RealtimeChatApp
//
//  Created by  Brycen Myanmar  on 15/05/2024.
//

import Foundation


struct BaseResponse < T : Codable > : Codable  {
    let statusCode : Int?
    let message : String?
    let data : [T]?

}

	
