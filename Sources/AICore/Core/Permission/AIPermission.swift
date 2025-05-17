import AVFoundation
import Contacts
import CoreLocation
import Foundation
import Photos
import UIKit
import UserNotifications

// Assuming GenericClosure is defined as:
// public typealias GenericClosure<T> = (T) -> Void

public enum PermissionType {
	case camera
	case microphone
	case contacts
	case location
	case notifications
	case photoLibrary
	// Add more permission types as needed
}

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
	
	// MARK: - Microphone Permissions
	
	public class func requestMicrophoneRecordPermission(callback: @escaping GenericClosure<AVAudioSession.RecordPermission>) {
		switch AVAudioSession.sharedInstance().recordPermission {
		case .granted:
			print("Microphone permission granted.")
			callback(.granted)
		case .denied:
			print("Microphone permission denied.")
			callback(.denied)
		case .undetermined:
			print("Requesting microphone permission.")
			AVAudioSession.sharedInstance().requestRecordPermission { granted in
				// Handle granted
				if granted {
					callback(.granted)
				} else {
					callback(.denied)
				}
			}
		@unknown default:
			print("Unknown microphone permission status.")
		}
	}
	
	// MARK: - Notification Permissions
	
	public class func requestNotificationPermission(application: UIApplication, completion: @escaping (Bool) -> Void) {
		if #available(iOS 10.0, *) {
			let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
			UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, _ in
				completion(granted)
			}
		} else {
			let settings: UIUserNotificationSettings = .init(types: [.alert, .badge, .sound], categories: nil)
			application.registerUserNotificationSettings(settings)
		}
		
		application.registerForRemoteNotifications()
	}
	
	// MARK: - Location Permissions
	
	@available(iOS 14.0, *)
	public static var locationPermissionStatus: CLAuthorizationStatus? {
		if CLLocationManager.locationServicesEnabled() {
			return locationManager.authorizationStatus
		} else {
			print("Location services are not enabled.")
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
				print("Requesting location permission.")
			case .restricted:
				callback(.restricted)
				print("Location permission restricted.")
			case .denied:
				callback(.denied)
				print("Location permission denied.")
			case .authorizedAlways:
				callback(.authorizedAlways)
				print("Location permission authorized always.")
			case .authorizedWhenInUse:
				callback(.authorizedWhenInUse)
				print("Location permission authorized when in use.")
			@unknown default:
				callback(nil)
				print("Unknown location permission status.")
			}
		} else {
			callback(nil)
			print("Location services are not enabled.")
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
	
	// MARK: - Contacts Permissions
	
	public class func requestContactsPermission(callback: @escaping GenericClosure<Bool>) {
		let contactStore = CNContactStore()
		
		// Request permission to access contacts
		contactStore.requestAccess(for: .contacts) { granted, _ in
			if granted {
				// Access granted, perform the contacts operation here
				callback(granted)
			} else {
				// Access denied
				callback(granted)
				print("Access to contacts denied.")
			}
		}
	}
	
	// MARK: - Camera Permissions
	
	public class func requestCameraPermission(callback: @escaping GenericClosure<AVAuthorizationStatus>) {
		let status = AVCaptureDevice.authorizationStatus(for: .video)
		
		switch status {
		case .authorized:
			print("Camera access already authorized.")
			callback(.authorized)
		case .notDetermined:
			print("Requesting camera access.")
			AVCaptureDevice.requestAccess(for: .video) { granted in
				let newStatus: AVAuthorizationStatus = granted ? .authorized : .denied
				callback(newStatus)
			}
		case .denied:
			print("Camera access previously denied.")
			callback(.denied)
		case .restricted:
			print("Camera access restricted.")
			callback(.restricted)
		@unknown default:
			print("Unknown camera authorization status.")
			callback(.notDetermined)
		}
	}
	
	public class func getCameraPermissionStatus() -> AVAuthorizationStatus {
		return AVCaptureDevice.authorizationStatus(for: .video)
	}
	
	// MARK: - Photo Library Permissions
	
	public class func requestPhotoLibraryPermission(callback: @escaping GenericClosure<PHAuthorizationStatus>) {
		let status = PHPhotoLibrary.authorizationStatus()
		
		switch status {
		case .authorized, .limited:
			print("Photo library access already authorized.")
			callback(status)
		case .notDetermined:
			print("Requesting photo library access.")
			PHPhotoLibrary.requestAuthorization { newStatus in
				callback(newStatus)
			}
		case .denied:
			print("Photo library access previously denied.")
			callback(.denied)
		case .restricted:
			print("Photo library access restricted.")
			callback(.restricted)
		@unknown default:
			print("Unknown photo library authorization status.")
			callback(.notDetermined)
		}
	}
	
	public class func getPhotoLibraryPermissionStatus() -> PHAuthorizationStatus {
		return PHPhotoLibrary.authorizationStatus()
	}
}

