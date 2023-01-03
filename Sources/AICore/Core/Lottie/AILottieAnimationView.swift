//
//  AILottieAnimation.swift
//  iomlearning
//
//  Created by Alexy Ibrahim on 6/19/22.
//

import Foundation
import Lottie
import UIKit
import SnapKit


public class AILottieAnimationView: UIView {
    //    static let shared = AILottieAnimation()
    var animationView: LottieAnimationView = LottieAnimationView()
    
    public final class func showAnimation<T: AnyObject>(name: String? = nil,
                                                 url stringUrl: String? = nil,
                                                 from: T? = nil,
                                                 
                                                 inView containingView: UIView,
                                                 loopMode: LottieLoopMode? = nil,
                                                 contentMode: UIView.ContentMode? = nil,
                                                 userInteractionEnabled: Bool? = nil,
                                                 animationSpeed: CGFloat? = nil,
                                                 duraction:TimeInterval? = nil,
                                                 playCompletion: Lottie.LottieCompletionBlock? = nil) {
        AILottieAnimationView.createAnimation(name: name, url: stringUrl, from: from) { animation in
            let animation: LottieAnimation! = animation
            AILottieAnimationView.createAIAnimationView(animation: animation,
                                                        inView: containingView,
                                                        loopMode: loopMode,
                                                        contentMode: contentMode,
                                                        userInteractionEnabled: userInteractionEnabled,
                                                        animationSpeed: animationSpeed,
                                                        duraction: duraction,
                                                        playCompletion: playCompletion)
        }
    }
    
    public final class func hide(from view: UIView, animated:Bool = true) {
        for aiAnimation in AILottieAnimationView.aiLottieAnimationViews(in: view) {
            if animated {
                UIView.animate(withDuration: 0.3) {
                    aiAnimation.alpha = 0.0
                } completion: { (_) in
                    aiAnimation.removeFromSuperview()
                }
            } else {
                aiAnimation.removeFromSuperview()
            }
        }
    }
    
    public final class func play(in view: UIView) {
        for aiAnimation in AILottieAnimationView.aiLottieAnimationViews(in: view) {
            aiAnimation.animationView.play()
        }
    }
    
    public final class func stop(in view: UIView) {
        for aiAnimation in AILottieAnimationView.aiLottieAnimationViews(in: view) {
            aiAnimation.animationView.stop()
        }
    }
    
    public final class func pause(in view: UIView) {
        for aiAnimation in AILottieAnimationView.aiLottieAnimationViews(in: view) {
            aiAnimation.animationView.pause()
        }
    }
}

private extension AILottieAnimationView {
    final class func createAnimation<T: AnyObject>(name: String? = nil,
                                                   url stringUrl: String?,
                                                   from: T? = nil,
                                                   completion: ((LottieAnimation) -> Void)? = nil) {
        if let name = name {
            let _: Bundle? = (from != nil) ? Bundle(for: type(of: from!)) : nil
            var animation: LottieAnimation!
            if let from = from {
                animation = LottieAnimation.named(name, bundle: Bundle(for: type(of: from)), animationCache: LRUAnimationCache.sharedCache)
            } else {
                animation = LottieAnimation.named(name, animationCache: LRUAnimationCache.sharedCache)
            }
            completion?(animation)
        }
        
        if let stringUrl = stringUrl {
            if let url = URL(string: stringUrl) {
                LottieAnimation.loadedFrom(url: url, closure: { animation in
                    if let animation = animation {
                        completion?(animation)
                    }
                }, animationCache: LRUAnimationCache.sharedCache)
            }
        }
    }
    
    final class func createAIAnimationView(animation: LottieAnimation,
                                           inView containingView: UIView,
                                           loopMode: LottieLoopMode? = nil,
                                           contentMode: UIView.ContentMode? = nil,
                                           userInteractionEnabled: Bool? = nil,
                                           animationSpeed: CGFloat? = nil,
                                           duraction:TimeInterval? = nil,
                                           playCompletion: Lottie.LottieCompletionBlock? = nil) {
        let aiLottieAnimationView = AILottieAnimationView()
        aiLottieAnimationView.animationView = LottieAnimationView()
        let animationView = aiLottieAnimationView.animationView
        
        // animationView customization
        animationView.animation = animation
        if let loopMode = loopMode {
            animationView.loopMode = loopMode
        }
        if let contentMode = contentMode {
            animationView.contentMode = contentMode
        }
        if let userInteractionEnabled = userInteractionEnabled {
            aiLottieAnimationView.isUserInteractionEnabled = userInteractionEnabled
            animationView.isUserInteractionEnabled = userInteractionEnabled
        }
        if let animationSpeed = animationSpeed {
            animationView.animationSpeed = animationSpeed
        }
        
        //        let colorProvider = ColorValueProvider(UIColor.orange.lottieColorValue)
        ////        let keypath = AnimationKeypath(keys: ["**", "Fill", "**", "Color"])
        //        /// A keypath that finds the color value for all `Fill 1` nodes.
        //        let fillKeypath = AnimationKeypath(keypath: "**.Fill 1.Color")
        //        animationView.setValueProvider(colorProvider, keypath: fillKeypath)
        
        // constraints
        containingView.addSubview(aiLottieAnimationView)
        aiLottieAnimationView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        containingView.bringSubviewToFront(aiLottieAnimationView)
        
        aiLottieAnimationView.addSubview(animationView)
        animationView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        containingView.bringSubviewToFront(animationView)
        
        
        animationView.play { finished in
            playCompletion?(finished)
        }
        
        // duration
        if let duraction = duraction {
            if duraction > 0 {
                _ = Timer.scheduledTimer(withTimeInterval: duraction, repeats: false) { timer in
                    timer.invalidate()
                    DispatchQueue.main.async {
                        self.hide(from: containingView, animated: true)
                    }
                }
            }
        }
    }
    
    final class func aiLottieAnimationViews(in view: UIView) -> [AILottieAnimationView] {
        var aiLottieAnimationViews = [AILottieAnimationView]()
        for subview in view.subviews {
            if subview.isKind(of: AILottieAnimationView.self) {
                let aiLottieAnimationView: AILottieAnimationView = subview as! AILottieAnimationView
                aiLottieAnimationViews.append(aiLottieAnimationView)
            }
        }
        return aiLottieAnimationViews
    }
    
    final class func clearLottieCache() {
        LRUAnimationCache.sharedCache.clearCache()
    }
}
