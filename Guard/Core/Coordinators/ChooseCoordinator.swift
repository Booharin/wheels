//
//  ChooseCoordinator.swift
//  Guard
//
//  Created by Alexandr Bukharin on 10.07.2020.
//  Copyright © 2020 ds. All rights reserved.
//

import UIKit

final class ChooseCoordinator: BaseCoordinator {
	var rootController: NavigationController?
	var onFinishFlow: (() -> Void)?
	
	override func start() {
		showChooseModule()
	}
	
	private func showChooseModule() {
		let controller = ChooseViewController(viewModel: ChooseViewModel())
		
		controller.toRegistration = { userRole in
			self.toRegistration(userRole)
		}
		
		if let navVC = UIApplication.shared.windows.first?.rootViewController as? NavigationController {
			navVC.pushViewController(controller, animated: true)
		} else {
			let rootController = NavigationController(rootViewController: controller)
			setAsRoot(rootController)
			self.rootController = rootController
		}
	}
	
	private func toRegistration(_ userRole: UserRole) {
		let coordinator = RegistrationCoordinator(userRole: userRole)
		coordinator.onFinishFlow = { [weak self, weak coordinator] in
			self?.removeDependency(coordinator)
			self?.onFinishFlow?()
		}
		addDependency(coordinator)
		coordinator.start()
	}
}