// MARK: - CLLocationManagerDelegate

extension AIPermission: CLLocationManagerDelegate {
	@available(iOS 14.0, *)
	public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
		AIPermission.locationManagerPermissionCallback?(manager.authorizationStatus)
	}
	
	public func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		AIPermission.locationManagerLocationCallback?(locations.last)
	}
	
	public func locationManager(_: CLLocationManager, didFailWithError _: Error) {
		// Handle failure to get a user’s location
		AIPermission.locationManagerLocationCallback?(nil)
	}
}

// MARK: - Helper Methods for Alerting (Optional)

public extension AIPermission {
	/// Presents an alert directing the user to the app settings to grant permissions.
	/// - Parameters:
	///   - viewController: The view controller from which to present the alert.
	///   - permissionType: The type of permission needed.
	static func presentPermissionAlert(on viewController: UIViewController, permissionType: PermissionType) {
		let title: String
		let message: String
		
		switch permissionType {
		case .camera:
			title = "Camera Access Needed"
			message = "Please enable access to your camera in Settings."
		case .microphone:
			title = "Microphone Access Needed"
			message = "Please enable access to your microphone in Settings."
		case .contacts:
			title = "Contacts Access Needed"
			message = "Please enable access to your contacts in Settings."
		case .location:
			title = "Location Access Needed"
			message = "Please enable access to your location in Settings."
		case .notifications:
			title = "Notifications Access Needed"
			message = "Please enable access to notifications in Settings."
		case .photoLibrary:
			title = "Photo Library Access Needed"
			message = "Please enable access to your photo library in Settings."
		}
		
		let alert = UIAlertController(
			title: title,
			message: message,
			preferredStyle: .alert
		)
		
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
			if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
				UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
			}
		})
		
		viewController.present(alert, animated: true, completion: nil)
	}
}

public extension AIPermission {
	/// Requests the specified permission with a type-safe completion handler.
	/// - Parameters:
	///   - type: The type of permission to request.
	///   - viewController: The view controller to present alerts if needed.
	///   - completion: A closure that receives the permission status.
	static func requestPermission<T>(for type: PermissionType, on viewController: UIViewController? = nil, completion: @escaping (T) -> Void) {
		switch type {
		case .camera:
			requestCameraPermission { status in
				if let status = status as? T {
					completion(status)
				}
			}
			
		case .microphone:
			requestMicrophoneRecordPermission { status in
				if let status = status as? T {
					completion(status)
				}
			}
			
		case .contacts:
			requestContactsPermission { granted in
				if let granted = granted as? T {
					completion(granted)
				}
			}
			
		case .location:
			if #available(iOS 14.0, *) {
				requestLocationPermission { status in
					if let status = status as? T {
						completion(status)
					}
				}
			} else {
				// Handle older iOS versions or notify that the permission is not supported.
				//				completion(nil as! T) // Be cautious with force casting
			}
			
		case .notifications:
			guard let app = UIApplication.shared.delegate as? UIApplication else {
				completion(false as! T) // Be cautious with force casting
				return
			}
			requestNotificationPermission(application: app) { granted in
				if let granted = granted as? T {
					completion(granted)
				}
			}
			
		case .photoLibrary:
			requestPhotoLibraryPermission { status in
				if let status = status as? T {
					completion(status)
				}
			}
		}
	}
}

