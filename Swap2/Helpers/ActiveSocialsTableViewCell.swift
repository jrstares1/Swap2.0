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
    var index: Int = 0
    var accountName: String = ""
    
    lazy var socialLogo: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: self.frame.width/2 - 50, y: 10, width: 180, height: 80))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var socialToggle: UISwitch = {
        let toggleView = UISwitch(frame: CGRect(x: self.frame.width - 10, y: 40, width: 50, height: 30))
        toggleView.onTintColor = UIColor.systemTeal
        toggleView.isOn = true
        toggleView.tag = index
        toggleView.isEnabled = true
        return toggleView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        addSubview(backView)
        backView.addSubview(socialLogo)
        backView.addSubview(socialToggle)
        socialToggle.isEnabled = true
        
    }
}
