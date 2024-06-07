
import Foundation
import Combine

class MessageViewModel: ObservableObject {


    @Published var messages: [Message] = []
    @Published var messageText: String = ""
    @Published var isLoading = false
    @Published var isShowingAlert  = false
    @Published var isNavigate  = false
    @Published var error: NetworkError? = nil
    
    var cancellables = Set<AnyCancellable>()
    let encoder = JSONEncoder()
    

    private var  webSocketTask : URLSessionWebSocketTask!

    init( chat_id : String ) {
        
        let request = WebSocketRequest()
        
        guard let url = URL(string: request.path)?.appending([URLQueryItem(name: "id", value: chat_id)]) else {
            return
        }
       
        var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = request.method.rawValue
            urlRequest.allHTTPHeaderFields = request.headers
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = request.body
        
        
        webSocketTask = URLSession.shared.webSocketTask(with: urlRequest)
        webSocketTask.resume()
        self.listenForMessages()
        
        
    }
        

    func sendMessage( _ message : Message) {
       
        guard let data = try? encoder.encode(message) else{
            return
        }
        let messageText = String(data: data , encoding: .utf8) ?? ""
        
        
        webSocketTask.send(.string(messageText)) { error in
                if let error = error {
                    print("Error sending message:", error)
                }else{
                    print("sent")
                 
                   
                }
            }
        
    }
    
    func _sendMessage( _ message : Message )
    {
    
        let request = SendMessageRequest(message)
        NetworkManager.execute(request, Message.self)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion   in
                switch completion{
                    
                case .finished: break
                case .failure( let error ):
                    print(error)
                }
            }, receiveValue: { response  in
                if response.data != nil && response.statusCode ?? 0  > 0 {
                    // send saved info with WebSocket
                }
            })
            .store(in: &cancellables)
    }
    
    func getMessages(_ chat_id : String )
    {
        let request = GetMessagesReqeust()
        NetworkManager.execute(request , with: [URLQueryItem(name: "id", value: chat_id )] ,  Message.self)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion  in
                switch completion {
                    
                case .finished: break
                case .failure( let error ):
                    print(error)
                }
            }, receiveValue: { response  in
                guard let messages = response.data ,response.statusCode ?? 0 > 0 else {
                    return
                }
                
                self.messages = messages
            })
            .store(in: &cancellables)
    }
    

    private func listenForMessages() {
      webSocketTask.receive {  result in
              switch result {
              case .success(let message):
                 
                if case let .string(text) = message {
                   
                    guard let m = text.decode(as: Message.self) else { return }
                    
                    self.messages.append(m)
                    
                    
                }
              case .failure(let error):
                  
                print("Error receiving message:", error)
                  
              }
          self.listenForMessages()
            }
      
    }

    deinit {
        webSocketTask.cancel()
    }
}

struct GetMessagesReqeust : APIRequest {
    
    var path: String {  Routes.Chat.getMessages }
    var method: HTTPMethod { .GET}
    var headers: [String : String]  {  return ["Authorization" : "Bearer " + LocalStorage.shared.token  ] }
    var body: Data? { nil }
    
    
}

struct SendMessageRequest : APIRequest {
    
    var path: String {  Routes.Chat.send }
    var method: HTTPMethod { .POST}
    var headers: [String : String]  {  return ["Authorization" : "Bearer " + LocalStorage.shared.token  ] }
    var body: Data?
    
    init( _ message : Message )
    {
        self.body = try? JSONEncoder().encode(message)
    }
    
    
}

struct WebSocketRequest : APIRequest {
    
    var path: String { Routes.Chat.connect  }
    
    var method: HTTPMethod { .GET }
    
    var headers: [String : String]  { [ "Authorization" : "Bearer " + LocalStorage.shared.token ] }
    
    var body: Data?
    
}
