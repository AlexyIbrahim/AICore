//
//  AIPermission.swift
//  Instant
//
//  Created by Alexy Ibrahim on 12/17/22.
//

import Foundation
import AVFoundation
import UIKit
import UserNotifications
import CoreLocation

public class AIPermission: NSObject {
    static let shared = AIPermission()
    
    private static let locationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = AIPermission.shared
        return locationManager
    }()
    private static var locationManagerPermissionCallback: (GenericClosure<CLAuthorizationStatus?>)? = nil
    private static var locationManagerLocationCallback: (GenericClosure<CLLocation?>)? = nil
    
    
    static var microphoneRecordPermissionStatus: AVAudioSession.RecordPermission? {
        return AVAudioSession.sharedInstance().recordPermission
    }
    public class func requestMicrophoneRecordPermission(callback: @escaping GenericClosure<AVAudioSession.RecordPermission>) {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .granted:
            print("Permission granted")
            callback(.granted)
        case .denied:
            print("Permission denied")
            callback(.denied)
        case .undetermined:
            print("Request permission here")
            AVAudioSession.sharedInstance().requestRecordPermission({ granted in
                // Handle granted
                if granted {
                    callback(.granted)
                } else {
                    callback(.denied)
                }
            })
        @unknown default:
            print("Unknown case")
        }
    }
    
    public class func requestNotificationPermission(application: UIApplication, completion: @escaping  (Bool) -> Void) {
        if #available(iOS 10.0, *) {
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { granted, error in
                    completion(granted)
                }
            )
        } else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
    }
    
    public static var locationPermissionStatus: CLAuthorizationStatus? {
        if CLLocationManager.locationServicesEnabled() {
            return locationManager.authorizationStatus
        } else {
            print("Location services are not enabled")
            return nil
        }
    }
    
    public class func requestLocationPermission(callback: @escaping GenericClosure<CLAuthorizationStatus?>) {
        AIPermission.locationManagerPermissionCallback = callback
        
        if CLLocationManager.locationServicesEnabled() {
            switch locationManager.authorizationStatus {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
                print("No access")
            case .restricted:
                callback(.restricted)
                print("No access")
            case .denied:
                callback(.denied)
                print("No access")
            case .authorizedAlways:
                callback(.authorizedAlways)
                print("Access")
            case .authorizedWhenInUse:
                callback(.authorizedWhenInUse)
                print("Access")
            @unknown default:
                callback(nil)
                print("default")
            }
        } else {
            callback(nil)
            print("Location services are not enabled")
        }
    }
    
    public class func getLiveUserLocation(callback: @escaping GenericClosure<CLLocation?>) {
        AIPermission.locationManagerLocationCallback = callback
        locationManager.startUpdatingLocation()
    }
    
    public class func getUserLocation(callback: @escaping GenericClosure<CLLocation?>) {
        AIPermission.locationManagerLocationCallback = callback
        locationManager.requestLocation()
    }
    
    public class func stopUpdatingLocation() {
        AIPermission.locationManager.stopUpdatingLocation()
    }
}

extension AIPermission: CLLocationManagerDelegate {
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        AIPermission.locationManagerPermissionCallback?(manager.authorizationStatus)
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        AIPermission.locationManagerLocationCallback?(locations.last)
    }
    
    public func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        // Handle failure to get a user’s location
        AIPermission.locationManagerLocationCallback?(nil)
    }
}
