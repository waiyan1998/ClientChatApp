//
//  MessgaeCell.swift

import UIKit

class MessageCell: UITableViewCell {
    var label  = PaddingLabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    init( _ data : Message , isSender : Bool = true ) {
        super.init(style: .default, reuseIdentifier: MessageCell.identifier)
        label.text = data.content
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor =  isSender ? .systemBlue : .gray
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 15
        label.numberOfLines = 50
        label.leftInset = 15
        label.rightInset = 15
        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        label.bottomAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.bottomAnchor, constant: 10).isActive = true
        label.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: 0).isActive = true
        
        if isSender{
            label.rightAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.rightAnchor, constant: -15).isActive = true
        }else {
            label.leftAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.leftAnchor, constant: 15).isActive = true
        }
    
     
    }
    
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
