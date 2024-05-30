

import Foundation
import Combine

class ChatListsViewModel: ObservableObject {
    
    @Published var lists : [User] = []
    @Published var isLoading = false
    @Published var isShowingAlert  = false
    @Published var isNavigate  = false
    @Published var error: NetworkError? = nil
    
     var cancellables = Set<AnyCancellable>()
   
    func getUserInfoLists ()  {
        print("getUserInfoLists")
        isLoading = true
        let request = UserListsRequest()
      
        print(request.headers)
        
        NetworkManager.execute(request , User.self)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        
                        self.isLoading = false
                        
                        
                    case .failure(let error):
                        self.error = error
                        self.isLoading = false
                        
                        print("Failed to fetch data: \(error)")
                    }
                }, receiveValue: { response in
                  
                    guard let  data = response.data , response.statusCode ?? 0 > 0  else {
                        self.isShowingAlert = true
                        return
                    }
                   
                    self.isNavigate = true
                    self.lists = data
                    
                    
                    
                    print("Post received: \(self.lists)")
                })
            .store(in: &cancellables)
            
        
             
           
          
    }
}


struct UserListsRequest  : APIRequest {

  var path: String { return Routes.Auth.lists }
  var method: HTTPMethod { return .GET }
  var headers: [String : String]  {  return ["Authorization" : "Bearer " + (LocalStorage.shared.getUserInfo()?.access_token ?? "")  ] }
  var body: Data? { return nil }
    

}
