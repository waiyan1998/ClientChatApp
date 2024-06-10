
import Foundation

final class  Routes {
     static let api = "http://127.0.0.1:8080/"
     static let api_chat = "ws://127.0.0.1:8080/"
    
    final class Auth {
         static let login = api + "users/login"
         static let register = api + "users/register"
         static let lists = api + "users/lists"
    }
    final class User {
         static let detail = api + "users/me"
        
    }
    
    final class Chat {
         static let connect = api_chat + "chat/connect"
         static let message = api_chat + "chat/messages"
         static let lists = api + "chat/getlists"
         static let add  = api + "chat/add"
         static let send  = api + "chat/send"
         static let getMessages  = api + "chat/messages"
    }
}


