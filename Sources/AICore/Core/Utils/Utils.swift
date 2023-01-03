//
//  AIUtils.swift
//  iomlearning
//
//  Created by Alexy Ibrahim on 6/17/22.
//

import Foundation
import UIKit
import AVKit

public class Utils {
    static let shared = Utils()
    
    var avPlayer: AVAudioPlayer?
    
    private static func nibFileExists(_ nibName: String) -> Bool {
        Bundle(for: self).path(forResource: nibName, ofType: "nib") != nil
    }
    
    public final class func loadNibFile(nibName: String, from: AnyObject? = nil) -> UINib {
        let nib:UINib = UINib.init(nibName: nibName, bundle: (from != nil) ? Bundle(for: type(of: from!)) : nil)
        return nib
    }
    
    /** Loads instance from nib with the same name. */
    public final class func loadNibView(fromNibName nibName: String, withViewAccId accId: String, from: AnyObject? = nil) -> UIView {
        let nib = loadNibFile(nibName: nibName, from: from)
        //        Bundle(for: type(of: self)).loadNibNamed(xibName, owner: self, options: nil)
        let foundItems = nib.instantiate(withOwner: from, options: nil).filter { ($0 as! UIView).accessibilityIdentifier == accId }
        return (foundItems.first as! UIView)
    }
    
    /**Loads first instance from nib with the same name. */
    public static func loadFirstViewFromNibFile(_ nibName: String, from: AnyObject? = nil) -> UIView? {
        let nib = loadNibFile(nibName: nibName, from: from)
        let topLevelObjs = nib.instantiate(withOwner: from, options: nil)
        return topLevelObjs.first as? UIView
    }
    
    // MARK: Set user default
    public final class func saveUserDefault(inKey key:String, withValue value:Any) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    // MARK: Fetch user default
    public final class func fetchUserDefault(key:String) -> Any? {
        return UserDefaults.standard.object(forKey: key)
    }
    
    public final class func fetchUserDefault(key:String) -> String? {
        return UserDefaults.standard.string(forKey: key)
    }
    
    public final class func fetchUserDefault(key:String) -> Int? {
        return UserDefaults.standard.integer(forKey: key)
    }
    
    public final class func fetchUserDefault(key:String) -> Bool? {
        return UserDefaults.standard.bool(forKey: key)
    }
    
