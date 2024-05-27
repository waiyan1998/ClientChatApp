//
//  NSObject .swift
//  ClientChatApp
//
//  Created by  Brycen Myanmar  on 21/05/2024.
//

import Foundation

extension NSObject {
    
    var identifier : String {
        return String(describing: self)
    }
    
    var className : String {
        return String(describing: self)
    }
}
