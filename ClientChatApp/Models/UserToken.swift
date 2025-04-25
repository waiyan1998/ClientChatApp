//
//  UserToken.swift
//  RealtimeChatApp
//
//  Created by Wai Yan Pyae Sone  on 15/05/2024.
//

import Foundation

struct  UserToken  : Codable  {
   
    let access_token : String?
    let user_id:  String?
 
    
    init( access_token  :  String , user_id : String ) {
        self.access_token = access_token
        self.user_id = user_id
    }
    

}
