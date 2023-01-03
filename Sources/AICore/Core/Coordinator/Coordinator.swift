//
//  Coordinator.swift
//  Fibler2
//
//  Created by Alexy Ibrahim on 9/20/19.
//  Copyright © 2019 siegma. All rights reserved.
//

import Foundation
import UIKit

public protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}
