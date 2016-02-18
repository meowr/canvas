//
//  CanvasViewController.swift
//  canvas
//
//  Created by Tina Chen on 2/17/16.
//  Copyright © 2016 tinachen. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var trayView: UIView!
    
    var trayOriginalCenter: CGPoint!
    var trayDownOffset: CGFloat!
    var trayUp: CGPoint!
    var trayDown: CGPoint!
    var newlyCreatedFace: UIImageView!
    var newlyCreatedFaceOriginalCenter: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trayDownOffset = 160
        trayUp = trayView.center
        trayDown = CGPoint(x: trayView.center.x ,y: trayView.center.y + trayDownOffset)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func didPanTray(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(view)
        var point = sender.locationInView(view)
        var velocity = sender.velocityInView(view)

        if sender.state == UIGestureRecognizerState.Began {
            trayOriginalCenter = trayView.center
        } else if sender.state == UIGestureRecognizerState.Changed {
            trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
        } else if sender.state == UIGestureRecognizerState.Ended {
            if velocity.y > 0 {
                UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options:[] , animations: { () -> Void in
                    self.trayView.center = self.trayDown
                    }, completion: { (Bool) -> Void in
                })
            } else {
                UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options:[] , animations: { () -> Void in
                    self.trayView.center = self.trayUp
                    }, completion: { (Bool) -> Void in
                })
            }
        }
    }
    
    @IBAction func didPanFace(sender: UIPanGestureRecognizer) {
        var imageView = sender.view as! UIImageView
        var translation = sender.translationInView(view)

        if sender.state == UIGestureRecognizerState.Began {
            newlyCreatedFace = UIImageView(image: imageView.image)
            view.addSubview(newlyCreatedFace)
            newlyCreatedFace.center = imageView.center
            newlyCreatedFace.center.y += trayView.frame.origin.y
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
            
            var panGestureRecognizer = UIPanGestureRecognizer(target:self, action: "onCustomPan:")
            newlyCreatedFace.userInteractionEnabled = true
            newlyCreatedFace.addGestureRecognizer(panGestureRecognizer)
            
            var pinchGestureRecognizer = UIPinchGestureRecognizer(target:self, action: "onCustomPinch:")
            newlyCreatedFace.addGestureRecognizer(pinchGestureRecognizer)
            pinchGestureRecognizer.delegate = self
            
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.newlyCreatedFace.transform = CGAffineTransformMakeScale(2, 2)
                }, completion: nil)

        } else if sender.state == UIGestureRecognizerState.Changed {
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
        } else if sender.state == UIGestureRecognizerState.Ended {
            UIView.animateWithDuration(0.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options:[] , animations: { () -> Void in
                self.newlyCreatedFace.transform = CGAffineTransformMakeScale(1.5, 1.5)
                }, completion: nil)
        }
    }
    
    func onCustomPan(sender: UIPanGestureRecognizer) {
        var translation = sender.translationInView(view)
        
        if sender.state == UIGestureRecognizerState.Began {
            newlyCreatedFace = sender.view as! UIImageView
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
        } else if sender.state == UIGestureRecognizerState.Changed {
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
        }
    }
    
    func onCustomPinch(sender: UIPinchGestureRecognizer) {
        let scale = sender.scale
        self.newlyCreatedFace.transform = CGAffineTransformMakeScale(scale, scale)
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer!, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer!) -> Bool {
        return true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
