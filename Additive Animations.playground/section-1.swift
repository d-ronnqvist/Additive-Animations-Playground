// Playground - noun: a place where people can play

/*
 This playground can be used as a stating point for experimenting with
 mutliple additive animations in Core Animation. It creates two additive
 animations for the position property and uses them to achieve a movement
 along a complex path.

 It is the accompanying playgound for the "Multiple Animations" blog post
 http://ronnqvi.st/multiple-animations/
*/

import Cocoa
import QuartzCore

import XCPlayground // for the live preview


// Two functions to create the paths for the animations
// (I don't think there is a way to forward declare them(?))
func createCirclePath() -> CGPathRef {
    let radius: CGFloat = 30
    let π = CGFloat(M_PI)
    
    let circlePath = CGPathCreateMutable()
    CGPathMoveToPoint(circlePath, nil, 0, -radius)
    CGPathAddArc(circlePath, nil, 0, 0, radius, 3*π/2, π/2, true)
    CGPathAddArc(circlePath, nil, 0, 0, radius, π/2, 3*π/2, true)
    
    return circlePath
}

func createHeartPath() -> CGPathRef {
    let scaleFactor: CGFloat = 2.0
    
    let smallRadius: CGFloat = 5.0   * scaleFactor
    let bigRadius:   CGFloat = 20.0  * scaleFactor
    // Note: iOS and OS X have flipped Y axis compared to each other
    let h: CGFloat = -170  * scaleFactor
    let w: CGFloat = -145  * scaleFactor
    let h2 = h*0.4
    
    var heartPath = CGPathCreateMutable()
    CGPathMoveToPoint(  heartPath, nil, -w*0.25, -h*0.25)
    
    CGPathAddArcToPoint(heartPath, nil, -w, -h,  0, -h2, bigRadius)
    CGPathAddArcToPoint(heartPath, nil,  0, -h2, w, -h,  1.0)
    CGPathAddArcToPoint(heartPath, nil,  w, -h,  0,  0,  bigRadius)
    CGPathAddArcToPoint(heartPath, nil,  0,  0, -w, -w,  smallRadius)
    
    CGPathCloseSubpath(heartPath)
    
    return heartPath
}

// ==================================================


// Define the paths
let circlePath = createCirclePath()
let heartPath  = createHeartPath()

// Create a view to get the live preview
let view = NSView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
view.wantsLayer = true // make the view layer backed (views aren't by default on OS X)

// Show a live preview of the view
XCPShowView("An additive animation", view)


// Create the small round layer that animates
var layer = CALayer()
layer.frame = CGRect(x: view.frame.midX, y: 45, width: 20, height: 20)
layer.backgroundColor = NSColor.orangeColor().CGColor;
layer.cornerRadius = 10
view.layer.addSublayer(layer)


// Create the dashed heart shape
// This makes it easier to see the path that the layer is following.
let heart = CAShapeLayer()
heart.path = heartPath
heart.fillColor   = nil
heart.strokeColor = NSColor.grayColor().CGColor
heart.lineWidth   = 4
heart.lineDashPattern = [14, 14]
heart.position = layer.position
view.layer.addSublayer(heart)


// Create the animation objects

/*
 Note: Since the layer doesn't move from one value to another
 but instead closes the path and comes back to the original value,
 there isn't a non-additive animation in this example.

 This means that this example doesn't perfectly match the breakdown
 of the complext animation in the blog post. If the property would 
 animate to a new value, there would be non-additive animation as well.
*/
let followHeartShape = CAKeyframeAnimation(keyPath: "position")
followHeartShape.additive = true
followHeartShape.path     = heartPath
followHeartShape.duration = 5
followHeartShape.repeatCount     = HUGE
followHeartShape.calculationMode = "paced"

let circleAround = CAKeyframeAnimation(keyPath: "position")
circleAround.additive = true
circleAround.path     = circlePath
circleAround.duration = 0.275
circleAround.repeatCount     = HUGE
circleAround.calculationMode = "paced"


// Add the animations 
// (since _all_ animations are additive, the order doesn't really matter)
layer.addAnimation(followHeartShape, forKey: "follow the shape of a heart")
layer.addAnimation(circleAround,     forKey: "loop around")

