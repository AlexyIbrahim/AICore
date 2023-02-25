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


public class AILottieAnimationInfo {
    enum AILottieAnimationSource {
        case none
        case nameDir
        case nameAsset
        case url
    }
    
    enum AILottieAnimationLocation {
        case dir
        case asset
    }
    
    var source: AILottieAnimationSource!
    var name: String?
    var from: AnyObject?
    var url: String?
    
    init() {
        self.source = AILottieAnimationSource.none
        self.name = nil
        self.from = nil
        self.url = nil
    }
    
    convenience init<T: AnyObject>(nameInDir name: String, location: AILottieAnimationLocation, from: T? = nil) {
        self.init()
        
        switch location {
        case .dir:
            self.source = .nameDir
        case .asset:
            self.source = .nameAsset
        }
        self.name = name
        self.from = from
    }
    
    convenience init(url: String) {
        self.init()
        
        self.source = .url
        self.url = url
    }
}

public class AILottieAnimationView: UIView {
    //    static let shared = AILottieAnimation()
    var lottieAnimationView: LottieAnimationView = LottieAnimationView()
    
    public final class func showAnimation(animationInfo: AILottieAnimationInfo,
                                          inView containingView: UIView,
                                          loopMode: LottieLoopMode? = nil,
                                          contentMode: UIView.ContentMode? = nil,
                                          userInteractionEnabled: Bool? = nil,
                                          animationSpeed: CGFloat? = nil,
                                          duraction:TimeInterval? = nil,
                                          playCompletion: Lottie.LottieCompletionBlock? = nil) {
        AILottieAnimationView.createAnimation(animationInfo: animationInfo) { animation in
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
            aiAnimation.lottieAnimationView.play()
        }
    }
    
    public final class func stop(in view: UIView) {
        for aiAnimation in AILottieAnimationView.aiLottieAnimationViews(in: view) {
            aiAnimation.lottieAnimationView.stop()
        }
    }
    
    public final class func pause(in view: UIView) {
        for aiAnimation in AILottieAnimationView.aiLottieAnimationViews(in: view) {
            aiAnimation.lottieAnimationView.pause()
        }
    }
}

public extension AILottieAnimationView {
    final class func createAnimation(animationInfo: AILottieAnimationInfo,
                                     completion: ((LottieAnimation) -> Void)? = nil) {
        switch animationInfo.source {
        case .nameDir:
            var animation: LottieAnimation!
            if let from = animationInfo.from {
                let bundle: Bundle = (animationInfo.from != nil) ? Bundle(for: type(of: from)) : Bundle.main
                animation = LottieAnimation.named(animationInfo.name!, bundle: bundle, animationCache: DefaultAnimationCache.sharedCache)
            } else {
                animation = LottieAnimation.named(animationInfo.name!, animationCache: DefaultAnimationCache.sharedCache)
            }
            completion?(animation)
        case .nameAsset:
            var animation: LottieAnimation!
            if let from = animationInfo.from {
                let bundle: Bundle = (animationInfo.from != nil) ? Bundle(for: type(of: from)) : Bundle.main
                animation = LottieAnimation.asset(animationInfo.name!, bundle: bundle, animationCache: DefaultAnimationCache.sharedCache)
            } else {
                animation = LottieAnimation.asset(animationInfo.name!, animationCache: DefaultAnimationCache.sharedCache)
            }
            completion?(animation)
        case .url:
            if let stringUrl = animationInfo.url {
                if let url = URL(string: stringUrl) {
                    LottieAnimation.loadedFrom(url: url, closure: { animation in
                        if let animation = animation {
                            completion?(animation)
                        }
                    }, animationCache: DefaultAnimationCache.sharedCache)
                }
            }
        case nil:
            break
        case .some(.none):
            break
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
        let lottieAnimationView = aiLottieAnimationView.lottieAnimationView
        
        // animationView customization
        lottieAnimationView.animation = animation
        if let loopMode = loopMode {
            lottieAnimationView.loopMode = loopMode
        }
        if let contentMode = contentMode {
            lottieAnimationView.contentMode = contentMode
        }
        if let userInteractionEnabled = userInteractionEnabled {
            aiLottieAnimationView.isUserInteractionEnabled = userInteractionEnabled
            lottieAnimationView.isUserInteractionEnabled = userInteractionEnabled
        }
        if let animationSpeed = animationSpeed {
            lottieAnimationView.animationSpeed = animationSpeed
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
        
        aiLottieAnimationView.addSubview(lottieAnimationView)
        lottieAnimationView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        containingView.bringSubviewToFront(lottieAnimationView)
        
        
        lottieAnimationView.play { finished in
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
        DefaultAnimationCache.sharedCache.clearCache()
    }
}
