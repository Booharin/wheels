//
//  AppealsNetworkRouter.swift
//  Guard
//
//  Created by Alexandr Bukharin on 09.12.2020.
//  Copyright © 2020 ds. All rights reserved.
//

import Alamofire
import Foundation

struct AppealsNetworkRouter {
	private let environment: Environment

	init(environment: Environment) {
		self.environment = environment
	}

	func getClientAppeals(by id: Int,
						  page: Int,
						  pageSize: Int,
						  token: String?) -> URLRequestConvertible {
		do {
			return try ClientAppeals(environment: environment,
									 id: id,
									 page: page,
									 pageSize: pageSize).asURLDefaultRequest(with: token)
		} catch {
			return ClientAppeals(environment: environment,
								 id: id,
								 page: page,
								 pageSize: pageSize)
		}
	}

	func createAppeal(title: String,
					  appealDescription: String,
					  clientId: Int,
					  subIssueCode: Int,
					  cityCode: Int,
					  token: String?) -> URLRequestConvertible {
		do {
			return try CreateAppeal(environment: environment,
									title: title,
									appealDescription: appealDescription,
									clientId: clientId,
									subIssueCode: subIssueCode,
									cityCode: cityCode).asJSONURLRequest(with: token)
		} catch {
			return CreateAppeal(environment: environment,
								title: title,
								appealDescription: appealDescription,
								clientId: clientId,
								subIssueCode: subIssueCode,
								cityCode: cityCode)
		}
	}

	func editAppeal(title: String,
					appealDescription: String,
					appeal: ClientAppeal,
					cityCode: Int,
					token: String?) -> URLRequestConvertible {
		do {
			return try EditAppeal(environment: environment,
								  id: appeal.id,
								  title: title,
								  appealDescription: appealDescription,
								  date: appeal.dateCreated,
								  clientId: appeal.clientId,
								  subIssueCode: appeal.subIssueCode,
								  cityCode: cityCode).asJSONURLRequest(with: token)
		} catch {
			return EditAppeal(environment: environment,
							  id: appeal.id,
							  title: title,
							  appealDescription: appealDescription,
							  date: appeal.dateCreated,
							  clientId: appeal.clientId,
							  subIssueCode: appeal.subIssueCode,
							  cityCode: cityCode)
		}
	}

	func deleteAppeal(id: Int, token: String?) -> URLRequestConvertible {
		do {
			return try DeleteAppeal(environment: environment,
									id: id).asURLDefaultRequest(with: token)
		} catch {
			return DeleteAppeal(environment: environment,
								id: id)
		}
	}

	func getAppeals(by issueCodes: [Int]?,
					cityTitle: String,
					page: Int,
					pageSize: Int,
					token: String?) -> URLRequestConvertible {
		do {
			if let issueCodes = issueCodes,
			   !issueCodes.isEmpty {
				return try AppealsByIssue(environment: environment,
										  issueCodes: issueCodes,
										  cityTitle: cityTitle,
										  page: page,
										  pageSize: pageSize).asURLDefaultRequest(with: token)
			} else {
				return try AllAppeals(environment: environment,
									  cityTitle: cityTitle,
									  page: page,
									  pageSize: pageSize).asURLDefaultRequest(with: token)
			}
		} catch {
			return AllAppeals(environment: environment,
							  cityTitle: cityTitle,
							  page: page,
							  pageSize: pageSize)
		}
	}

	func getClient(by appealId: Int,
				   token: String?) -> URLRequestConvertible {
		do {
			return try ClientByAppealId(environment: environment,
										appealId: appealId).asURLDefaultRequest(with: token)
		} catch {
			return ClientByAppealId(environment: environment,
									appealId: appealId)
		}
	}

	func getAppeal(by id: Int, token: String?) -> URLRequestConvertible {
		do {
			return try GetAppeal(environment: environment,
								 appealId: id).asURLDefaultRequest(with: token)
		} catch {
			return GetAppeal(environment: environment,
							 appealId: id)
		}
	}

	func changeAppealStatus(id: Int,
							status: Bool,
							token: String?) -> URLRequestConvertible {
		do {
			return try ChangeAppealStatus(environment: environment,
										  appealId: id,
										  isSelected: status).asURLDefaultRequest(with: token)
		} catch {
			return ChangeAppealStatus(environment: environment,
									  appealId: id,
									  isSelected: status)
		}
	}
}

extension AppealsNetworkRouter {

	private struct ClientAppeals: RequestRouter {

		let environment: Environment
		let id: Int
		let page: Int
		let pageSize: Int

		init(environment: Environment,
			 id: Int,
			 page: Int,
			 pageSize: Int) {
			self.environment = environment
			self.id = id
			self.page = page
			self.pageSize = pageSize
		}

		var baseUrl: URL {
			return environment.baseUrl
		}

		var method: HTTPMethod = .get
		var path = ApiMethods.clientAppeals
		var parameters: Parameters {
			return [
				"id": id,
				"page": page,
				"pageSize": pageSize
			]
		}
	}

	private struct CreateAppeal: RequestRouter {

		let environment: Environment
		let title: String
		let appealDescription: String
		let clientId: Int
		let subIssueCode: Int
		let cityCode: Int

