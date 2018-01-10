//
//  ViewController.swift
//  CoreAnimationApp
//
//  Created by Alex Paul on 1/9/18.
//  Copyright © 2018 Alex Paul. All rights reserved.
//

import UIKit

// Layer Properties to Animate
enum PropertyKeys: String {
    case BorderColor = "Border Color"
    case BorderWidth = "Border Width"
    case CornerRadius = "Corner Radius"
    case Shadow = "Shadow"
    case Opacity = "Opacity"
    case SwapImage = "Swap Image"
    case Position = "Position"
    
    // are 3D Transforms
    case RotationX = "Rotation X"
    case RotationY = "Rotation Y"
    case RotationZ = "Rotation Z"
    case Scale = "Scale"
    case Translation = "Translation"
}

class LayerPropertyViewController: UIViewController {
    // data model for cells - a list of Layer Animatabel Properties
    let properties = [PropertyKeys.BorderColor.rawValue,
                      PropertyKeys.BorderWidth.rawValue,
                      PropertyKeys.CornerRadius.rawValue,
                      PropertyKeys.Shadow.rawValue,
                      PropertyKeys.Opacity.rawValue,
                      PropertyKeys.RotationX.rawValue,
                      PropertyKeys.RotationY.rawValue,
                      PropertyKeys.RotationZ.rawValue,
                      PropertyKeys.Translation.rawValue,
                      PropertyKeys.SwapImage.rawValue,
                      PropertyKeys.Scale.rawValue,
                      PropertyKeys.Position.rawValue]
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    
    var currentAnimation: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up datasource and delegate
        tableView.dataSource = self
        tableView.delegate = self
        
        defaultLayerValues()
    }
    
    func defaultLayerValues() {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor.black.cgColor
        
        // shadow defaults
        imageView.layer.shadowOpacity = 0
        imageView.layer.shadowOffset = CGSize.zero
        
        imageView.layer.opacity = 1
        imageView.layer.cornerRadius = 0
        
        imageView.layer.contents = UIImage(named:"dog")?.cgImage
    }
    
    // share instance of self 
    static func storyboardInstance() -> LayerPropertyViewController {
        // here we are getting the storyboard that contains the LayerPropertyViewController
        let storyboard = UIStoryboard(name: "LayerProperty", bundle: nil)
        
        // get and instantiate LayerPropertyViewController
        let layerPropertyVC = storyboard.instantiateViewController(withIdentifier: "LayerPropertyViewController") as! LayerPropertyViewController
        return layerPropertyVC
    }
    
    @IBAction func animate(button: UIButton) {
        switch currentAnimation {
        case PropertyKeys.BorderColor.rawValue:
            animateBorderColor()
        case PropertyKeys.BorderWidth.rawValue:
            animateBorderWidth()
        case PropertyKeys.CornerRadius.rawValue:
            animateCornerRadius()
        case PropertyKeys.Shadow.rawValue:
            animateShadow()
        case PropertyKeys.Opacity.rawValue:
            animateOpacity()
            
        // 3D Transform Animations
        case PropertyKeys.RotationX.rawValue:
            animateRotationX()
        case PropertyKeys.RotationY.rawValue:
            animateRotationY()
        case PropertyKeys.RotationZ.rawValue:
            animateRotationZ()
        case PropertyKeys.Scale.rawValue:
            animateScale()
        case PropertyKeys.Translation.rawValue:
            animateTranslation()
            
        case PropertyKeys.SwapImage.rawValue:
            animateSwapImage()
        case PropertyKeys.Position.rawValue:
            animatePosition()
            
        default:
            break
        }
    }
    
    @IBAction func reset() {
        imageView.layer.removeAllAnimations()
        defaultLayerValues()
    }
}

extension LayerPropertyViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return properties.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PropertyCell", for: indexPath)
        let property = properties[indexPath.row]
        cell.textLabel?.text = property
        return cell
    }
}

extension LayerPropertyViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let property = properties[indexPath.row]
        currentAnimation = property
    }
}

// MARK:- Animation Functions - using core animation
extension LayerPropertyViewController {
    func animateBorderColor() {
        let animation = CABasicAnimation(keyPath: "borderColor")
        animation.fromValue = UIColor.black.cgColor
        animation.toValue = UIColor.orange.cgColor
        animation.duration = 0.5
        imageView.layer.add(animation, forKey: nil)
        imageView.layer.borderColor = UIColor.orange.cgColor
    }
    
    func animateBorderWidth() {
        let animation = CABasicAnimation(keyPath: "borderWidth")
        animation.fromValue = 1.0
        animation.toValue = 10.0
        animation.duration = 0.5
        imageView.layer.add(animation, forKey: nil)
        imageView.layer.borderWidth = 10.0
    }
    
    func animateCornerRadius() {
        let animation = CABasicAnimation(keyPath: "cornerRadius")
        animation.fromValue = 0
        animation.toValue = imageView.bounds.width/2
        animation.duration = 3.0
        imageView.layer.add(animation, forKey: nil)
        imageView.layer.cornerRadius = imageView.bounds.width/2
    }
    
