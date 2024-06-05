

import Foundation
import Combine

final class ChatViewModel {
    
    @Published var chatlists : [Chat] = []
    @Published var chat : Chat?
    @Published var isLoading = false
    @Published var isShowingAlert  = false
    @Published var isNavigate  = false
    @Published var error: NetworkError? = nil
    var cancellables = Set<AnyCancellable>()
    
    func createChat ( _ members : [User] ) {
        print("createChat")
        isLoading = true
        isNavigate = false
        
        let request = CreateChatRequest(members)
        print(request)
        
        NetworkManager.execute(request , Chat.self )
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                
                    switch completion {
                    case .finished: break
                    case .failure(let error):
                        self.error = error
                        print("Failed to fetch data: \(error)")
                    }
                
                }, receiveValue: { response in
                  
                    print(response)
                    guard let  chat = response.data?.first , response.statusCode ?? 0 > 0  else {
                        self.isShowingAlert = true
                        return
                    }
                    self.chat = chat
                    self.isNavigate = true
                  
                    print("Post received: \(chat)")
                })
            .store(in: &cancellables)
        
    }
    
    
}

struct CreateChatRequest  : APIRequest {
    struct CreateChat : Encodable {
        
        var members : [User]
    }
    
  var path: String { return Routes.Chat.add }
  var method: HTTPMethod { return .POST }
  var headers: [String : String]  {  return ["Authorization" : "Bearer " + LocalStorage.shared.token ] }
  var body: Data?
    
     init( _ members : [User] ) {
        
         self.body = try? JSONEncoder().encode( CreateChat( members: members))
         print(String(data: self.body! , encoding: .utf8)!)
      
    }
    
 
}



struct ChatListsRequest  : APIRequest {

  var path: String { return Routes.Chat.lists }
  var method: HTTPMethod { return .GET }
  var headers: [String : String]  {  return ["Authorization" : "Bearer " +  LocalStorage.shared.token  ] }
  var body: Data? { return nil }
 
}
