//
//  ActiveSocialsTableViewCell.swift
//  Swap2
//
//  Created by Mitch Frauenheim on 10/30/20.
//

import UIKit

class ActiveSocialsTableViewCell: UITableViewCell {
    
    
   // @IBOutlet weak var socialToggle: UISwitch!
    
    @IBAction func toggleSocial(_ sender: Any) {
        
    }
    
    lazy var backView : UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 100))
        return view
    }()
    
  
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
        return toggleView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        addSubview(backView)
        backView.addSubview(socialLogo)
        backView.addSubview(socialToggle)
    }
    @IBAction func statusChanged(sender: UISwitch) {
        print("this is here in the cell view")
        self.socialToggle.isOn = socialToggle.isOn ? false : true
         }
    
}
