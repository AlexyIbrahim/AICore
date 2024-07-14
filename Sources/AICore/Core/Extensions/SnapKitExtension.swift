//
// Created by Alexy Ibrahim on 10/18/22.
//

import Foundation
import SnapKit

public extension ConstraintMaker {
    func applyLeadingTrailingMargin(_ v: CGFloat) {
        leading.equalToSuperview().offset(v)
        trailing.equalToSuperview().offset(v)
    }

    func centerHorizontally() {}
}
