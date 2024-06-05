
import Foundation

struct Message  : Codable {
    
    var message_id : UUID?
    var content  : String?
    var sender_id : String?
    var chat_id : String?
    var createDate : String?
    
    init( content: String? , sender_id: String? = LocalStorage.shared.user_id , chat_id: String , createDate: String? =  Date().toString() ) {
        self.message_id = UUID()
        self.content = content
        self.sender_id = sender_id
        self.chat_id = chat_id
        self.createDate = createDate
    }
    
}
