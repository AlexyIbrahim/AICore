//
//  AIToast.swift
//  
//
//  Created by Alexy Ibrahim on 3/24/23.
//

import UIKit

import UIKit
import SnapKit
import RxSwift
import RxRelay

public enum AIToastPosition {
    case top
    case center
    case bottom
}

private protocol AIToastDataSource: AnyObject {
    func configure(input: AIToast.Input)
}

extension UIView {
    func loadNib(xibName: String? = nil) -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = xibName ??  type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
}

public class AIToast: UIView {
    static var shared: AIToast?
    
    let xibName = AIToast.identifier
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet private var view_background: UIView!
    @IBOutlet private var stackview_main: UIStackView!
    @IBOutlet private var stackview_labels: UIStackView!
    @IBOutlet private var label_title_container: UIView!
    @IBOutlet private var label_title: AILabel!
    @IBOutlet private var label_subtitle_container: UIView!
    @IBOutlet private var label_subtitle: AILabel!
    @IBOutlet private var imageview_left_container: UIView!
    @IBOutlet private var imageview_left: UIImageView!
    private var input: AIToast.Input?
    private var constraint: Constraint?
    private var nsconstraint: NSLayoutConstraint?
    private var timer: Timer?
    private var isDisplayed: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupXib()
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setupXib()
        self.setup()
    }
    
    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        self.setupXib()
        self.setup()
        
        contentView?.prepareForInterfaceBuilder()
    }
    
    private func setupXib() {
        //        let bundle: Bundle = (animationInfo.from != nil) ? Bundle(for: type(of: from)) : Bundle.main
        //        Bundle.main.loadNibNamed(xibName, owner: self, options: nil)
        Bundle.module.loadNibNamed(xibName, owner: self, options: nil)
        //        Bundle(for: type(of: self)).loadNibNamed(xibName, owner: self, options: nil)
        //        let view = self.loadNib()
        
        self.addSubview(self.contentView)
        self.sendSubviewToBack(self.contentView)
        
        self.contentView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        self.bringSubviewToFront(self.contentView)
    }
    
    // 🌿 Setup
    
    private func setup() {
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.contentView.clipsToBounds = true
        self.contentView.isUserInteractionEnabled = true
        self.isUserInteractionEnabled = true
        
        self.contentView.layer.masksToBounds = false
        
        self.label_title.clear()
        self.label_subtitle.clear()
        self.view_background.makeRounded(cornerRadius: (46/2))
        self.view_background.addShadow(color: AIColor.blackWhite.color, opacity: 0.1, offset: .init(width: 0, height: 1), radius: 2)
        self.view_background.backgroundColor = AIColor.whiteBlack.color
        self.stackview_main.backgroundColor = .clear
        self.stackview_labels.backgroundColor = .clear
        self.stackview_labels.spacing = 4
        self.label_title_container.backgroundColor = .clear
        self.label_subtitle_container.backgroundColor = .clear
        self.imageview_left_container.backgroundColor = .clear
        
        self.label_title.textColor = AIColor.blackWhite.color
        self.label_title.font = .systemFont(ofSize: 12, weight: .semibold)
        self.label_subtitle.textColor = UIColor.systemGray
        self.label_subtitle.font = .systemFont(ofSize: 12, weight: .semibold)
        
        self.layoutIfNeeded()
    }
    
}

extension AIToast {
    
    public struct Input {
        let backgroundColor: AIColor?
        let title: String
        let subtitle: String
        let titleColor: AIColor?
        let subtitleColor: AIColor?
        let leftImage: UIImage?
        let position: AIToastPosition?
        
        public init(backgroundColor: AIColor? = nil,
                    title: String,
                    subtitle: String,
                    titleColor: AIColor? = nil,
                    subtitleColor: AIColor? = nil,
                    leftImage: UIImage? = nil,
                    position: AIToastPosition? = nil) {
            self.backgroundColor = backgroundColor
            self.title = title
            self.subtitle = subtitle
            self.titleColor = titleColor
            self.subtitleColor = subtitleColor
            self.leftImage = leftImage
            self.position = position
        }
    }
}

