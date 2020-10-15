//
//  VKLoginPage.swift
//  rasp.guap
//
//  Created by Кирилл on 19.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit
import SUAI_API
import SwiftyVK

class VKLoginPageViewController: UIViewController {
	@IBOutlet weak var LoginButton: PocketLongActionButton!
	@IBOutlet weak var errLabel: UILabel!
    @IBAction func loginViaVK(_ sender: UIButton, forEvent event: UIEvent) {
		UIApplication.shared.shortcutItems = nil
		self.errLabel.text = ""
		self.errLabel.isHidden = true
		self.LoginButton.disable()
		Logger.print(from: "VK Login", "start")
        VK.sessions.default.logIn(onSuccess: { _ in
            PocketAPI.shared.setToken(VK.sessions.default.accessToken!.get()!)
			Logger.print(from: "VK Login", "set token")
			if SAUserSettings.shared.reload() {
				Logger.print(from: "VK Login", "reload ok")
				DispatchQueue.main.async {
					_ = UIApplication.shared.appDelegate.application(UIApplication.shared, didFinishLaunchingWithOptions: nil)
				}
			} else {
				Logger.print(from: "VK Login", "reload err")
				DispatchQueue.main.async {
					self.errLabel.text = "Не удалось синхронизировать настройки.\nПерезайдите в приложение позже."
					self.errLabel.isHidden = false
				}
			}
			DispatchQueue.main.async {self.LoginButton.enable()}
			Logger.print(from: "VK Login", "reload end")
            
		}, onError: { (err) in
            DispatchQueue.main.async {
				self.LoginButton.enable()
				self.errLabel.text = self.errorText(err: err)
                self.errLabel.isHidden = false
            }
            
			Logger.print(from: "VK Login", err)
        })
    }
	// swiftlint:disable cyclomatic_complexity
	func errorText(err: VKError) -> String {
		switch err {
			case .unknown(let error): return error.localizedDescription
			case .api(let apiError): return "Code \(apiError.code): \(apiError.message)"
			case .cantSaveToKeychain: return "Can't save token to keychain"
			case .vkDelegateNotFound: return "Ошибка авторизации, бейте разработчика приложения"
			case .cantParseTokenInfo(let str): return "Не удалось получить токен!\n\(str)"
			case .sessionAlreadyDestroyed: return ""
			case .sessionAlreadyAuthorized(let session):
				session.logOut()
				return "Повторите авторизацию"
			case .sessionIsNotAuthorized: return "Сессия не авторизована"
			case .unexpectedResponse: return "Неопознанный ответ сервера"
			case .jsonNotParsed: return "Ошибка расшифровки ответа"
			case .urlRequestError: return "Ошибка авторизации, проверьте подключение к интернету"
			case .captchaResultIsNil: return ""
			case .wrongUrl: return "Некорректный URL"
			case .cantAwaitOnMainThread: return ""
			case .cantAwaitRequestWithSettedCallbacks: return ""
			case .cantBuildWebViewUrl(let err): return "Ошибка \(err)"
			case .cantBuildVKAppUrl: return "Не получилось отправить запрос приложению VK"
			case .captchaPresenterTimedOut: return ""
			case .cantMakeCapthaImageUrl: return ""
			case .cantLoadCaptchaImage: return ""
			case .cantLoadCaptchaImageWithUnknownReason: return ""
			case .webPresenterTimedOut: return "Таймаут авторизации, попробуйте снова"
			case .webPresenterResultIsNil: return ""
			case .webControllerError(let err): return "Ошибка веб-контроллера, попробуйте авторизоваться через приложение VK\n\(err.localizedDescription)"
			case .authorizationUrlIsNil: return ""
			case .authorizationDenied: return "Ошибка доступа"
			case .authorizationCancelled: return "Авторизация отменена"
			case .authorizationFailed: return "Авторизация не удалась"
			case .captchaWasDismissed: return ""
			case .sharingWasDismissed: return ""
			case .weakObjectWasDeallocated: return ""
		}
	}
	// swiftlint:enable cyclomatic_complexity
	override func viewDidLoad() {
		super.viewDidLoad()
		let color = Asset.PocketColors.pocketDarkBlue.color
		self.LoginButton.layer.borderWidth = 2
		self.LoginButton.layer.borderColor = color.cgColor
		self.LoginButton.setTitleColor(color, for: .normal)
		self.LoginButton.setImage(Asset.SystemIcons.vkLogo.image.withRenderingMode(.alwaysTemplate), for: .normal)
		self.LoginButton.imageView?.tintColor = color
		
		self.LoginButton.titleLabel?.snp.makeConstraints({ (make) in
			make.centerY.equalToSuperview()
			make.centerX.equalToSuperview().offset(6)
		})
		self.LoginButton.imageView?.snp.makeConstraints({ (make) in
			make.width.height.equalTo(22)
			make.right.equalTo(self.LoginButton.titleLabel!.snp.left).offset(-5)
		})

	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		AppSettings.isDeadlineNotificationsEnabled = true
		AppSettings.isTimetableNotificationsEnabled = true
		setupQuickActions()
		
		SAUserSettings.shared.reset()
		if !VK.needToSetUp {
			VK.sessions.default.logOut()
			VK.release()
		}
		VK.setUp(appId: "7578765", delegate: self)
		
	}
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		super.traitCollectionDidChange(previousTraitCollection)
		self.LoginButton.layer.borderColor = self.LoginButton.titleLabel?.textColor.cgColor
	}
	
	private func setupQuickActions() {
		NotificationCenter.default.addObserver(self, selector: #selector(shortcutNotification(_:)), name: AppDelegate.shortcutNotification, object: nil)
		UIApplication.shared.shortcutItems = nil
//		UIApplication.shared.shortcutItems = [UIApplicationShortcutItem(type: "vkLogin", localizedTitle: "Авторизоваться через VK", localizedSubtitle: nil, icon: UIApplicationShortcutIcon(templateImageName: Asset.SystemIcons.vkLogo.name), userInfo: nil)]
	}
	@objc func shortcutNotification(_ notif: Notification) {
		if let shortcut = notif.userInfo?.first?.value as? UIApplicationShortcutItem {
			let type = shortcut.type
			if type.contains("vk") {
				self.loginViaVK(self.LoginButton, forEvent: UIEvent())
			}
		} else {
			Logger.print(from: #function, "can not cast recieved message")
		}
		
	}

}
extension VKLoginPageViewController: SwiftyVKDelegate {
    func vkNeedToPresent(viewController: VKViewController) {
        self.present(viewController, animated: true, completion: nil)
    }
    
	func vkNeedsScopes(for sessionId: String) -> Scopes { [.offline, .stats, .groups] }
    
}