    func animateShadow() {
        // animate shadowOpacity
        // default opacity is 0
        let opacityAnimation = CABasicAnimation(keyPath: "shadowOpacity")
        opacityAnimation.fromValue = 0 // minimum value
        opacityAnimation.toValue = 1 // maximum value
        
        // final value is not on by default
        // you have to explicity set the final value if you need it to stick
        imageView.layer.shadowOpacity = 1
        
        
        // animate the shadow offset
        // default is CGSize.zero
        let offsetAnimation = CABasicAnimation(keyPath: "shadowOffset")
        offsetAnimation.fromValue = CGSize.zero
        offsetAnimation.toValue = CGSize(width: 5.0, height: 5.0)
        imageView.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        
        // creat group animation for shadow animation
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [opacityAnimation, offsetAnimation]
        groupAnimation.duration = 1.0 
        imageView.layer.add(groupAnimation, forKey: nil)
    }
    
    func animateOpacity() {
        let animation = CABasicAnimation(keyPath: "opacity")
        let customTimingFunction = CAMediaTimingFunction(controlPoints: 1, 0.22, 0.83, 0.67)
        //animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.timingFunction = customTimingFunction
        animation.fromValue = 1.0
        animation.toValue = 0
        animation.duration = 2.0
        imageView.layer.add(animation, forKey: nil)
        
        // no final value since we do not want animation to stay
    }
    
    func animateRotationX() {
        let animation = CABasicAnimation(keyPath: "transform.rotation.x")
        let angleRadian = CGFloat(2.0 * .pi) // 360
        animation.fromValue = 0 // degrees
        animation.byValue = angleRadian
        animation.duration = 5.0 // seconds
        animation.repeatCount = Float.infinity
        imageView.layer.add(animation, forKey: nil)
    }
    
    func animateRotationY() {
        let animation = CABasicAnimation(keyPath: "transform.rotation.y")
        let angleRadian = CGFloat(2.0 * .pi) // 360
        animation.fromValue = 0 // degrees
        animation.byValue = angleRadian
        animation.duration = 5.0 // seconds
        animation.repeatCount = Float.infinity
        imageView.layer.add(animation, forKey: nil)
    }
    
    func animateRotationZ() {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        let angleRadian = CGFloat(2.0 * -.pi) // 360
        animation.fromValue = 0 // degrees
        animation.byValue = angleRadian
        animation.duration = 5.0 // seconds
        animation.repeatCount = Float.infinity
        imageView.layer.add(animation, forKey: nil)
    }
    
    func animateScale() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        let toValue = CATransform3DMakeScale(0.01, 0.01, 0)
        let fromValue = CATransform3DMakeScale(1, 1, 0)
        
        animation.fromValue = fromValue
        animation.toValue = toValue
        animation.duration = 2.0
        animation.repeatCount = Float.infinity
        imageView.layer.add(animation, forKey: nil)
    }
    
    // 3D Translation using CAKeyframeAnimation
    func animateTranslation() {
        let toTopLeft = CATransform3DMakeTranslation(-view.layer.position.x, -view.layer.position.y, 0)     // top left
        let toBottomRight = CATransform3DMakeTranslation(view.layer.position.x, view.layer.position.y, 0)   // bottom right
        let toTopRight = CATransform3DMakeTranslation(view.layer.position.x, -view.layer.position.y, 0)     // top right
        let toBottomLeft = CATransform3DMakeTranslation(-view.layer.position.x, view.layer.position.y, 0)   // bottom left
        let keyframeAnimation = CAKeyframeAnimation(keyPath: "transform")
        keyframeAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        keyframeAnimation.values = [CATransform3DIdentity,
                                    toTopLeft,
                                    CATransform3DIdentity,
                                    toTopRight,
                                    CATransform3DIdentity,
                                    toBottomLeft,
                                    CATransform3DIdentity,
                                    toBottomRight,
                                    CATransform3DIdentity]
        keyframeAnimation.duration = 4.0
        keyframeAnimation.repeatCount = Float.infinity
        imageView.layer.add(keyframeAnimation, forKey: nil)
    }
    
    func animatePosition() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        animation.fromValue = imageView.layer.position
        animation.toValue = CGPoint(x: -view.frame.origin.x, y: -view.frame.origin.y)
        animation.duration = 1.0
        imageView.layer.add(animation, forKey: nil)
    }
    
    func animateSwapImage() {
        let animation = CABasicAnimation(keyPath: "contents")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        animation.fromValue = UIImage(named:"dog")?.cgImage
        animation.toValue = UIImage(named:"lion")?.cgImage
        animation.duration = 2.0
        imageView.layer.add(animation, forKey: nil)
        imageView.layer.contents = UIImage(named:"lion")?.cgImage
    }
}

// You can implement the animation's delegate to get stop and start events
extension LayerPropertyViewController: CAAnimationDelegate {
    func animationDidStart(_ anim: CAAnimation) {
        print("animationDidStart: \(anim.description)")
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        print("animationDidStop: \(anim.description) finshed: \(flag)")
    }
}


