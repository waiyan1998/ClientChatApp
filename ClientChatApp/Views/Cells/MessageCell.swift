//
//  MessgaeCell.swift
//  ClientChatApp
//
//  Created by  Brycen Myanmar  on 23/05/2024.
//

import UIKit

class MessageCell: UITableViewCell {
    
    @IBOutlet weak var right: NSLayoutConstraint!
    @IBOutlet weak var left : NSLayoutConstraint!
    
   
    
    @IBOutlet weak var message_lb: UILabel!
    
    var isSender : Bool = true
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        self.right.isActive = isSender
        self.left.isActive  = !isSender
    }
    
   

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
