//
//  AIPermission.swift
//  Instant
//
//  Created by Alexy Ibrahim on 12/17/22.
//

import AVFoundation
import Contacts
import CoreLocation
import Foundation
import UIKit
import UserNotifications

public class AIPermission: NSObject {
    static let shared = AIPermission()

    private static let locationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = AIPermission.shared
        return locationManager
    }()

    private static var locationManagerPermissionCallback: GenericClosure<CLAuthorizationStatus?>? = nil
    private static var locationManagerLocationCallback: GenericClosure<CLLocation?>? = nil

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
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                // Handle granted
                if granted {
                    callback(.granted)
                } else {
                    callback(.denied)
                }
            }
        @unknown default:
            print("Unknown case")
        }
    }

    public class func requestNotificationPermission(application: UIApplication, completion: @escaping (Bool) -> Void) {
        if #available(iOS 10.0, *) {
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { granted, _ in
                completion(granted)
            })
        } else {
            let settings: UIUserNotificationSettings = .init(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
    }

    @available(iOS 14.0, *)
    public static var locationPermissionStatus: CLAuthorizationStatus? {
        if CLLocationManager.locationServicesEnabled() {
            return locationManager.authorizationStatus
        } else {
            print("Location services are not enabled")
            return nil
        }
    }

    @available(iOS 14.0, *)
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
    @available(iOS 14.0, *)
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        AIPermission.locationManagerPermissionCallback?(manager.authorizationStatus)
    }

    public func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        AIPermission.locationManagerLocationCallback?(locations.last)
    }

    public func locationManager(
        _: CLLocationManager,
        didFailWithError _: Error
    ) {
        // Handle failure to get a user’s location
        AIPermission.locationManagerLocationCallback?(nil)
    }
}

public extension AIPermission {
    class func requestContactsPermission(callback: @escaping GenericClosure<Bool>) {
        let contactStore = CNContactStore()

        // Request permission to access contacts
        contactStore.requestAccess(for: .contacts) { granted, _ in
            if granted {
                // Access granted, perform the contacts operation here
                callback(granted)
            } else {
                // Access denied
                callback(granted)
                print("Access to contacts denied")
            }
        }
    }
}
