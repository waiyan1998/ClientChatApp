

import UIKit

class AppTextField: UITextField {
    
   
    
    var rightPadding : CGFloat = 10
    var leftPadding : CGFloat = 10
    
    private var eye_btn = UIButton()
    
    
    override var isSecureTextEntry: Bool {
        didSet {
            
            if  self.isSecureTextEntry  {
                eye_btn.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
            }else{
                eye_btn.setImage(UIImage(systemName: "eye"), for: .normal)
            }
        }
    }
    
    var leftIcon : UIView?
    {
        didSet{
            self.leftView = leftIcon
            self.leftViewMode = .always
            self.leftPadding  += self.frame.height
        }
    }
    var rightIcon : UIView?
    {
        didSet{
            self.rightView = rightIcon
            self.rightViewMode = .always
            self.rightPadding  += self.frame.height
        }
    }

    override func draw(_ rect: CGRect) {
        self.font  = UIFont.systemFont(ofSize: 17)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if  self.isSecureTextEntry  {
            self.rightIcon = eye_btn
        }
        eye_btn.addTarget(self, action: #selector(toggle(_:) ), for: .touchDown)
        eye_btn.tintColor = .gray
    }
    
    
    @objc func toggle( _ sender : UIButton )
    {
        print("click")
        self.isSecureTextEntry.toggle()
    
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 0, y: 0, width: self.frame.height , height: self.frame.height)
    }
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: self.frame.width - self.frame.height , y: 0, width: self.frame.height , height: self.frame.height)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
      return bounds.inset(by: UIEdgeInsets(top: 0, left: leftPadding, bottom: 0, right: rightPadding))
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: leftPadding, bottom: 0, right: rightPadding))
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: leftPadding , bottom: 0, right: rightPadding))
    }

}
