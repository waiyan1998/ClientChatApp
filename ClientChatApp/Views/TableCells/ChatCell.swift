
import UIKit

class ChatCell: UITableViewCell {
    @IBOutlet weak var NameIcon_Label: UILabel!
    
    @IBOutlet weak var clickToChat_btn: UIButton!
    @IBOutlet weak var Name_Label: UILabel!
    
    weak var container : UIViewController?
     var data : User?
    {
        didSet {
            self.NameIcon_Label.text = data?.username?.firstCharactor
            self.Name_Label.text = data?.username
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.NameIcon_Label.backgroundColor = UIColor.randomSystemColor()
    
        // Initialization code
    }
    
    @IBAction func ClickToChat(_ sender: UIButton) {
        let vc = MessageViewController.initiate(appStoryBoard: .Main)
            vc.recipient_id = data?.user_id ?? "" 
        
        self.container?.show(vc , sender: nil)
        print("Click")
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
