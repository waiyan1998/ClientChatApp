//
//  PeopleCell.swift
//  ClientChatApp
//
//  Created by Wai Yan Pyae Sone  on 31/05/2024.
//

import UIKit

class PeopleCell: UICollectionViewCell {
    
    let viewmodel = ChatViewModel()
 
    private func showChatRoom()
    {
        let container : UIViewController? = self.containerVC()
        let chatVC = ChatViewController.initiate(appStoryBoard: .Main)
            chatVC.chat = viewmodel.chat
            container?.show(chatVC, sender: nil )
    }
  
    @IBOutlet weak var Name_Lb : UILabel!
    @IBOutlet weak var status_imgView : UIImageView!
    
     var data : User?{
        didSet{
            self.Name_Lb.text = data?.username?.firstCharactor ?? "A"
        }
    }
    
    override var isSelected: Bool{
        didSet{
            print("Click")
            guard let user2 = data , let user1 = LocalStorage.shared.getData(key: .userInfo, User.self ) else {
                return
            }
            
            viewmodel.createChat([user1,user2])
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        //self.Name_Lb.text = randomString()
        self.Name_Lb.backgroundColor = UIColor.randomSystemColor()
        setupBindings()
        
    }
   
    private func setupBindings() {
        viewmodel.$isNavigate
            .receive(on: RunLoop.main)
            .sink { [weak self] isNavigate in
                if isNavigate
                {
                    self?.showChatRoom()
                }
              
            }
            .store(in: &viewmodel.cancellables)
    }
    

}
