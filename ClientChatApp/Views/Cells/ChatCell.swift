
import UIKit

class ChatCell: UITableViewCell {
    @IBOutlet weak var NameIcon_Label: UILabel!
    
    @IBOutlet weak var clickToChat_btn: UIButton!
    @IBOutlet weak var Name_Label: UILabel!
    
    
     var data : Chat?
    {
        didSet {
            guard let user = data?.members?.filter({ $0.user_id != LocalStorage.shared.user_id }).first else { return }
            
            self.NameIcon_Label.text = user.username?.firstCharactor
            self.Name_Label.text = user.username
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.NameIcon_Label.backgroundColor = UIColor.randomSystemColor()
    
        // Initialization code
    }
    
    @IBAction func ClickToChat(_ sender: UIButton) {
        print("ClickToChat")
        guard let container = self.containerVC() else{
            return
        }
        let chatVC = ChatViewController.initiate(appStoryBoard: .Main)
            chatVC.chat  = self.data
        container.show(chatVC, sender: nil)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
