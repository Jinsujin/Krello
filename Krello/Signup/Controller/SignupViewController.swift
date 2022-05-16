//
//  SignUpViewController.swift
//  Krello
//
//  Created by Kai Kim on 2022/05/11.
//

import UIKit
import FirebaseAuth
class SignupViewController: UIViewController {

    private let signupView = SignupFormView()
    private let validator = Validator()
    private let authenticationManager = AuthenticationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        view = signupView
        processFieldEmptyValidation()
        processRegexValidation()
        processPasswordConfirmation()
        processSignup()
        signupView.didTapCloseButton = { [weak self] in
            self?.dismiss(animated: true)
        }
    }

    private func processFieldEmptyValidation() {
        signupView.validateEmptyFields = {[weak self] textField in
        guard let text = textField.text, let self = self else {return nil}
        return  self.validator.validateEmpty(text)
        }
    }

    private func processRegexValidation () {
        signupView.validateRegexFields = { [weak self] textField in
            guard let item = textField.item, let text = textField.text, let self = self else {return nil}
            return self.validator.isValidFormat(text, for: item)
        }
    }

    private func processPasswordConfirmation() {
        signupView.validatePasswordConfirmation = { [weak self] password, passwordConfirmationTextField in
            guard let self = self else {return nil}
            let result = self.validator.isMatched(password: password, confirmPassword: passwordConfirmationTextField.text)
            return result}
    }

    private func processSignup() {
        signupView.didTapSignupButton = { [weak self] email, password, userName in
            guard let self = self else {return}
            let userInfo = AuthenticationInfo(email: email, password: password)
            self.authenticationManager.signUp(info: userInfo) { result in
                switch result {
                case .success(let user):
                    print("success!")

                case .failure(let error):
                    // TODO: 서버와 연결이 끊기면 Alert 띄우기
                    let alert = UIAlertController(title: "\(userName) 님 환영합니다!", message: nil, preferredStyle: .alert)
                    let action = UIAlertAction(title: "확인", style: .default, handler: {_ in
                        self.dismiss(animated: true)
                    })
                    alert.addAction(action)
                    self.present(alert, animated: true)
                }
            }
        }
    }

}
// Add this to see preview
#if canImport(SwiftUI) && DEBUG
import SwiftUI
struct SignupViewControllerPreviews: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            // This is viewController you want to see.
            return SignupViewController()
        }
        .previewDevice("iPhone 12")
    }
}
#endif
