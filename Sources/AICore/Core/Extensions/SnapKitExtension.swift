//
// Created by Alexy Ibrahim on 10/18/22.
//

import Foundation
import SnapKit

public extension ConstraintMaker {
    func applyLeadingTrailingMargin(_ v: CGFloat) {
        self.leading.equalToSuperview().offset(v)
        self.trailing.equalToSuperview().offset(v)
    }

    func centerHorizontally() {

    }
}
