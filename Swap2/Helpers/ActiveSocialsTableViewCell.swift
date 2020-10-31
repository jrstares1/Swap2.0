//
//  ActiveSocialsTableViewCell.swift
//  Swap2
//
//  Created by Mitch Frauenheim on 10/30/20.
//

import UIKit

class ActiveSocialsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var socialLogo: UIImageView!
    @IBOutlet weak var socialToggle: UISwitch!
    
    @IBAction func toggleSocial(_ sender: Any) {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
