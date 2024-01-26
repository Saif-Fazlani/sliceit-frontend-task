//
//  MasterNavigationController.swift
//  Sliceit Frontend Task
//
//  Created by Saifullah Fazlani on 26/01/2024.
//

import UIKit

final class MasterNavigationController: UINavigationController {

    private var _isNavigationBarHidden: Bool?

    override var isNavigationBarHidden: Bool {
        get { _isNavigationBarHidden ?? super.isNavigationBarHidden }
        set { super.isNavigationBarHidden = newValue }
    }

    convenience init(isNavigationBarHidden: Bool) {
        self.init()
        self._isNavigationBarHidden = isNavigationBarHidden
        self.setNavigationBarHidden(isNavigationBarHidden, animated: false)
    }
    
    @discardableResult
    func push(to viewController: UIViewController) -> Self {
        self.pushViewController(viewController, animated: true)
        return self
    }
    
    @discardableResult
    func pop() -> Self {
        self.popViewController(animated: true)
        return self
    }
}
