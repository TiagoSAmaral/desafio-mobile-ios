//
//  Router.swift
//  javahubTests
//
//  Created by Tiago da Silva Amaral on 17/07/18.
//  Copyright © 2018 com.outlook.tiagofly. All rights reserved.
//

import UIKit

protocol RouterInterface {
	func goTo(destiny: Routes, pushForward data: Any?)
}

class Router: NSObject, RouterInterface {
	weak var view: RouterViewInterface?

	init(view: RouterViewInterface) {
		super.init()

		self.view = view
	}

	func goTo(destiny: Routes, pushForward data: Any?) {
		switch destiny {
		case .repositories:

			guard let viewInstance = buildView(destiny.file, RepositoriesViewController.identifier, RepositoriesViewController.self) else {
				return
			}

			viewInstance.presenter = Repositories(view: viewInstance, router: self)
			self.view?.setViewControllers([viewInstance], animated: false)

		case .pullrequests:

			guard let data = data as? Repository else {
				return
			}
			guard let viewInstance = buildView(destiny.file, PullRequestsViewController.identifier, PullRequestsViewController.self) else {
				return
			}

			viewInstance.presenter = PullRequests(view: viewInstance, router: self, repository: data)
			self.view?.pushViewController(viewInstance, animated: true)

		case .linkBrowser:

			guard let validStringUrl = data as? String else {
				return
			}
			guard let stringURL = URL(string: validStringUrl) else {
				return
			}
            UIApplication.shared.open(stringURL, options: ["": ""], completionHandler: nil)
		}
	}

	func buildView<T>(_ nameFile: String, _ identifier: String, _ viewClass: T.Type) -> T? {
		guard let result = UIStoryboard(name: nameFile, bundle: nil).instantiateViewController(withIdentifier: identifier) as? T else {
			return nil
		}
		return result
	}
}
