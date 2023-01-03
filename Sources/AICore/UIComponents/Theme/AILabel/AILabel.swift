//
//  AILabel.swift
//  Shelvz
//
//  Created by Alexy Ibrahim on 10/3/22.
//

import UIKit

public class AILabel: UILabel {
    
    public var style: AILabelStyle? {
        didSet {
            self.applyStyle()
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    public override func awakeFromNib() {
        self.applyStyle()
    }
    
    private func applyStyle() {
        guard let style = style else { return }
        
        self.font = style.font.font
        self.textColor = style.textColor.color
    }
}
