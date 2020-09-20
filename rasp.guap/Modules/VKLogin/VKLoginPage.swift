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
    
	@IBOutlet weak var LoginButton: UIButton!
	@IBOutlet weak var errLabel: UILabel!
    @IBAction func loginViaVK(_ sender: UIButton, forEvent event: UIEvent) {
        VK.sessions.default.logIn(onSuccess: { _ in
            PocketAPI.shared.setToken(VK.sessions.default.accessToken!.get()!)
            DispatchQueue.main.async {
                let _ = UIApplication.shared.appDelegate.application(UIApplication.shared, didFinishLaunchingWithOptions: nil)
            }
        }) { (err) in
            DispatchQueue.main.async {
				self.errLabel.text = self.errorText(err: err)
                self.errLabel.isHidden = false
            }
            
            print(err)
        }
    }
	func errorText(err:VKError)->String{
		switch err {
			case .unknown(let error):
				return error.localizedDescription
			case .api(let apiError):
				return "Code \(apiError.code): \(apiError.message)"
			case .cantSaveToKeychain(_):
				return "Can't save token to keychain"
			case .vkDelegateNotFound:
				return "Ошибка авторизации, бейте разработчика приложения"
			case .cantParseTokenInfo(let str):
				return "Не удалось получить токен!\n\(str)"
			case .sessionAlreadyDestroyed(_):
				return ""
			case .sessionAlreadyAuthorized(let session):
				session.logOut()
				return "Повторите авторизацию"
			case .sessionIsNotAuthorized(let session):
				print("not authorized \(session)")
				return ""
			case .unexpectedResponse:
				return ""
			case .jsonNotParsed(_):
				return ""
			case .urlRequestError(let err):
				print(err)
				return "Ошибка авторизации, проверьте подключение к интернету"
			case .captchaResultIsNil:
				return ""
			case .wrongUrl:
				return "Некорректный URL"
			case .cantAwaitOnMainThread:
				return ""
			case .cantAwaitRequestWithSettedCallbacks:
				return ""
			case .cantBuildWebViewUrl(let err):
				return "Ошибка \(err)"
			case .cantBuildVKAppUrl(_):
				return "Не получилось отправить запрос приложению VK"
			case .captchaPresenterTimedOut:
				return ""
			case .cantMakeCapthaImageUrl(_):
				return ""
			case .cantLoadCaptchaImage(_):
				return ""
			case .cantLoadCaptchaImageWithUnknownReason:
				return ""
			case .webPresenterTimedOut:
				return "Таймаут авторизации, попробуйте снова"
			case .webPresenterResultIsNil:
				return ""
			case .webControllerError(let err):
				return "Ошибка веб-контроллера, попробуйте авторизоваться через приложение VK\n\(err.localizedDescription)"
			case .authorizationUrlIsNil:
				return ""
			case .authorizationDenied:
				return "Ошибка доступа"
			case .authorizationCancelled:
				return "Авторизация отменена"
			case .authorizationFailed:
				return "Авторизация не удалась"
			case .captchaWasDismissed:
				return ""
			case .sharingWasDismissed:
				return ""
			case .weakObjectWasDeallocated:
				return ""
		}
	}
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
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		super.traitCollectionDidChange(previousTraitCollection)
		self.LoginButton.layer.borderColor = self.LoginButton.titleLabel?.textColor.cgColor
	}
    override func viewDidAppear(_ animated: Bool){
		super.viewDidAppear(animated)
		SAUserSettings.shared.reset()
        VK.release()
        VK.setUp(appId: "7578765", delegate: self)
		VK.sessions.default.logOut()
    }
}
extension VKLoginPageViewController:SwiftyVKDelegate{
    func vkNeedToPresent(viewController: VKViewController) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func vkNeedsScopes(for sessionId: String) -> Scopes { [.offline,.stats] }
    
    
}
