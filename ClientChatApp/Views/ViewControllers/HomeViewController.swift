//
//  ChatViewController.swift
//  ClientChatApp
//
//  Created by  Brycen Myanmar  on 21/05/2024.
//

import UIKit

class HomeViewController: UIViewController {
    
    private enum section : String,CaseIterable{
        case UserList = "People"
        case Chat = "Chats"
    }
    
    @IBOutlet weak var TableView   : UITableView!{
        didSet{
            TableView.registerForCell(strID: ChatCell.identifier)
            TableView.registerForCell(strID: UserListCell.identifier)
        }
    }
   

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

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

extension HomeViewController  : UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return HomeViewController.section.allCases.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch HomeViewController.section.allCases[section] {
        case .UserList:
            return 1
        case .Chat:
            return UsersViewModel.shared.chatlists.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch HomeViewController.section.allCases[indexPath.section] {
            
        case .UserList:
            let cell = tableView.dequeueReusableCell(withIdentifier: UserListCell.identifier, for: indexPath) as! UserListCell
                
            return cell
        case .Chat :
            let cell = tableView.dequeueReusableCell(withIdentifier: ChatCell.identifier, for: indexPath) as! ChatCell
                
            return cell
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return HomeViewController.section.allCases[section].rawValue
    }
    
}
