//
//  UserTableViewCell.swift
//  Swap2
//
//  Created by Gillian Dibbs Laming on 11/8/20.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    weak var delegate: MyCellDelegate?
    
    
    lazy var backView : UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 100))
        return view
    }()
  
    lazy var deleteButton: UIButton = {
        let btn = UIButton(frame:CGRect(x: self.frame.width - 20, y: 40, width: 30, height: 30))
        btn.isEnabled = true
        btn.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        let image = UIImage(named: "delete")
        btn.setImage(image, for: .normal)
        btn.contentMode = .scaleAspectFit
        return btn
    }()
    
    
    lazy var socialLogo: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: self.frame.width/2 - 100, y: 10, width: 180, height: 100))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    
   // @IBOutlet var deleteButton: UIButton!
  //  @IBOutlet var socialLogo: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        //deleteButton!.setTitle("test", for: .normal)
        // Initialization code
//        let delete = UIImage(named: "delete") as UIImage? //todo add image
//        deleteButton.addTarget(self, action:  #selector(buttonAction(_:)), for: .touchUpInside)
//        //deleteButton.setImage(delete, for: .normal)
//        deleteButton.isEnabled = true
//        deleteButton.setTitle("test", for: .normal)
        
    }

    @objc func buttonAction(_ sender:UIButton!) {
//        delegate?.didTapButton(sender)
        print("Button tapped")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)
       
//        addSubview(backView)
//        backView.addSubview(socialLogo)
//        backView.addSubview(deleteButton)
//
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(backView)
        backView.addSubview(socialLogo)
        backView.addSubview(deleteButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
protocol MyCellDelegate: class {
    func didTapButton(_ sender: UIButton)
}
    

