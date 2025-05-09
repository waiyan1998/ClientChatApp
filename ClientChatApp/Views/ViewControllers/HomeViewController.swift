//
//  ChatViewController.swift
//  ClientChatApp
//
//  Created by  Wai Yan Pyae Sone  on 21/05/2024.
//

import UIKit

class HomeViewController: UIViewController {
  

    private var userlists : [User] = []
    private var chatlists : [Chat] = []
    
    @IBOutlet weak var CollectionView : UICollectionView!
    {
        didSet {
            CollectionView.dataSource = self
            CollectionView.delegate = self
            CollectionView.registerForCell(strID: PeopleCell.nibName)
           
        }
    }
    
   
    @IBOutlet weak var TableView   : UITableView!{
        didSet{
            TableView.delegate = self
            TableView.dataSource = self 
            TableView.registerForCell(strID: ChatCell.nibName)
        }
    }
   

    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = CollectionView.collectionViewLayout as? AlignedCollectionViewFlowLayout
        layout?.horizontalAlignment = .left
        
        UsersViewModel.shared.getUserLists()
        UsersViewModel.shared.getUserDetail()
        ChatViewModel.shared.getChatlists()
        
        setupBinding()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationItem.hidesBackButton = true 
        self.navigationController?.isNavigationBarHidden  = true

    }
    
   func setupBinding ()
    {
        UsersViewModel.shared.$userlists
            .receive(on: RunLoop.main)
            .sink { [weak self ] lists  in
                self?.userlists  = lists
                self?.CollectionView.reloadData()
            }
            .store(in: &UsersViewModel.shared.cancellables)
        
        ChatViewModel.shared.$chatlists
            .receive(on: RunLoop.main)
            .sink { [weak self ] lists  in
                self?.chatlists  = lists
                self?.TableView.reloadData()
            }
            .store(in: &ChatViewModel.shared.cancellables)
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
   
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chatlists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
      let cell = tableView.dequeueReusableCell(withIdentifier: ChatCell.identifier, for: indexPath) as! ChatCell
          cell.data = self.chatlists[indexPath.row]
        return cell
    }
        
    
    
}

extension HomeViewController  : UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return UsersViewModel.shared.userlists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PeopleCell.identifier, for: indexPath) as! PeopleCell
            cell.data = self.userlists[indexPath.row]
        return cell
    }
    
   
    

}
