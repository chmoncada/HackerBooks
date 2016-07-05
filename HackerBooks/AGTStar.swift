//
//  AGTStar.swift
//  HackerBooks
//
//  Created by Charles Moncada on 03/07/16.
//  Copyright © 2016 Charles Moncada Pizarro. All rights reserved.
//

import UIKit

class AGTStar: UIButton{
    
    
    // MARK: Initialization
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let filledStarImage = UIImage(named: "filledStar")
        let emptyStarImage = UIImage(named: "emptyStar")
        
            self.setImage(emptyStarImage, forState: .Normal)
            self.setImage(filledStarImage, forState: .Selected)
            self.setImage(filledStarImage, forState: [.Highlighted, .Selected])
            
            self.adjustsImageWhenHighlighted = false

    }
    
    override func intrinsicContentSize() -> CGSize {
        let buttonSize = Int(frame.size.height)
         let width = buttonSize
        return CGSize(width: width, height: buttonSize)
    }
    
}
