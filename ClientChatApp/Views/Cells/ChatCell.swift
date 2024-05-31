
import UIKit

class ChatCell: UITableViewCell {
    @IBOutlet weak var NameIcon_Label: UILabel!
    
    @IBOutlet weak var clickToChat_btn: UIButton!
    @IBOutlet weak var Name_Label: UILabel!
    
    
     var data : Chat?
    {
        didSet {
            self.NameIcon_Label.text = data?.members?.first?.username?.firstCharactor
            self.Name_Label.text = data?.members?.map({ $0.username ?? "" }).joined(separator: ",")
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
        
        let vc = ChatViewController.initiate(appStoryBoard: .Main)
            vc.chat_id = data?.chat_id ?? "" 
        
        container.show(vc , sender: nil )
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