extension AIToast: AIToastDataSource {
    public func configure(input: AIToast.Input) {
        self.input = input
        
        if let backgroundColor = self.input?.backgroundColor {
            self.view_background.backgroundColor = backgroundColor.color
        }
        
        if let titleColor = self.input?.titleColor {
            self.label_title.textColor = titleColor.color
        }
        
        if let subtitleColor = self.input?.subtitleColor {
            self.label_subtitle.textColor = subtitleColor.color
        }
        
        if let left_image = self.input?.leftImage {
            self.imageview_left.image = left_image
            self.imageview_left_container.isHidden = true
            self.label_title.textAlignment = .left
            self.label_subtitle.textAlignment = .left
        } else {
            self.imageview_left_container.isHidden = true
            self.label_title.textAlignment = .center
            self.label_subtitle.textAlignment = .center
        }
        
        self.label_title.text = self.input?.title
        self.label_subtitle.text = self.input?.subtitle
    }
}

extension AIToast {
    public final class func show(title: String, subtitle: String, position: AIToastPosition? = nil, offset: CGFloat? = nil, backgroundColor: AIColor? = nil, titleColor: AIColor? = nil, subtitleColor: AIColor? = nil, leftImage: UIImage? = nil, duration: TimeInterval? = nil) {
        if let toast = AIToast.shared {
            toast.configure(input: .init(backgroundColor: backgroundColor, title: title, subtitle: subtitle, titleColor: titleColor, subtitleColor: subtitleColor, leftImage: leftImage, position: position))
            
            if let timer = toast.timer {
                timer.invalidate()
                toast.timer = nil
            }
            toast.timer = Timer.scheduledTimer(withTimeInterval: duration ?? 5.0, repeats: false) { _ in
                toast.dismiss()
                AIToast.shared = nil
                toast.timer?.invalidate()
                toast.timer = nil
            }
        } else {
            let toast = AIToast()
            toast.configure(input: .init(backgroundColor: backgroundColor, title: title, subtitle: subtitle, titleColor: titleColor, subtitleColor: subtitleColor, leftImage: leftImage, position: position))
            
            if let viewController = Utils.topMostWindowController() {
                let superview: UIView = viewController.view
                superview.addSubview(toast)
                
                let messageWidth = subtitle.width(withConstrainedHeight: 50, font: toast.label_title.font)
                toast.snp.makeConstraints { (make) in
                    switch position {
                    case .top:
                        make.centerX.equalTo(superview)
                        toast.constraint = make.topMargin.equalTo(superview).offset(toast.bounds.height + (offset ?? 40)).constraint
                        make.height.equalTo(46)
                        make.width.equalTo(181)
                    case .center:
                        make.centerY.equalTo(superview)
                        make.centerX.equalTo(superview)
                        make.height.equalTo(46)
                        make.width.equalTo(181)
                    case .bottom:
                        make.centerX.equalTo(superview)
                        make.bottomMargin.equalTo(superview).offset(toast.bounds.height)
                    case .none:
                        break
                    }
                }
                toast.show(animated: true, duration: 0.3)
                //            toast.layoutIfNeeded()
                
                toast.isDisplayed = true
                AIToast.shared = toast
                
                if let timer = toast.timer {
                    timer.invalidate()
                    toast.timer = nil
                }
                toast.timer = Timer.scheduledTimer(withTimeInterval: duration ?? 5.0, repeats: false) { _ in
                    print("Timer.scheduledTimer fired")
                    toast.dismiss()
                    AIToast.shared = nil
                    toast.timer?.invalidate()
                    toast.timer = nil
                }
                
                switch position {
                case .top:
                    //                let constraint = toast.getConstraint(.topMargin)
                    //                UIView.animate(withDuration: 5) {
                    //                    constraint?.constant = 200
                    //                    toast.layoutIfNeeded()
                    ////                    toast.snp.updateConstraints { make in
                    ////                        make.topMargin.equalTo(superview).offset(200)
                    ////                        toast.layoutIfNeeded()
                    ////                    }
                    //                }
                    //                    UIView.animate(withDuration: 5) {
                    ////                        toast.constraint.snp.updateConstraints { make in
                    ////                            make.topMargin.equalTo(superview).offset(toast.bounds.height + 60).constraint
                    ////                        }
                    //                        toast.constraint?.update(offset: 200)
                    //                        toast.layoutIfNeeded()
                    //                    }
                    break
                case .center:
                    break
                case .bottom:
                    break
                case .none:
                    break
                }
                
            }
        }
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.3, delay: .zero) {
            self.alpha = 0
        } completion: { completed in
            if completed {
                self.removeFromSuperview()
                self.isDisplayed = false
            }
        }
    }
    
    public final class func dismiss() {
        if let toast = AIToast.shared {
            toast.dismiss()
            AIToast.shared = nil
        }
    }
    
    //    guard let loafjetView = Utils.topMostWindowController()?.view else { return }
}
