//
//  AIUtils.swift
//  iomlearning
//
//  Created by Alexy Ibrahim on 6/17/22.
//

import Foundation
import UIKit
import AVKit
import Combine

public class Utils {
    static let shared = Utils()
    
    var avPlayer: AVAudioPlayer?
    public static var logs_updated = PassthroughSubject<Void, Never>()
    
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
    public final class func removeUserDefault(key:String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    //MARK: Key exists
    public final class func userDefaultKeyExists(key: String) -> Bool {
        if let _ = UserDefaults.standard.object(forKey: key) {
            return true
        } else {
            return false
        }
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
    
    public class func readDynamicConfigFromPropertyListForKey(_ key: String) -> Bool? {
        let value = (self.readFromPropertyList("Config", key: key) as? Bool)
        return value
    }
    
    public class func readDynamicConfigFromPropertyListForKey(_ key: String) -> String? {
        let value = (self.readFromPropertyList("Config", key: key) as? String)
        return value
    }
    
    public class func readDynamicConfigFromPropertyListForKey(_ key: String, subKey: String) -> String? {
        let value = (self.readFromPropertyList("Config", key: key) as! [String: Any])[subKey] as? String
        return value
    }
    
    public class func readDynamicConfigFromPropertyListForKey(_ key: String, subKey: String) -> Bool? {
        let value = (self.readFromPropertyList("Config", key: key) as! [String: Any])[subKey] as? Bool
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
    
    public final class func scheduleNotification(title: String, body: String? = nil, userInfo: [AnyHashable : Any]? = nil, delaySeconds:TimeInterval? = nil, successCallback: VoidClosure? = nil, errorCallback: ((_ error: Error) -> ())? = nil) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body ?? ""
        content.userInfo = userInfo ?? [AnyHashable : Any]()
        
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: delaySeconds ?? 0.1,
            repeats: false)
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print(error)
                errorCallback?(error)
            } else {
                successCallback?()
            }
        }
    }
    
    public final class func playSound(filename: String, ext: String, volume: Float? = nil) {
        //        if let bundle = Bundle.main.path(forResource: "91926__tim-kahn__ding", ofType: "mp3") {
        
        //        guard let url = Bundle.main.url(forResource: filename, withExtension: ext) else { return }
        guard let path = Bundle.main.path(forResource: filename, ofType: ext) else { return }
        
        do {
            self.shared.avPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path), fileTypeHint: AVFileType.mp3.rawValue)
            
            guard let player = self.shared.avPlayer else { return }
            player.numberOfLoops = 0
            if let volume = volume {
                player.volume = volume
            }
            DispatchQueue.main.async {
                player.prepareToPlay()
                player.play()
            }
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    public final class func writeTextToFile(_ txt: String, fileName: String? = nil, folderName: String? = nil) {
        let fileName = fileName ?? "logs.txt"
        let fileManager = FileManager.default
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory,
                                                        in: .userDomainMask).first else {
            return
        }
        var folderURL: URL?
        if let folderName = folderName {
            folderURL = documentsDirectory.appendingPathComponent(folderName)
            if !fileManager.fileExists(atPath: folderURL!.path) {
                do {
                    try fileManager.createDirectory(at: folderURL!, withIntermediateDirectories: false, attributes: nil)
                } catch {
                    print(error)
                    return
                }
            }
        }
        var fileURL: URL!
        if let folderURL = folderURL {
            fileURL = folderURL.appendingPathComponent(fileName)
        } else {
            fileURL = documentsDirectory.appendingPathComponent(fileName)
        }
        
        var txt = "\(txt)\n"
        if let fileHandle = try? FileHandle(forWritingTo: fileURL) {
            fileHandle.seekToEndOfFile() // Go to the end of the file
            if let data = txt.data(using: .utf8) {
                fileHandle.write(data) // Write the data to the end of the file
            }
            fileHandle.closeFile() // Close the file handle
        }
        else {
            do {
                try txt.write(to: fileURL, atomically: false, encoding: .utf8) // Write the string to the file as a new file
            }
            catch {
            }
        }
    }
    
    public final class func readTextFromFile(fileName: String? = nil,
                                             folderName: String? = nil) -> String? {
        let fileName = fileName ?? "logs.txt"
        let fileManager = FileManager.default
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory,
                                                        in: .userDomainMask).first else {
            return nil
        }
        var folderURL: URL?
        if let folderName = folderName {
            folderURL = documentsDirectory.appendingPathComponent(folderName)
            if !fileManager.fileExists(atPath: folderURL!.path) {
                do {
                    try fileManager.createDirectory(at: folderURL!, withIntermediateDirectories: false, attributes: nil)
                } catch {
                    print(error)
                    return nil
                }
            }
        }
        var fileURL: URL!
        if let folderURL = folderURL {
            fileURL = folderURL.appendingPathComponent(fileName)
        } else {
            fileURL = documentsDirectory.appendingPathComponent(fileName)
        }
        
        do {
            let readString = try String(contentsOf: fileURL, encoding: .utf8) // Read the string from the file
            
            return readString
        }
        catch {
            return nil
        }
    }
    
    public final class func clearFile(fileName: String? = nil,
                                      folderName: String? = nil) -> Bool? {
        let fileName = fileName ?? "logs.txt"
        let fileManager = FileManager.default
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory,
                                                        in: .userDomainMask).first else {
            return nil
        }
        var folderURL: URL?
        if let folderName = folderName {
            folderURL = documentsDirectory.appendingPathComponent(folderName)
            if !fileManager.fileExists(atPath: folderURL!.path) {
                do {
                    try fileManager.createDirectory(at: folderURL!, withIntermediateDirectories: false, attributes: nil)
                } catch {
                    print(error)
                    return nil
                }
            }
        }
        var fileURL: URL!
        if let folderURL = folderURL {
            fileURL = folderURL.appendingPathComponent(fileName)
        } else {
            fileURL = documentsDirectory.appendingPathComponent(fileName)
        }
        
        do {
            let fileHandle = try FileHandle(forWritingTo: fileURL) // Create a new file handle for writing to the file
            fileHandle.truncateFile(atOffset: 0) // Truncate the file at offset 0
            fileHandle.closeFile() // Close the file handle
            return true
        }
        catch {
            return false
        }
    }
    
    public final class func store(image: UIImage,
                                  fileName: String,
                                  folderName: String? = nil,
                                  callback: ((_ isSaved: Bool, _ path: String?, _ fileURL: URL?) -> ())? = nil) {
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
            callback?(false, nil, nil)
            return
        }
        store(data: data, fileName: fileName, folderName: folderName, callback: callback)
    }
    
    public final class func store(data: Data,
                                  fileName: String,
                                  folderName: String? = nil,
                                  callback: ((_ isSaved: Bool, _ path: String?, _ fileURL: URL?) -> ())? = nil) {
        let fileManager = FileManager.default
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory,
                                                        in: .userDomainMask).first else {
            callback?(false, nil, nil)
            return
        }
        var folderURL: URL?
        if let folderName = folderName {
            folderURL = documentsDirectory.appendingPathComponent(folderName)
            if !fileManager.fileExists(atPath: folderURL!.path) {
                do {
                    try fileManager.createDirectory(at: folderURL!, withIntermediateDirectories: false, attributes: nil)
                } catch {
                    print(error)
                    callback?(false, nil, nil)
                    return
                }
            }
        }
        
        var fileURL: URL!
        if let folderURL = folderURL {
            fileURL = folderURL.appendingPathComponent(fileName)
        } else {
            fileURL = documentsDirectory.appendingPathComponent(fileName)
        }
        
        do {
            try data.write(to: fileURL,
                           options: .atomic)
            
            var filePath = ""
            if let folderName = folderName {
                filePath = "\(folderName)/\(fileName)"
            } else {
                filePath = "\(fileName)"
            }
            callback?(true, filePath, fileURL)
            return
        } catch {
            print("Saving results in error: ", error)
            callback?(false, nil, nil)
            return
        }
    }
    
    public final class func retrieveImage(fileName: String,
                                          folderName: String? = nil) -> UIImage? {
        let fileManager = FileManager.default
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory,
                                                        in: .userDomainMask).first else {
            return nil
        }
        var folderURL: URL?
        if let folderName = folderName {
            folderURL = documentsDirectory.appendingPathComponent(folderName)
        }
        var fileURL: URL!
        if let folderURL = folderURL {
            fileURL = folderURL.appendingPathComponent(fileName)
        } else {
            fileURL = documentsDirectory.appendingPathComponent(fileName)
        }
        
        return Utils.retrieveImage(fileURL: fileURL)
    }
    
    public final class func retrieveImage(fileURL: URL) -> UIImage? {
        let fileManager = FileManager.default
        
        if fileManager.fileExists(atPath: fileURL.path),
           let fileData = FileManager.default.contents(atPath: fileURL.path),
           let image = UIImage(data: fileData) {
            return image
        }
        
        return nil
    }
    
    public struct LocalImageModel {
        public let image: UIImage!
        public let url: URL!
        
        public init(image: UIImage!, url: URL!) {
            self.image = image
            self.url = url
        }
    }
    
    public final class func getImages(in folderName: String) -> [LocalImageModel]? {
        let fileManager = FileManager.default
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory,
                                                        in: .userDomainMask).first else {
            return nil
        }
        let folderURL: URL = documentsDirectory.appendingPathComponent(folderName)
        if fileManager.fileExists(atPath: folderURL.path) {
            do {
                let fileUrls = try fileManager.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil)
                return fileUrls.compactMap { LocalImageModel.init(image: UIImage(contentsOfFile: $0.path), url: $0)  }
            } catch {
                print(error)
                return nil
            }
        }
        return nil
    }
    
    public final class func getImages(in folderName: String) -> [UIImage]? {
        let fileManager = FileManager.default
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory,
                                                        in: .userDomainMask).first else {
            return nil
        }
        let folderURL: URL = documentsDirectory.appendingPathComponent(folderName)
        if fileManager.fileExists(atPath: folderURL.path) {
            do {
                let fileUrls = try fileManager.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil)
                return fileUrls.compactMap { UIImage(contentsOfFile: $0.path) }
            } catch {
                print(error)
                return nil
            }
        }
        return nil
    }
    
    public final class func deleteImage(fileName: String,
                                        folderName: String? = nil) -> Bool {
        let fileManager = FileManager.default
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory,
                                                        in: .userDomainMask).first else {
            return false
        }
        var folderURL: URL?
        if let folderName = folderName {
            folderURL = documentsDirectory.appendingPathComponent(folderName)
        }
        var fileURL: URL!
        if let folderURL = folderURL {
            fileURL = folderURL.appendingPathComponent(fileName)
        } else {
            fileURL = documentsDirectory.appendingPathComponent(fileName)
        }
        
        return Utils.deleteFile(fileURL: fileURL)
    }
    
    public final class func deleteFile(fileURL: URL) -> Bool {
        let fileManager = FileManager.default
        
        if fileManager.fileExists(atPath: fileURL.path) {
            do {
                try fileManager.removeItem(at: fileURL)
                return true
            } catch {
                print(error)
                return false
            }
        }
        
        return false
    }
    
    public final class func filePath(path: String) -> URL? {
        let fileManager = FileManager.default
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory,
                                                        in: .userDomainMask).first else {
            return nil
        }
        
        let fileURL: URL! = documentsDirectory.appendingPathComponent(path)
        return fileURL
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
    
    public final class func arraysAreSimilar(firstArray: [Any], secondArray: [Any]) -> Bool {
        if firstArray.count != secondArray.count {
            return false
        }
        for i in 0..<firstArray.count {
            let valueInFirst = firstArray[i]
            if !secondArray.contains(where: { value in
                ((value as! String) == (valueInFirst as! String))
            }) {
                return false
            }
        }
        return true
    }
    
    public final class func displayDebuggingMessage(name: String, body: String? = nil) {
        if Session.debuggingEnabled {
            Utils.scheduleNotification(title: name, body: body, userInfo: nil, delaySeconds: nil, successCallback: nil, errorCallback: nil)
        }
    }
    
    public final class func displayErrorDebuggingMessage(name: String? = nil, body: String? = nil) {
        if Session.errorDebuggingEnabled {
            Utils.scheduleNotification(title: (name != nil) ? "error: \(name!)": "error", body: body, userInfo: nil, delaySeconds: nil, successCallback: nil, errorCallback: nil)
        }
    }
    
    public final class func share(text: String) {
        let activityViewController = UIActivityViewController(activityItems: [text], applicationActivities: nil)

        if let vc = Utils.topMostWindowController() {
            if let popoverController = activityViewController.popoverPresentationController {
                popoverController.sourceView = vc.view
            }
            
            vc.present(activityViewController, animated: true, completion: nil)
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
