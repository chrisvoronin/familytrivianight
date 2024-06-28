//
//  UINavigationViewController+Ext.swift
//  Family Trivia
//
//  Created by Chris Voronin on 11/27/20.
//  Copyright © 2020 Chris Voronin. All rights reserved.
//

import Foundation

extension UINavigationController {
    func pushViewController(_ viewController: UIViewController, animated: Bool, completion: @escaping () -> Void) {
        self.pushViewController(viewController, animated: animated)
        self.callCompletion(animated: animated, completion: completion)
    }

    @discardableResult
    func popViewController(animated: Bool, completion: @escaping () -> Void) -> UIViewController? {
        let viewController = self.popViewController(animated: animated)
        self.callCompletion(animated: animated, completion: completion)
        return viewController
    }

    private func callCompletion(animated: Bool, completion: @escaping () -> Void) {
        if animated, let coordinator = self.transitionCoordinator {
            coordinator.animate(alongsideTransition: nil) { _ in
                completion()
            }
        } else {
            completion()
        }
    }
}
