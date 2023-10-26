//
//  ViewController.swift
//  HightSchools
//
//  Created by Allegro on 10/25/23.
//

import UIKit

class ViewController: UIViewController {
    
    let splashScreenImage = UIImageView(image: UIImage(named: "mainLogo")!)
    let splashView = UIView()
    let logoImage = UIImageView(image: UIImage(named: "schoolApp")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func initiateSplashScreen() {
        splashView.backgroundColor =  systemColor
        self.view.addSubview(splashView)
        self.splashView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        self.splashScreenImage.contentMode = .scaleAspectFit
        self.splashView.addSubview(splashScreenImage)
        
        self.logoImage.contentMode = .scaleAspectFit
        self.logoImage.alpha = 0
        self.splashView.addSubview(logoImage)
        
        var x = (UIScreen.main.bounds.width - 60) / 2
        let y = Int(UIScreen.main.bounds.height / CGFloat(2.0))
        
        
        self.splashScreenImage.frame = CGRect(x: Int(x), y: y, width: 60, height: 60)
        x = (UIScreen.main.bounds.width - 250) / 2
        self.logoImage.frame = CGRect(x: Int(x), y: y + 10 , width: 250, height: 80)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.initiateSplashScreen()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            self.scaleDownAnimation()
        }
    }
    
    func scaleDownAnimation() {
        UIView.animate(withDuration: 0.0, animations:  {
//                        self.splashScreenImage.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        }) { ( success ) in
            self.scaleUpAnimation()
        }
    }
    
    func scaleUpAnimation() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            self.splashScreenImage.transform = CGAffineTransform(scaleX: 3, y: 3)
        }) { ( success ) in
            self.moveUp()
        }
    }
    
    func removeSplashScreen() {
        self.splashView.removeFromSuperview()
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            UIView.animate(withDuration: 3, delay: 0.25,options: UIView.AnimationOptions.curveEaseOut,animations: {
                self.splashScreenImage.backgroundColor = .orange
                self.splashScreenImage.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
                //                         self.animationButton.isEnabled = false // If you want to restrict the button not to repeat animation..You can enable by setting into true
                
            },completion: nil)
        }
    }
    
    func moveUp() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            let originalTransform = self.splashScreenImage.transform
            let scaledTransform = originalTransform.scaledBy(x: 1, y: 1)
            let scaledAndTranslatedTransform = scaledTransform.translatedBy(x: 0.0, y: -40.0)
            
            UIView.animate(withDuration: 0.7, animations: {
                self.splashScreenImage.transform = scaledAndTranslatedTransform
            })
            //Frame Option 1:
            //            self.splashScreenImage.frame = CGRect(x: self.splashScreenImage.frame.origin.x, y: 120, width: self.splashScreenImage.frame.width, height: self.splashScreenImage.frame.height)
            
            //Frame Option 2:
            //self.myView.center = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 4)
            //            self.myView.backgroundColor = .blue
            
        } ,completion: { finish in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.logoImage.alpha = 1
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    LoadingOverlay.shared.showOverlay(view: UIApplication.shared.keyWindow!)
                    let highSchoolViewModel = HighSchoolViewModel()
                    
                    highSchoolViewModel.fetchSATScores()
                    highSchoolViewModel.fetchHighSchools()
                    
                    DispatchQueue.main.async {
                                                    LoadingOverlay.shared.hideOverlayView()
                                                    let vc = HighSchoolVC(viewModel: highSchoolViewModel)
                                                    self.navigationController?.pushViewController(vc, animated: false)
                }
                }
            }
        })
    }
}