    //MARK: Remove user default
    public final class func removeUserDefaul(key:String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    public final class func topMostWindowController() -> UIViewController? {
        
        var topController = UIApplication.shared.keyWindow?.rootViewController
        
        while let presentedController = topController?.presentedViewController {
            topController = presentedController
        }
        
        return topController
    }
    
    public final class func currentViewController()->UIViewController? {
        
        var currentViewController = topMostWindowController()
        
        //        if let tabController = currentViewController as? UITabBarController {
        //            if let selected = tabController.selectedViewController {
        //                currentViewController = topViewController(controller: selected)
        //            }
        //        }
        //        if let presented = currentViewController?.presentedViewController {
        //            currentViewController = topViewController(controller: presented)
        //        }
        
        while currentViewController != nil && currentViewController is UINavigationController && (currentViewController as! UINavigationController).topViewController != nil {
            currentViewController = (currentViewController as! UINavigationController).topViewController
        }
        
        return currentViewController
    }
    
    // MARK: -
    // MARK: ReadFromPropertyList
    public class func readFromPropertyList(_ name: String, key: String) -> Any? {
        var nsDictionary: NSDictionary?
        if let path = Bundle.main.path(forResource: name, ofType: "plist") {
            nsDictionary = NSDictionary(contentsOfFile: path)
            return nsDictionary![key]
        }
        return ""
    }
    
    public class func readDynamicConfigFromPropertyListForKey(_ key: String) -> Bool {
        let value = (self.readFromPropertyList("Config", key: key) as! Bool)
        return value
    }
    
    public class func readDynamicConfigFromPropertyListForKey(_ key: String) -> String {
        let value = (self.readFromPropertyList("Config", key: key) as! String)
        return value
    }
    
    public class func readDynamicConfigFromPropertyListForKey(_ key: String, subKey: String) -> String {
        let value = (self.readFromPropertyList("Config", key: key) as! [String: Any])[subKey] as! String
        return value
    }
    
    public final class func appVersion() -> String {
        let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String ?? ""
        return appVersion
    }
    
    public final class func build() -> String {
        let build = Bundle.main.infoDictionary!["CFBundleVersion"] as? String ?? ""
        return build
    }
    
    public final class func versionBuild() -> String {
        return String(format: "Version %@ (%@)", Utils.appVersion(), Utils.build())
    }
    
    public final class func scheduleNotification(task: ReminderTask) {
        // 2
        let content = UNMutableNotificationContent()
        content.title = task.name
        content.body = task.body ?? ""
        
        // 3
        var trigger: UNNotificationTrigger?
        switch task.reminder.reminderType {
        case .time:
            if let timeInterval = task.reminder.timeInterval {
                trigger = UNTimeIntervalNotificationTrigger(
                    timeInterval: timeInterval,
                    repeats: task.reminder.repeats)
            }
        default:
            return
        }
        
        // 4
        if let trigger = trigger {
            let request = UNNotificationRequest(
                identifier: task.id,
                content: content,
                trigger: trigger)
            // 5
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print(error)
                }
            }
        }
    }
    
    public final class func scheduleLocalNotification(title:String?, body:String?, delaySeconds:TimeInterval?) {
        
        let content = UNMutableNotificationContent()
        
        content.title = title ?? ""
        content.body = body ?? ""
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval:delaySeconds ?? 0 , repeats: false)
        let request = UNNotificationRequest(identifier: "notification.id.01", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    public final class func playSound() {
        
//        if let bundle = Bundle.main.path(forResource: "91926__tim-kahn__ding", ofType: "mp3") {
//          let backgroundMusic = NSURL(fileURLWithPath: bundle)
//            do {
//                self.shared.avPlayer = try AVAudioPlayer(contentsOf: backgroundMusic as URL)
//                guard let audioPlayer = self.shared.avPlayer else {return}
//                audioPlayer.numberOfLoops = 0
//                audioPlayer.prepareToPlay()
//                audioPlayer.play()
//            } catch {
//                print(error)
//            }}
//
//        do{
//            if #available(iOS 10.0, *) {
//                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers])
//            } else {
//                // Fallback on earlier versions
//            }
//            print("Playback ok")
//            try AVAudioSession.sharedInstance().setActive(true)
//            print("session is active")
//
//            guard let player = self.shared.avPlayer else{
//                return
//            }
//
//            player.play()
//        }
//        catch {
//            print ("oops")
//        }
        
        guard let url = Bundle.main.url(forResource: "91926__tim-kahn__ding", withExtension: "mp3") else { return }

        do {
//            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
//            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            self.shared.avPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            /* iOS 10 and earlier require the following line:
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

            guard let player = self.shared.avPlayer else { return }
            player.numberOfLoops = 0
            DispatchQueue.main.async {
                player.prepareToPlay()
                player.play()
            }

        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    public func saveImage(image: UIImage, name: String) -> Bool {
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
            return false
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return false
        }
        do {
            try data.write(to: directory.appendingPathComponent("\(name).png")!)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    public func getSavedImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }
    
    public enum StorageType {
        case userDefaults
        case fileSystem
    }
    
    public func store(image: UIImage,
                       forKey key: String,
                       withStorageType storageType: StorageType) {
        if let pngRepresentation = image.pngData() {
            switch storageType {
            case .fileSystem:
                if let filePath = filePath(forKey: key) {
                    do {
                        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
                            return
                        }
                        try data.write(to: filePath,
                                       options: .atomic)
                    } catch let err {
                        print("Saving results in error: ", err)
                    }
                }
            case .userDefaults:
                UserDefaults.standard.set(pngRepresentation,
                                          forKey: key)
            }
        }
    }
    
    public func retrieveImage(forKey key: String,
                               inStorageType storageType: StorageType) -> UIImage? {
        switch storageType {
        case .fileSystem:
            if let filePath = self.filePath(forKey: key),
               let fileData = FileManager.default.contents(atPath: filePath.path),
               let image = UIImage(data: fileData) {
                return image
            }
        case .userDefaults:
            if let imageData = UserDefaults.standard.object(forKey: key) as? Data,
               let image = UIImage(data: imageData) {
                return image
            }
        }
        
        return nil
    }
    
    public func filePath(forKey key: String) -> URL? {
        let fileManager = FileManager.default
        guard let documentURL = fileManager.urls(for: .documentDirectory,
                                                 in: .userDomainMask).first else {
            return nil
        }
        
        return documentURL.appendingPathComponent(key + ".png")
    }
    
    public func directoryContents() {
        do {
            // Get the document directory url
            let documentDirectory = try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
            print("documentDirectory", documentDirectory.path)
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try FileManager.default.contentsOfDirectory(
                at: documentDirectory,
                includingPropertiesForKeys: nil
            )
            print("directoryContents:", directoryContents.map { $0.localizedName ?? $0.lastPathComponent })
            for url in directoryContents {
                print(url.localizedName ?? url.lastPathComponent)
            }
            
            // if you would like to hide the file extension
            for var url in directoryContents {
                url.hasHiddenExtension = true
            }
            for url in directoryContents {
                print(url.localizedName ?? url.lastPathComponent)
            }
            
            // if you want to get all mp3 files located at the documents directory:
            let mp3s = directoryContents.filter(\.isMP3).map { $0.localizedName ?? $0.lastPathComponent }
            print("mp3s:", mp3s)
            
        } catch {
            print(error)
        }
    }
    
    public final class func addTextToImage(drawText text: String, inImage image: UIImage, atPoint point: CGPoint) -> UIImage {
        let textColor = UIColor.white
        let textFont = UIFont.systemFont(ofSize: 14)
        
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(image.size, false, scale)
        
        let textFontAttributes = [
            NSAttributedString.Key.font: textFont,
            NSAttributedString.Key.foregroundColor: textColor,
        ] as [NSAttributedString.Key : Any]
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        
        let rect = CGRect(origin: point, size: image.size)
        text.draw(in: rect, withAttributes: textFontAttributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    public final class func currentDate() -> String {
        let date = Date.now
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM yyyy hh:mm:ss a"
        
        let dateStr = dateFormatter.string(from: date)
        return dateStr
    }
    
    public final class func openLocationInGoogleMaps(lat: Double, long: Double) {
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            
            if let url = URL(string: "comgooglemaps-x-callback://?saddr=&daddr=\(lat),\(long)&directionsmode=driving") {
                UIApplication.shared.open(url, options: [:])
            }}
        else {
            if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(lat),\(long)&directionsmode=driving") {
                UIApplication.shared.open(urlDestination)
            }
        }
    }
}

extension URL {
    var typeIdentifier: String? { (try? resourceValues(forKeys: [.typeIdentifierKey]))?.typeIdentifier }
    var isMP3: Bool { typeIdentifier == "public.mp3" }
    var localizedName: String? { (try? resourceValues(forKeys: [.localizedNameKey]))?.localizedName }
    var hasHiddenExtension: Bool {
        get { (try? resourceValues(forKeys: [.hasHiddenExtensionKey]))?.hasHiddenExtension == true }
        set {
            var resourceValues = URLResourceValues()
            resourceValues.hasHiddenExtension = newValue
            try? setResourceValues(resourceValues)
        }
    }
}
