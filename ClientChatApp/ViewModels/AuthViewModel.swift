//
//  LoginViewModel.swift
//  RealtimeChatApp
//
//  Created by  Brycen Myanmar  on 15/05/2024.
//

import Foundation
import Combine


class AuthViewModel: ObservableObject {
    
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isLoading = false
    @Published var isShowingAlert  = false
    @Published var isNavigate   = false
    @Published var error: NetworkError? = nil
    
    var cancellables: Set<AnyCancellable> = []
    
    func login() {
        print("login")
         guard !username.isEmpty || !password.isEmpty   else {
            self.isShowingAlert = true
            return
        }
        
        isLoading = true
        isNavigate  = false
        error = nil
        
     
        let request = LoginRequest(username: username, password: password)
        print(request)
        NetworkManager.execute(request , UserToken.self)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    
                    self.isLoading = false
                    print("Successfully received data.")
                    
                case .failure(let error):
                    self.error = error
                    self.isLoading = false
                    print("Failed to fetch data: \(error)")
                }
            }, receiveValue: { response in
                guard let  user_token = response.data?.first , response.statusCode ?? 0 > 0  else {
                    self.isShowingAlert = true
                    return
                }
                
                self.isNavigate = true
                LocalStorage.shared.setData(user_token, .userToken)
                print("Post received: \(user_token)")
            })
            .store(in: &cancellables)
        
    }
    
    
}
    
struct LoginRequest: APIRequest {

  var path: String { return Routes.Auth.login }
  var method: HTTPMethod { return .GET }
  var headers: [String : String] = [:]
  var body: Data? { return nil }
    
    init ( username : String , password : String )
    {
        let loginString = String(format: "%@:%@", username, password)
        print(loginString)
        let loginData = loginString.data(using: .utf8)!
    
        let base64LoginString =  "Basic " + loginData.base64EncodedString()
        
        self.headers = ["Authorization" : base64LoginString ]
        
    }
}
