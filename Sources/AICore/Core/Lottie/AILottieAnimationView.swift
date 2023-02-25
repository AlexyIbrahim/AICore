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
    
    public enum AILottieAnimationLocation {
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
    
    public convenience init(name: String, location: AILottieAnimationLocation, from: AnyObject? = nil) {
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
    
    public convenience init(url: String) {
        self.init()
        
        self.source = .url
        self.url = url
    }
}

public class AILottieAnimationView: UIView {
    //    static let shared = AILottieAnimation()
    public var lottieAnimationView: LottieAnimationView = LottieAnimationView()
    public var lottieAnimation: LottieAnimation!
    
    public final class func showAnimation(animationInfo: AILottieAnimationInfo,
                                          inView containingView: UIView,
                                          color: UIColor? = nil,
                                          loopMode: LottieLoopMode? = nil,
                                          contentMode: UIView.ContentMode? = nil,
                                          userInteractionEnabled: Bool? = nil,
                                          animationSpeed: CGFloat? = nil,
                                          duraction:TimeInterval? = nil,
                                          playCompletion: Lottie.LottieCompletionBlock? = nil,
                                          callback: ((AILottieAnimationView) -> Void)? = nil,
                                          errorCallback: (() -> ())? = nil) {
        AILottieAnimationView.createAnimation(animationInfo: animationInfo, successCallback: { lottieAnimation in
            AILottieAnimationView.createAIAnimationView(animation: lottieAnimation,
                                                        loopMode: loopMode,
                                                        contentMode: contentMode,
                                                        userInteractionEnabled: userInteractionEnabled,
                                                        animationSpeed: animationSpeed) { aiLottieAnimationView in
                // constraints
                containingView.addSubview(aiLottieAnimationView)
                aiLottieAnimationView.snp.makeConstraints { (make) in
                    make.edges.equalTo(0)
                    make.centerX.equalToSuperview()
                    make.centerY.equalToSuperview()
                }
                containingView.bringSubviewToFront(aiLottieAnimationView)
                
                aiLottieAnimationView.addSubview(aiLottieAnimationView.lottieAnimationView)
                aiLottieAnimationView.lottieAnimationView.snp.makeConstraints { (make) in
                    make.edges.equalTo(0)
                    make.centerX.equalToSuperview()
                    make.centerY.equalToSuperview()
                }
                containingView.bringSubviewToFront(aiLottieAnimationView.lottieAnimationView)
                
                aiLottieAnimationView.lottieAnimationView.play { finished in
                    playCompletion?(finished)
                }
                
                // duration
                if let duraction = duraction {
                    if duraction > 0 {
                        _ = Timer.scheduledTimer(withTimeInterval: duraction, repeats: false) { timer in
                            timer.invalidate()
                            DispatchQueue.main.async {
                                AILottieAnimationView.hide(from: containingView, animated: true)
                            }
                        }
                    }
                }
                
                callback?(aiLottieAnimationView)
            }
        }, errorCallback: {
            errorCallback?()
        })
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
                                     successCallback: ((LottieAnimation) -> Void)? = nil,
                                     errorCallback: (() -> ())? = nil) {
        var animation: LottieAnimation?
        switch animationInfo.source {
        case .nameDir:
            if let from = animationInfo.from {
                let bundle: Bundle = (animationInfo.from != nil) ? Bundle(for: type(of: from)) : Bundle.main
                animation = LottieAnimation.named(animationInfo.name!, bundle: bundle, animationCache: DefaultAnimationCache.sharedCache)
            } else {
                animation = LottieAnimation.named(animationInfo.name!, animationCache: DefaultAnimationCache.sharedCache)
            }
            if let animation = animation {
                successCallback?(animation)
            } else {
                errorCallback?()
            }
        case .nameAsset:
            if let from = animationInfo.from {
                let bundle: Bundle = (animationInfo.from != nil) ? Bundle(for: type(of: from)) : Bundle.main
                animation = LottieAnimation.asset(animationInfo.name!, bundle: bundle, animationCache: DefaultAnimationCache.sharedCache)
            } else {
                animation = LottieAnimation.asset(animationInfo.name!, animationCache: DefaultAnimationCache.sharedCache)
            }
            if let animation = animation {
                successCallback?(animation)
            } else {
                errorCallback?()
            }
        case .url:
            if let stringUrl = animationInfo.url {
                if let url = URL(string: stringUrl) {
                    LottieAnimation.loadedFrom(url: url, closure: { animation in
                        if let animation = animation {
                            successCallback?(animation)
                        } else {
                            errorCallback?()
                        }
                    }, animationCache: DefaultAnimationCache.sharedCache)
                }
            }
        case nil:
            errorCallback?()
        case .some(.none):
            errorCallback?()
        }
    }
    
    final class func createAIAnimationView(animation: LottieAnimation,
                                           color: UIColor? = nil,
                                           loopMode: LottieLoopMode? = nil,
                                           contentMode: UIView.ContentMode? = nil,
                                           userInteractionEnabled: Bool? = nil,
                                           animationSpeed: CGFloat? = nil,
                                           callback: ((AILottieAnimationView) -> Void)? = nil) {
        let aiLottieAnimationView = AILottieAnimationView()
        aiLottieAnimationView.lottieAnimation = animation
        
        let lottieAnimationView = aiLottieAnimationView.lottieAnimationView
        
        // animationView customization
        lottieAnimationView.animation = aiLottieAnimationView.lottieAnimation
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
        
        if let color = color {
            let keypath = AnimationKeypath(keys: ["**", "Fill", "**", "Color"])
            let colorProvider = ColorValueProvider(color.lottieColorValue)
            
            lottieAnimationView.setValueProvider(colorProvider, keypath: keypath)
        }
        
        callback?(aiLottieAnimationView)
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