		init(environment: Environment,
			 title: String,
			 appealDescription: String,
			 clientId: Int,
			 subIssueCode: Int,
			 cityCode: Int) {
			self.environment = environment
			self.title = title
			self.appealDescription = appealDescription
			self.clientId = clientId
			self.subIssueCode = subIssueCode
			self.cityCode = cityCode
		}

		var baseUrl: URL {
			return environment.baseUrl
		}

		var method: HTTPMethod = .post
		var path = ApiMethods.createAppeal
		var parameters: Parameters {
			return [
				"title": title,
				"appealDescription": appealDescription,
				"dateCreated": Date.getCurrentDate(),
				"clientId": clientId,
				"subIssueCode": subIssueCode,
				"cityCode": cityCode,
				"isLawyerChoosed": false
			]
		}
	}

	private struct EditAppeal: RequestRouter {

		let environment: Environment
		let id: Int
		let title: String
		let appealDescription: String
		let date: String
		let clientId: Int
		let subIssueCode: Int
		let cityCode: Int

		init(environment: Environment,
			 id: Int,
			 title: String,
			 appealDescription: String,
			 date: String,
			 clientId: Int,
			 subIssueCode: Int,
			 cityCode: Int) {
			self.environment = environment
			self.id = id
			self.title = title
			self.appealDescription = appealDescription
			self.date = date
			self.clientId = clientId
			self.subIssueCode = subIssueCode
			self.cityCode = cityCode
		}

		var baseUrl: URL {
			return environment.baseUrl
		}

		var method: HTTPMethod = .post
		var path = ApiMethods.editAppeal
		var parameters: Parameters {
			return [
				"id": id,
				"title": title,
				"appealDescription": appealDescription,
				"dateCreated": date,
				"clientId": clientId,
				"subIssueCode": subIssueCode,
				"cityCode": cityCode,
				"isLawyerChoosed": false
			]
		}
	}

	private struct DeleteAppeal: RequestRouter {

		let environment: Environment
		let id: Int

		init(environment: Environment,
			 id: Int) {
			self.environment = environment
			self.id = id
		}

		var baseUrl: URL {
			return environment.baseUrl
		}

		var method: HTTPMethod = .post
		var path = ApiMethods.deleteAppeal
		var parameters: Parameters {
			return [
				"appealId": id
			]
		}
	}

	private struct AllAppeals: RequestRouter {

		let environment: Environment
		let cityTitle: String
		let page: Int
		let pageSize: Int

		init(environment: Environment,
			 cityTitle: String,
			 page: Int,
			 pageSize: Int) {
			self.environment = environment
			self.cityTitle = cityTitle
			self.page = page
			self.pageSize = pageSize
		}

		var baseUrl: URL {
			return environment.baseUrl
		}

		var method: HTTPMethod = .get
		var path = ApiMethods.allAppeals
		var parameters: Parameters {
			return [
				"cityTitle": cityTitle,
				"page": page,
				"pageSize": pageSize
			]
		}
	}

	private struct AppealsByIssue: RequestRouter {

		let environment: Environment
		let issueCodes: [Int]
		let cityTitle: String
		let page: Int
		let pageSize: Int

		init(environment: Environment,
			 issueCodes: [Int],
			 cityTitle: String,
			 page: Int,
			 pageSize: Int) {
			self.environment = environment
			self.issueCodes = issueCodes
			self.cityTitle = cityTitle
			self.page = page
			self.pageSize = pageSize
		}

		var baseUrl: URL {
			return environment.baseUrl
		}

		var method: HTTPMethod = .get
		var path = ApiMethods.appealsByIssue
		var parameters: Parameters {
			return [
				"issueCodeList": issueCodes
					.map { String($0) }
					.joined(separator:","),
				"city": cityTitle,
				"page": page,
				"pageSize": pageSize
			]
		}
	}

	private struct ClientByAppealId: RequestRouter {

		let environment: Environment
		let appealId: Int

		init(environment: Environment,
			 appealId: Int) {
			self.environment = environment
			self.appealId = appealId
		}

		var baseUrl: URL {
			return environment.baseUrl
		}

		var method: HTTPMethod = .get
		var path = ApiMethods.clientByAppealId
		var parameters: Parameters {
			return [
				"appealId": appealId
			]
		}
	}

	private struct GetAppeal: RequestRouter {

		let environment: Environment
		let appealId: Int

		init(environment: Environment,
			 appealId: Int) {
			self.environment = environment
			self.appealId = appealId
		}

		var baseUrl: URL {
			return environment.baseUrl
		}

		var method: HTTPMethod = .get
		var path = ApiMethods.getAppeal
		var parameters: Parameters {
			return [
				"appealId": appealId
			]
		}
	}

	private struct ChangeAppealStatus: RequestRouter {

		let environment: Environment
		let appealId: Int
		let isSelected: Bool

		init(environment: Environment,
			 appealId: Int,
			 isSelected: Bool) {
			self.environment = environment
			self.appealId = appealId
			self.isSelected = isSelected
		}

		var baseUrl: URL {
			return environment.baseUrl
		}

		var method: HTTPMethod = .post
		var path = ApiMethods.changeAppealStatus
		var parameters: Parameters {
			return [
				"appealId": appealId,
				"isSelected": isSelected
			]
		}
	}
}
