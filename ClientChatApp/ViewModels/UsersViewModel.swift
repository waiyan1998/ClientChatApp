

import Foundation
import Combine

class UsersViewModel: ObservableObject {
    
    static let shared = UsersViewModel()
        
    
    
    @Published var userlists : [User] = []
   
    @Published var isLoading = false
    @Published var isShowingAlert  = false
    @Published var isNavigate  = false
    @Published var error: NetworkError? = nil
    
     var cancellables = Set<AnyCancellable>()
   
    func getUserLists ()  {
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
                   
                    self.userlists = data
                    
                    print("Post received: \(self.userlists)")
                })
            .store(in: &cancellables)
         
    }
   
    func getUserDetail()
    {
        isLoading = true
        isNavigate = false
        let request = UserDetailRequest()
        print(request)
        
        NetworkManager.execute(request, User.self )
            .receive(on: RunLoop.main)
            .sink { completion in
                self.isLoading = false
                
                switch completion {
                case .finished: break
                case .failure(let error):
                    self.error = error
                    print("Failed to fetch data: \(error)")
                }
                
            } receiveValue: { response  in
                print(response)
                guard let user = response.data?.first else {
                    self.isShowingAlert = true
                    return
                }
              // save data in local
                LocalStorage.shared.setData(user, .userInfo)
            }
            .store(in: &cancellables)

        
    }
    
  
}


struct UserListsRequest  : APIRequest {

  var path: String { return Routes.Auth.lists }
  var method: HTTPMethod { return .GET }
  var headers: [String : String]  {  return ["Authorization" : "Bearer " + LocalStorage.shared.token  ] }
  var body: Data? { return nil }
    

}




struct UserDetailRequest : APIRequest
{
    var path: String { return Routes.User.detail }
    
    var method: HTTPMethod { return .GET}
    
    var headers: [String : String] { return ["Authorization" : "Bearer " + LocalStorage.shared.token   ] }
    
    var body: Data?  { return nil }
    
    
}
