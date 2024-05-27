//
//  ChatViewController.swift
//  ClientChatApp
//
//  Created by  Brycen Myanmar  on 21/05/2024.
//

import UIKit

class ChatListViewController: UIViewController {
    
    @IBOutlet weak var TableView   : UITableView!{
        didSet{
            TableView.registerForCell(strID: ChatCell.identifier)
        }
    }
    private let viewModel = ChatListsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        viewModel.getUserInfoLists()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Chats"
        self.navigationController?.navigationItem.largeTitleDisplayMode  = .always
        self.navigationItem.hidesBackButton = true
    }
    

    private func setupBindings() {
        viewModel.$lists
            .receive(on: RunLoop.main)
            .sink { [weak self] lists in
                self?.TableView.reloadData()
            }
            .store(in: &viewModel.cancellables)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ChatListViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatCell.identifier, for: indexPath) as! ChatCell
            cell.container = self
            cell.data  = viewModel.lists[indexPath.row]
           
        return cell
    }
    
    
}
