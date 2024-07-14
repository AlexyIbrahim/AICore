import UIKit

@available(iOS 16.0, *)
public extension UISheetPresentationController.Detent {
	
	// Convenience method for creating a detent with a fixed height
	static func height(_ height: CGFloat) -> UISheetPresentationController.Detent {
		return self.custom { _ in
			return height
		}
	}
	
	// Convenience method for creating a detent with a percentage of screen height
	static func percentage(_ percentage: CGFloat) -> UISheetPresentationController.Detent {
		return self.custom { context in
			return context.maximumDetentValue * percentage
		}
	}
}

