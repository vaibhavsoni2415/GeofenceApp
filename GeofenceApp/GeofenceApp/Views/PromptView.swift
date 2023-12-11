//
//  PromptView.swift
//  GeoFenceTestApp
//
//  Created by  Vaibhav on 12/11/23.
//

import UIKit

final class PromptView: UIView {
    
    var message: String?{
        didSet{
            messageLabel.text = message
        }
    }

    @IBOutlet weak var messageLabel: UILabel!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    class func instanceFromNib() -> PromptView {
        return UINib(nibName: "PromptView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! PromptView
    }

}
