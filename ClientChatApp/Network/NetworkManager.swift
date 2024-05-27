//
//  LoginModel.swift
//  RealtimeChatApp
//
//  Created by  Brycen Myanmar  on 15/05/2024.
//

import Foundation
import Combine

enum HTTPMethod : String {
    case GET = "GET"
    case PATCH = "PATCH"
    case PUT  = "PUT"
    case POST = "POST"
    case DELETE = "DELETE"
}
protocol APIRequest  {
  var path: String { get }
  var method: HTTPMethod { get }
  var headers: [String: String] { get }
  var body: Data? { get }
}

protocol AuthAPIRequest  {
    var path: String { get }
    var method: HTTPMethod { get }
    var username : String { get }
    var password : String{ get }
  
}

enum NetworkError: Error {
  case invalidURL
  case requestError(_ underlyingError: Error)
  case decodingError(_ underlyingError: Error)
  case responseError(_ statusCode: Int)
  case unknownError
}


struct NetworkManager {
    
    static func execute<T: Codable>(_ request: APIRequest , _ T : T.Type) -> AnyPublisher<BaseResponse<T>, NetworkError> {
        guard let url = URL(string: request.path) else {
            return Fail(error: .invalidURL).eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.allHTTPHeaderFields = request.headers
        urlRequest.httpBody = request.body
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { data, response in
                print(response)
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkError.unknownError
                }
                
                if (200..<300).contains(httpResponse.statusCode) {
                    return data
                } else {
                    throw NetworkError.responseError(httpResponse.statusCode)
                }
            }
            .decode(type: BaseResponse<T>.self, decoder: JSONDecoder())
            .mapError { error in
                if let networkError = error as? NetworkError {
                    return networkError
                } else {
                    return NetworkError.requestError(error)
                }
            }
            .eraseToAnyPublisher()
        
        
        
    }
    
   
    
    
    }
    
    

    




final class  Routes {
     static let api = "http://127.0.0.1:8080/"
     static let api_chat = "ws://127.0.0.1:8080/"
    
    final class Auth {
         static let login = api + "users/login"
         static let register = api + "users/register"
         static let lists = api + "users/lists"
    }
    
    final class Chat {
         static let lists = api + "chat/getlists"
         static let message = api_chat + "chat/message"
    }
}
