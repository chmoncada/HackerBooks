//
//  AGTStar.swift
//  HackerBooks
//
//  Created by Charles Moncada on 03/07/16.
//  Copyright © 2016 Charles Moncada Pizarro. All rights reserved.
//

import UIKit

class AGTStar: UIView {
    
    // MARK: Properties
    
//    var rating = 0 {
//        didSet {
//            setNeedsLayout()
//        }
//    }
    //var ratingButtons = [UIButton]()
    var spacing = 5
    //var stars = 5
    
    let button = UIButton()
    // We create the variable with a property observer
    var isFavorite = false {
        didSet {
            setNeedsLayout()
        }
    }
    
    // MARK: Initialization
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let filledStarImage = UIImage(named: "filledStar")
        let emptyStarImage = UIImage(named: "emptyStar")
//
//        let button = UIButton()
//
//        button.setImage(emptyStarImage, forState: .Normal)
//        //button.setImage(filledStarImage, forState: .Selected)
//        //button.setImage(filledStarImage, forState: [.Highlighted, .Selected])
//        
//        button.adjustsImageWhenHighlighted = false
//        
//        //button.addTarget(self, action: #selector(AGTStar.favoriteButtonTapped(_:)), forControlEvents: .TouchDown)
//        //ratingButtons += [button]
//        addSubview(button)
        
        //for _ in 0..<5 {
        

            button.setImage(emptyStarImage, forState: .Normal)
            button.setImage(filledStarImage, forState: .Selected)
            button.setImage(filledStarImage, forState: [.Highlighted, .Selected])
            
            button.adjustsImageWhenHighlighted = false
            
            button.addTarget(self, action: #selector(AGTStar.favoriteButtonTapped(_:)), forControlEvents: .TouchDown)
            //ratingButtons += [button]
            addSubview(button)
        //}
    }
    
    override func layoutSubviews() {
        // Set the button's width and height to a square the size of the frame's height.
        let buttonSize = Int(frame.size.height)
        var buttonFrame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
        
        // Offset each button's origin by the length of the button plus spacing.
        //for (index, button) in ratingButtons.enumerate() {
            //buttonFrame.origin.x = CGFloat(index * (buttonSize + spacing))
            //buttonFrame.origin.x = CGFloat((buttonSize + spacing))
            buttonFrame.origin.x = CGFloat(spacing)
            button.frame = buttonFrame
        //}
        //updateButtonSelectionStates()
    }
    
    override func intrinsicContentSize() -> CGSize {
        let buttonSize = Int(frame.size.height)
        //let width = (buttonSize + spacing) * 2
        let width = buttonSize
        return CGSize(width: width, height: buttonSize)
    }
    
    // MARK: Button Action
    
    func favoriteButtonTapped(button: UIButton) {
        //rating = ratingButtons.indexOf(button)! + 1
        isFavorite = !isFavorite
        button.selected = isFavorite
        print("Favorite? ", isFavorite)
        //updateButtonSelectionStates()
    }
    
//    func updateButtonSelectionStates() {
//        for (index, button) in ratingButtons.enumerate() {
//            // If the index of a button is less than the rating, that button should be selected.
//            button.selected = index < rating
//        }
//    }

}
