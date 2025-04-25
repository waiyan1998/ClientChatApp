//
//  MessageViewController.swift
//  ClientChatApp
//
//  Created by Wai Yan Pyae Sone on 23/05/2024.
//

import UIKit

class ChatViewController: UIViewController {
    
  
    var chat : Chat?
    private var messages  : [Message] = []
    {
        didSet {
            TableView.reloadData()
        }
    }
        didSet{
            TableView.registerForCell(strID: MessageCell.identifier)
        }
    }
      
    var redirect_id : String {
        guard let members = chat?.members else { return  "" }
        
        for m in members {
            if m.user_id != LocalStorage.shared.user_id
            {
                return m.user_id ?? ""
            }
        }
        return "" 
    }
    
    
    
    @IBOutlet weak var Message_TF: UITextField!
    @IBOutlet weak var bottom_height: NSLayoutConstraint!
    var viewModel : MessageViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
    }
    
    private func setupBindings() {
        viewModel.$messages
            .receive(on: RunLoop.main)
            .sink { [weak self] lists in
                print(lists)
                
                self?.messages = lists
            }
            .store(in: &viewModel.cancellables)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationItem.hidesBackButton = false
       
        viewModel = MessageViewModel(chat_id: self.chat?.chat_id ?? "" )
        setupBindings()
        viewModel.getMessages(self.chat?.chat_id ?? "" )
    }
  
     @IBAction func sendClick(_ sender: UIButton) {
         guard let content = Message_TF.text else {
             return
         }
         guard let chat_id  = self.chat?.chat_id else {
             return
         }
         let message = Message(content: content ,chat_id: chat_id )
         
            viewModel.sendMessage(message)
     }
    
    
     

}


extension ChatViewController : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MessageCell(self.messages[indexPath.row] , isSender:  self.messages[indexPath.row].sender_id == LocalStorage.shared.user_id )
        return cell
    }
    
    
}
