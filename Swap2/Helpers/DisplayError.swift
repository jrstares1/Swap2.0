//
//  DisplayError.swift
//  Swap2
//
//  Created by Mitch Frauenheim on 12/6/20.
//

import Foundation
import UIKit

func displayError(title: String, message: String) -> UIAlertController {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
    
    return alert
}
