//
//  ActiveSocialsTableViewCell.swift
//  Swap2
//
//  Created by Mitch Frauenheim on 10/30/20.
//

import UIKit

class ActiveSocialsTableViewCell: UITableViewCell {
    

    
    lazy var backView : UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 100))
        return view
    }()
    
    var accountName: String = ""
    
    lazy var socialLogo: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: self.frame.width/2 - 50, y: 10, width: 180, height: 100))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var socialToggle: UISwitch = {
        let toggleView = UISwitch(frame: CGRect(x: self.frame.width - 10, y: 40, width: 50, height: 30))
        toggleView.onTintColor = UIColor.systemTeal
        toggleView.isOn = true
        toggleView.addTarget(self, action: #selector(statusChanged), for: .valueChanged)
        toggleView.isEnabled = true
        return toggleView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        addSubview(backView)
        backView.addSubview(socialLogo)
        backView.addSubview(socialToggle)
        socialToggle.isEnabled = true
        
    }

    @IBAction func statusChanged(sender: UISwitch) {
        print("status changed")
        print(sender.isOn)
        print("account to remove " + self.accountName)
        
        //TODO
        //call to backend -- Austin?
    }
    
}
