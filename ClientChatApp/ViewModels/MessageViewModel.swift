
import Foundation
import Combine

class MessageViewModel: ObservableObject {
    enum WebSocketStatus : String , Codable {
        case refresh
        case fail
    }
  

    @Published var messages: [Message] = []
    @Published var messageText: String = ""
    @Published var isLoading = false
    @Published var isShowingAlert  = false
    @Published var isNavigate  = false
    @Published var error: NetworkError? = nil
    
    var cancellables = Set<AnyCancellable>()
    let encoder = JSONEncoder()
    

  private let webSocketTask: URLSessionWebSocketTask

    init( _ id : String ) {
        print(id)
        var url = URL(string: Routes.Chat.connect)! 
        
   
        url.append(queryItems: [  URLQueryItem(name: "id", value: LocalStorage.shared.user_id)   ,  URLQueryItem(name: "redirect_id", value: id ) ])
        
        print(url)
            webSocketTask = URLSession.shared.webSocketTask(with: url)
            webSocketTask.resume()
            listenForMessages()
        }

    func sendMessage( _ message : Message) {
        
        guard let data = try? encoder.encode(message) else{
            return
        }
        let messageText = String(data: data , encoding: .utf8) ?? ""
            print(messageText)
        webSocketTask.send(.string(messageText)) { error in
                if let error = error {
                    print("Error sending message:", error)
                }else{
                    self.messages.append(message)
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
                    print("receiving message:" , text )
                    guard let m = text.decode(as: Message.self) else { return }
                    
                    self.messages.append(m)
                    
                }
              case .failure(let error):
                  
                print("Error receiving message:", error)
                  
              }
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
