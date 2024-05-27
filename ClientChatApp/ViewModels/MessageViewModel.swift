
import Foundation
import Combine

class MessageViewModel: ObservableObject {
  @Published var messages: [Message] = []
  @Published var messageText: String = ""
    var cancellables = Set<AnyCancellable>()
    let encoder = JSONEncoder()
    

  private let webSocketTask: URLSessionWebSocketTask

    init() {
        let url = URL(string: Routes.Chat.message)! // Replace with your server URL
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

    private func listenForMessages() {
      webSocketTask.receive { [weak self] result in
              switch result {
              case .success(let message):
                if case let .string(text) = message {
                    let m = text.decode(as: Message.self)
                    self?.messages.append(m ?? Message())
                }
              case .failure(let error):
                print("Error receiving message:", error)
              }
        self?.listenForMessages() // Call recursively to listen for new messages
            }
    }

    deinit {
        webSocketTask.cancel()
    }
}

