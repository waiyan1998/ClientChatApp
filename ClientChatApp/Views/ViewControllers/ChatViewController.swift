//
//  MessageViewController.swift
//  ClientChatApp
//
//  Created by  Brycen Myanmar  on 23/05/2024.
//

import UIKit

class ChatViewController: UIViewController {
    
    private var sender_id : String {
        LocalStorage.shared.getUserInfo()?.user_id ?? ""
    }
     var chat_id : String  = ""
    
    @IBOutlet weak var TableView   : UITableView!{
        didSet{
            TableView.registerForCell(strID: MessageCell.identifier)
        }
    }
    @IBOutlet weak var Message_TF: UITextField!
    @IBOutlet weak var bottom_height: NSLayoutConstraint!
   let viewModel = MessageViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        // Do any additional setup after loading the view.
    }
    
    private func setupBindings() {
        viewModel.$messages
            .receive(on: RunLoop.main)
            .sink { [weak self] lists in
                print(lists)
                self?.TableView.reloadData()
            }
            .store(in: &viewModel.cancellables)
    }
    
  
     @IBAction func sendClick(_ sender: UIButton) {
         let message = Message( content : self.Message_TF.text , sender_id : sender_id , chat_id : chat_id )
         viewModel.sendMessage(message)
     }
    
    
     

}


extension ChatViewController : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageCell.identifier, for: indexPath) as! MessageCell
        cell.message_lb.text = viewModel.messages[indexPath.row].content ?? ""
        cell.isSender = (viewModel.messages[indexPath.row].sender_id ?? ""  == LocalStorage.shared.getUserInfo()?.user_id ?? "")
          
        return cell
    }
    
    
}
