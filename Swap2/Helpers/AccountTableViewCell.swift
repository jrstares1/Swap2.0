//
//  AccountTableViewCell.swift
//  Swap2
//
//  Created by Gillian Dibbs Laming on 10/24/20.
//

import UIKit

class AccountTableViewCell: UITableViewCell {
    
    lazy var backView : UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 80))
        return view
    }()
    
    lazy var settingImage: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: self.frame.width/2 - 50, y: 0, width: 180, height: 80))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(backView)
        backView.addSubview(settingImage)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
