//
//  UserTableViewCell.swift
//  Swap2
//
//  Created by Gillian Dibbs Laming on 11/8/20.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    weak var delegate: MyCellDelegate?
    
    
//    lazy var backView : UIView = {
//        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 100))
//        return view
//    }()
//    
//    let deleteButton = UIButton(frame: CGRect(x: 300, y: 40, width: 10, height: 10))
    
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var socialLogo: UIImageView!
    
    static let identifier = "UserAccountTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "UserAccountTableViewCell", bundle: nil)
    }
    //    lazy var socialLogo: UIImageView = {
//        let imageView = UIImageView(frame: CGRect(x: self.frame.width/2 - 50, y: 10, width: 180, height: 100))
//        imageView.contentMode = .scaleAspectFit
//        return imageView
//    }()

    func configure(with title: String){
       // socialLogo!.image = UIImage(named: title) ?? nil
    }
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

    @IBAction func buttonAction(_ sender:UIButton!) {
        delegate?.didTapButton(sender)
        print("Button tapped")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
       // deleteButton.isEnabled = selected
//        addSubview(backView)
//        backView.addSubview(socialLogo)
//        backView.addSubview(deleteButton)
    }
   
    
}
protocol MyCellDelegate: class {
    func didTapButton(_ sender: UIButton)
}
    

