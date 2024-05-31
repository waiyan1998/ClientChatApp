//
//  PeopleCell.swift
//  ClientChatApp
//
//  Created by  Brycen Myanmar  on 31/05/2024.
//

import UIKit

class PeopleCell: UICollectionViewCell {
    
    @IBOutlet weak var Name_Lb : UILabel!
    @IBOutlet weak var status_imgView : UIImageView!
    var data : User?{
        didSet{
            self.Name_Lb.text = data?.username?.firstCharactor ?? "A"
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        self.Name_Lb.backgroundColor = UIColor.randomSystemColor()
        
        // Initialization code
    }

}
