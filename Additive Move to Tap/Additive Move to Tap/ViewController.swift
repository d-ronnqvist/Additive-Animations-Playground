//
//  ViewController.swift
//  Additive Move to Tap
//
//  Created by David Rönnqvist on 24/06/14.
//  Copyright (c) 2014 David Rönnqvist. All rights reserved.
//

import UIKit
import QuartzCore

var myBlue   = UIColor(red: 74.0/255.0, green: 165.0/255.0, blue: 227.0/255.0, alpha: 1.0)
var myOrange = UIColor(red: 1.0,        green: 185.0/255.0, blue: 0.0,         alpha: 1.0)

class ViewController: UIViewController {
    
    var additiveAnimationsAreEnabled = false
    
    let layer = CALayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layer.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        layer.backgroundColor = myOrange.CGColor
        layer.position = view.center
        
        view.layer.addSublayer(layer)
    }

    // Toggle the feature
    @IBAction func additiveAnimationsDidToggle(sender: UISwitch) {
        additiveAnimationsAreEnabled = sender.on
        
        layer.backgroundColor = additiveAnimationsAreEnabled ? myBlue.CGColor : myOrange.CGColor
    }

    // Move the layer to the tapped point
    @IBAction func userDidTap(sender: UITapGestureRecognizer) {
        let touchPoint   = sender.locationInView(view)
        let presentation = layer.presentationLayer() as CALayer
        let currentPoint = presentation.position
        
        let animation            = CABasicAnimation(keyPath: "position")
        animation.duration       = 1.5 // a long animation so that the effect is easier to see
        animation.timingFunction = CAMediaTimingFunction(name: "easeInEaseOut") 
        
        // use nil when the animation is additive but a key when it's not
        var animationKey: NSString? = nil // use nil or a unique key to not cancel the animations
        
        if additiveAnimationsAreEnabled {
            animation.additive = true
            
            let difference = CGPoint(
                x: layer.position.x - touchPoint.x,
                y: layer.position.y - touchPoint.y
            )
            
            // from -(new-old) to zero (additive)
            animation.fromValue = NSValue(CGPoint: difference)
            animation.toValue   = NSValue(CGPoint: CGPointZero)
        } else {
            // from old to new
            animation.fromValue = NSValue(CGPoint: currentPoint)
            animation.toValue   = NSValue(CGPoint: touchPoint)
            
            animationKey = "move the layer"
        }
        
        // disable the implicit animation
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        layer.position = touchPoint
        CATransaction.commit()
        
        // add the explicit animtion
        layer.addAnimation(animation, forKey:animationKey)
    }
    
}

