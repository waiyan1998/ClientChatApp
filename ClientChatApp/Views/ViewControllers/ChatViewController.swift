//
//  MessageViewController.swift
//  ClientChatApp
//
//  Created by  Brycen Myanmar  on 23/05/2024.
//

import UIKit

class ChatViewController: UIViewController {
    
  
     var chat : Chat?
  
    
    @IBOutlet weak var TableView   : UITableView!{
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
                self?.TableView.reloadData()
            }
            .store(in: &viewModel.cancellables)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationItem.hidesBackButton = false
        self.viewModel = MessageViewModel( redirect_id )
        setupBindings()
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
        viewModel.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageCell.identifier, for: indexPath) as! MessageCell
        cell.message_lb.text = viewModel.messages[indexPath.row].content ?? ""
        cell.isSender = (viewModel.messages[indexPath.row].sender_id ?? ""  == LocalStorage.shared.user_id )
          
        return cell
    }
    
    
}
