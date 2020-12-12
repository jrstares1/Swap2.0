//
//  GenerateQRCode.swift
//  Swap2
//
//  Created by Mitch Frauenheim on 10/27/20.
//

import Foundation
import UIKit

var dataString = "";

func generateCode(uid: String) -> UIImage? {
    dataString = "https://swap-2b365.web.app/landing/swap.html?uid=" + uid
    
    let data = dataString.data(using: String.Encoding.ascii)
    
    if let filter = CIFilter(name: "CIQRCodeGenerator") {
        filter.setValue(data, forKey: "inputMessage")
        let transform = CGAffineTransform(scaleX: 3, y: 3)

        if let output = filter.outputImage?.transformed(by: transform) {
            return UIImage(ciImage: output)
        }
    }
    return nil
}
