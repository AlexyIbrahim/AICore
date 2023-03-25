//
//  AIStatusIndicator.swift
//  Story Crafter
//
//  Created by Alexy Ibrahim on 6/12/20.
//  Copyright © 2020 Alexy Ibrahim. All rights reserved.
//

import UIKit

//class AIStatusIndicator: UIView {
//    let xibName = "AIStatusIndicator"
//    @IBOutlet private var contentView: UIView!
//
//    static var operationQueue: OperationQueue = {
//        var queue = OperationQueue()
//        queue.name = "AIStatusIndicator queue"
//        queue.maxConcurrentOperationCount = 1
//        queue.waitUntilAllOperationsAreFinished()
//        return queue
//    }()
//
//    static let semaphore = DispatchSemaphore(value: 0)
//
//    @IBOutlet private var imageView_Main:UIImageView!
//    @IBOutlet private var label_Title:UILabel!
//
//    private var string_Title:String! = ""
//    private var timer_Chew:Timer!
//    private var timer_Throwup:Timer!
//    private var timer_Dismiss:Timer!
//    private var status:StatusEnum! = .normal
//
//
//    init(frame:CGRect, title: String? = nil, status: StatusEnum? = nil){
//        super.init(frame: frame)
//
//        if let title = title {
//            self.string_Title = title
//        }
//
//        if let status = status {
//            self.status = status
//        }
//
//        self.setupXib()
//        self.setup()
//    }
//    
//    override init(frame:CGRect){
//        super.init(frame: frame)
//
//        self.setupXib()
//        self.setup()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//
//        self.setupXib()
//        self.setup()
//    }
//
//    override func prepareForInterfaceBuilder() {
//        super.prepareForInterfaceBuilder()
//
//        //        let label:UILabel = UILabel(frame: self.contentView.bounds)
//        //        label.textAlignment = .center
//        //        label.backgroundColor = UIColor.clear;
//        //        label.textColor = UIColor.black
//        //        label.font = UIFont.boldSystemFont(ofSize: 25)
//        //        label.text = "CallButton"
//        //        self.contentView.addSubview(label)
//
//        self.setupXib()
//        self.setup()
//
//        contentView?.prepareForInterfaceBuilder()
//    }
//
//    private func setupXib() {
//        Bundle.main.loadNibNamed(xibName, owner: self, options: nil)
//
//        self.addSubview(self.contentView)
//        self.sendSubviewToBack(self.contentView)
//
//        self.contentView.snp.makeConstraints { (make) in
//            make.edges.equalTo(0)
//            make.centerX.equalToSuperview()
//            make.centerY.equalToSuperview()
//        }
//    }
//
//    // 🌿 Setup
//    private func setup() {
//        self.backgroundColor = .white
//        self.contentView.backgroundColor = .white
//        self.contentView.clipsToBounds = true
//        self.contentView.isUserInteractionEnabled = true
//        self.isUserInteractionEnabled = true
//
//        self.layoutIfNeeded()
//        self.makeRounded(cornerRadius: 8, borderWith: 0.5, borderColor: .black)
//
//        self.imageView_Main.backgroundColor = self.status.color
//        self.imageView_Main.layer.cornerRadius = (self.imageView_Main.bounds.width/2)
//        AIStatusIndicator.fadeOutIn(view: self.imageView_Main)
//
//        self.label_Title.text = ""
//        self.label_Title.font = UIFont.systemFont(ofSize: UIFont.systemFontSize - 4)
//        self.label_Title.backgroundColor = .white
//    }
//}
//
//// private
//extension AIStatusIndicator {
//    enum StatusEnum {
//        case normal
//        case success
//        case error
//
//        var color: UIColor {
//            switch self {
//            case .normal: return UIColor.systemBlue
//            case .success: return UIColor.systemGreen
//            case .error: return UIColor.systemRed
//            }
//        }
//    }
//
//    enum PositionEnum {
//        case topRight
//        case topCenter
//        case topLeft
//        case midLeft
//        case bottomLeft
//        case bottomCenter
//        case bottomRight
//        case midRight
//        case center
//
//        var rect: CGRect {
//            switch self {
//            case .topRight: return CGRect(x: -20, y: 20, width: 100, height: 25)
//            case .topCenter: return CGRect(x: 0, y: 20, width: 100, height: 25)
//            case .topLeft: return CGRect(x: 20, y: 20, width: 100, height: 25)
//            case .midLeft: return CGRect(x: 20, y: 0, width: 100, height: 25)
//            case .bottomLeft: return CGRect(x: 20, y: -20, width: 100, height: 25)
//            case .bottomCenter: return CGRect(x: 0, y: -20, width: 100, height: 25)
//            case .bottomRight: return CGRect(x: -20, y: -20, width: 100, height: 25)
//            case .midRight: return CGRect(x: -20, y: 0, width: 100, height: 25)
//            case .center: return CGRect(x: 0, y: 0, width: 100, height: 25)
//            }
//        }
//    }
//
//    private final class func fadeOutIn(view: UIView) {
//        UIView.animate(withDuration: 1, delay: 0, options: [.autoreverse, .repeat], animations: {
//            view.alpha = 0
//        }) { (finished) in
//
//        }
//    }
//
//    private func adjustViewWidth() {
//        print("self.string_Title: \(String(describing: self.string_Title))")
//
//        let imageWidth = AIStatusIndicatorUtils.disassembleFrame(self.imageView_Main.frame).width
//        let textWidth:CGFloat = self.string_Title.width(withConstrainedHeight: AIStatusIndicatorUtils.disassembleFrame(self.label_Title.frame).height, font: self.label_Title.font)
//        var totalWidth: CGFloat = 50
//        totalWidth += 8
//        totalWidth += 2
//        totalWidth += 8
//        print("textHeight: \(String(describing: AIStatusIndicatorUtils.disassembleFrame(self.label_Title.frame).height))")
//        print("imageWidth: \(String(describing: imageWidth))")
//        print("textWidth: \(String(describing: textWidth))")
//        print("totalWidth: \(String(describing: totalWidth))")
//
//        self.snp.makeConstraints { (make) in
//            make.width.equalTo(totalWidth)
//            self.layoutIfNeeded()
//        }
//        UIView.animate(withDuration: 0.2) {
//            var updateFrame = self.frame
//            updateFrame.size.width = totalWidth
//            self.frame = updateFrame
//            self.layoutIfNeeded()
//        }
//    }
//
//    // dismiss
//    private func startPackman() {
//        var string: String! = self.string_Title
//        self.timer_Chew = Timer.every(0.01, {
//            if string.count > 0 {
//                string = String(string.dropLast())
//                self.label_Title.text = string
//            } else {
//                self.timer_Chew.invalidate()
//                UIView.animate(withDuration: 0.2, animations: {
//                    self.alpha = 0
//                }) { (finished) in
//                    if finished {
//                        self.safelyRemoveFromSuperview()
//                        AIStatusIndicator.semaphore.signal()
//                    }
//                }
//            }
//        })
//    }
//
//    // display
//    private func startReversePackman(completedCallback: (() -> ())? = nil) {
//        let completeString:String! = self.string_Title
//        var string: String! = ""
//        var index: Int = 0
//        self.timer_Throwup = Timer.every(0.01, {
//            if string.count < self.string_Title.count {
//                string += String(completeString[index])
//                self.label_Title.text = string
//                index += 1
//            } else {
//                self.timer_Throwup.invalidate()
//                completedCallback?()
//            }
//        })
//    }
//
//    private func clearUpEverything() {
//        self.timer_Dismiss.invalidate()
//        self.timer_Chew.invalidate()
//        self.timer_Throwup.invalidate()
//    }
//}
//
//// public
//extension AIStatusIndicator {
//    public final class func show(title: String, status: StatusEnum? = nil, position: PositionEnum? = nil, dismissDelay: Double? = nil) {
//        AIStatusIndicator.operationQueue.addOperation {
//            DispatchQueue.main.async {
//
//                let position: PositionEnum = position ?? .topRight
//                let frame: CGRect = position.rect
//
//                let statusIndicator = AIStatusIndicator.init(frame: frame, title: title, status: status)
//                statusIndicator.alpha = 0.1
//                //        statusIndicator.adjustViewWidth()
//                switch position {
//                case .topRight, .bottomRight, .midRight:
//                    statusIndicator.contentView.semanticContentAttribute = .forceLeftToRight
//                case .topCenter, .bottomCenter, .center:
//                    statusIndicator.contentView.semanticContentAttribute = .forceRightToLeft
//                case .topLeft, .midLeft, .bottomLeft:
//                    statusIndicator.contentView.semanticContentAttribute = .forceRightToLeft
//                }
//
//                let viewController = AIStatusIndicatorUtils.topMostWindowController()
//                if let viewController = viewController {
//                    let superview: UIView = viewController.view
//                    superview.addSubview(statusIndicator)
//
//                    statusIndicator.snp.makeConstraints { (make) in
//                        switch position {
//                        case .topRight:
//                            make.topMargin.equalTo(superview).offset(frame.origin.y)
//                            make.right.equalTo(superview).offset(frame.origin.x)
//                            make.height.equalTo(frame.size.height)
//                        case .topCenter:
//                            make.centerX.equalTo(superview)
//                            make.topMargin.equalTo(superview).offset(frame.origin.y)
//                            make.height.equalTo(frame.size.height)
//                        case .topLeft:
//                            make.topMargin.equalTo(superview).offset(frame.origin.y)
//                            make.left.equalTo(superview).offset(frame.origin.x)
//                            make.height.equalTo(frame.size.height)
//                        case .midLeft:
//                            make.centerY.equalTo(superview)
//                            make.left.equalTo(superview).offset(frame.origin.x)
//                            make.height.equalTo(frame.size.height)
//                        case .bottomLeft:
//                            make.bottomMargin.equalTo(superview).offset(frame.origin.y)
//                            make.left.equalTo(superview).offset(frame.origin.x)
//                            make.height.equalTo(frame.size.height)
//                        case .bottomCenter:
//                            make.centerX.equalTo(superview)
//                            make.bottomMargin.equalTo(superview).offset(frame.origin.y)
//                            make.height.equalTo(frame.size.height)
//                        case .bottomRight:
//                            make.bottomMargin.equalTo(superview).offset(frame.origin.y)
//                            make.right.equalTo(superview).offset(frame.origin.x)
//                            make.height.equalTo(frame.size.height)
//                        case .midRight:
//                            make.centerY.equalTo(superview)
//                            make.right.equalTo(superview).offset(frame.origin.x)
//                            make.height.equalTo(frame.size.height)
//                        case .center:
//                            make.centerY.equalTo(superview)
//                            make.centerX.equalTo(superview)
//                            make.height.equalTo(frame.size.height)
//                        }
//                    }
//
//                    UIView.animate(withDuration: 0.2, animations: {
//                        statusIndicator.alpha = 1
//                    }) { (finished) in
//                        if finished {
//                            statusIndicator.startReversePackman {
//                                // data is displayed
//                                // start countdown
//                                let textDelay: Double = (Double(title.count) * 0.1) + 0.5
//                                statusIndicator.timer_Dismiss = Timer.after(dismissDelay ?? textDelay) {
//                                    statusIndicator.startPackman()
//                                }
//
//                                statusIndicator.onTap { (gestureRecognizer) in
//                                    statusIndicator.timer_Dismiss.invalidate()
//                                    statusIndicator.startPackman()
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//            AIStatusIndicator.semaphore.wait()
//        }
//    }
//}
