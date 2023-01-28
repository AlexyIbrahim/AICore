
import Foundation
import UIKit

//MARK: - Blur effect method
extension AIToast {
   
     static func applyBlurEffect(effect: UIBlurEffect.Style?, view: UIView){
        guard let effect = effect else {
            return
        }
        
        let blurEffect = UIBlurEffect(style: effect)
        visualEffect.effect = blurEffect
        view.addSubview(visualEffect)
        visualEffect.frame = view.frame
    }
}
