//
//  AppealsListRouter.swift
//  Guard
//
//  Created by Alexandr Bukharin on 19.01.2021.
//  Copyright © 2021 ds. All rights reserved.
//

import RxSwift
import RxCocoa

protocol AppealsListRouterProtocol {
	var toAppealDescriptionSubject: PublishSubject<ClientAppeal> { get }
	func presentFilterScreenViewController(subIssuesCodes: [Int],
										   filterIssuesSubject: PublishSubject<[Int]>)
}

final class AppealsListRouter: BaseRouter, AppealsListRouterProtocol {
	private var disposeBag = DisposeBag()
	var toAppealDescriptionSubject = PublishSubject<ClientAppeal>()

	override init() {
		super.init()
		createTransitions()
	}

	private func createTransitions() {
		// to appeal description
		toAppealDescriptionSubject
			.observeOn(MainScheduler.instance)
			.subscribe(onNext: { [unowned self] appeal in
				self.toAppealDescription(appeal)
			})
			.disposed(by: disposeBag)
	}

	private func toAppealDescription(_ appeal: ClientAppeal) {
		let router = AppealFromListRouter()
		router.navigationController = navigationController
		let viewModel = AppealFromListViewModel(appeal: appeal,
												router: router)
		let toAppealCreatingController = AppealFromListViewController(viewModel: viewModel)
		self.navigationController?.pushViewController(toAppealCreatingController, animated: true)
	}

	func presentFilterScreenViewController(subIssuesCodes: [Int],
										   filterIssuesSubject: PublishSubject<[Int]>) {
		let controller = FilterScreenModuleFactory.createModule(subIssuesCodes: subIssuesCodes,
																selectedIssuesSubject: filterIssuesSubject)
		navigationController?.present(controller, animated: true)
	}
}
