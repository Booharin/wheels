//
//  RegistrationService.swift
//  Guard
//
//  Created by Alexandr Bukharin on 28.11.2020.
//  Copyright © 2020 ds. All rights reserved.
//

import Alamofire
import RxSwift
import KeychainSwift

protocol HasRegistrationService {
	var registrationService: RegistrationServiceInterface { get set }
}

protocol RegistrationServiceInterface {
	func signUp(email: String,
				password: String,
				city: String,
				userRole: UserRole) -> Observable<Result<Any, AFError>>

	func anonimusSignUp() -> Observable<Result<Any, AFError>>
}

final class RegistrationService: RegistrationServiceInterface, HasDependencies {

	private let router: RegistrationNetworkRouter
	typealias Dependencies =
		HasKeyChainService &
		HasLocalStorageService
	lazy var di: Dependencies = DI.dependencies

	init() {
		router = RegistrationNetworkRouter(environment: EnvironmentImp())
	}

	func signUp(email: String,
				password: String,
				city: String,
				userRole: UserRole) -> Observable<Result<Any, AFError>> {
		return Observable<Result>.create { (observer) -> Disposable in
			let requestReference = AF.request(self.router.signUp(email: email,
																 password: password,
																 city: city,
																 role: userRole))
				.response { response in
					#if DEBUG
					print(response)
					#endif
					switch response.result {
					case .success:
						self.di.keyChainService.save(email, for: Constants.KeyChainKeys.email)
						self.di.keyChainService.save(password, for: Constants.KeyChainKeys.password)
						observer.onNext(.success(()))
					case .failure:
						observer.onNext(.failure(AFError.createURLRequestFailed(error: response.error ?? NetworkError.common)))
					}
			}
			return Disposables.create(with: {
				requestReference.cancel()
			})
		}
	}

	func anonimusSignUp() -> Observable<Result<Any, AFError>> {
		return Observable<Result>.create { (observer) -> Disposable in
			let requestReference = AF.request(self.router.anonimusSignUp())
				.response { response in
					#if DEBUG
					print(response)
					#endif
					switch response.result {
					case .success:
						guard let data = response.data else {
							observer.onNext(.failure(AFError.createURLRequestFailed(error: NetworkError.common)))
							return
						}
						do {
							let client = try JSONDecoder().decode(UserProfile.self, from: data)
							self.di.keyChainService.save(String(client.id),
														 for: Constants.KeyChainKeys.clientId)
							self.di.keyChainService.save(client.email ?? "",
														 for: Constants.KeyChainKeys.email)
							self.di.keyChainService.save(client.password ?? "",
														 for: Constants.KeyChainKeys.password)

							observer.onNext(.success(()))
							observer.onCompleted()
						} catch {
							#if DEBUG
							print(error)
							#endif
							observer.onNext(.failure(AFError.createURLRequestFailed(error: NetworkError.common)))
						}
						observer.onNext(.success(()))
					case .failure:
						observer.onNext(.failure(AFError.createURLRequestFailed(error: response.error ?? NetworkError.common)))
					}
			}
			return Disposables.create(with: {
				requestReference.cancel()
			})
		}
	}
}
