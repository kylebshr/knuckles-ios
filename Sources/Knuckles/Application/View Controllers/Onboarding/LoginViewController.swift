import AuthenticationServices
import UIKit

class LoginViewController: ViewController {

    private let appleButton = Button(title: "Sign in with Apple")

    override func viewDidLoad() {
        super.viewDidLoad()

        view.layoutMargins.bottom = 20

        let icon = UIImageView(image: #imageLiteral(resourceName: "in-app-icon"))

        let titleLabel = UILabel(font: .systemFont(ofSize: 38, weight: .bold))
        let welcome = NSAttributedString(string: "Welcome to\n")
        let balance = NSAttributedString(string: "Balance", attributes: [.foregroundColor: UIColor.brand])
        titleLabel.attributedText = welcome + balance
        titleLabel.numberOfLines = 0

        let descriptionLabel = UILabel(font: .systemFont(ofSize: 17), color: .customSecondaryLabel)
        descriptionLabel.text = "Keep track of expenses, meet your goals, see your balance."
        descriptionLabel.numberOfLines = 0

        let disclaimerLabel = UILabel(font: .systemFont(ofSize: 14), color: .customSecondaryLabel, alignment: .center)
        disclaimerLabel.text = "By signing up you agree to our Terms of Service"
        disclaimerLabel.numberOfLines = 0

        let disclaimerWrapper = UIView()
        disclaimerWrapper.addSubview(disclaimerLabel)
        disclaimerLabel.pinEdges([.top, .bottom], to: disclaimerWrapper)
        disclaimerLabel.pinCenter(to: disclaimerWrapper)

        appleButton.addTarget(self, action: #selector(signIn), for: .touchUpInside)

        let topSpacer = UIView()
        let bottomSpacer = UIView()

        let stackView = UIStackView(arrangedSubviews: [topSpacer, icon, titleLabel, descriptionLabel, bottomSpacer, appleButton, disclaimerWrapper])
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 16

        view.addSubview(stackView)

        stackView.pinEdges(to: view.layoutMarginsGuide)
        appleButton.widthAnchor.pin(to: stackView.widthAnchor)
        disclaimerWrapper.widthAnchor.pin(to: stackView.widthAnchor)
        disclaimerLabel.widthAnchor.pin(lessThan: stackView.widthAnchor, constant: -60)
        disclaimerLabel.widthAnchor.pin(lessThan: 200)
        topSpacer.heightAnchor.pin(to: bottomSpacer.heightAnchor)
    }

    @objc private func signIn() {
        set(isLoading: true)
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.performRequests()
    }

    private func set(isLoading: Bool) {
        appleButton.isLoading = isLoading
        appleButton.isEnabled = !isLoading
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        set(isLoading: false)
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let authorization = authorization.credential as? ASAuthorizationAppleIDCredential,
            let identity = authorization.identityToken else
        {
            fatalError()
        }

        LoginController.shared.attemptLogin(identity: identity) { [weak self] result in
            guard let self = self else {
                return
            }

            switch result {
            case .failed(let error):
                self.set(isLoading: false)
                self.placeholder(title: "Something went wrong", message: String(describing: error))
            case .noAccountFound:
                self.signUp(identity: identity)
            case .success(let user):
                self.handleLogin(user: user)
            }
        }
    }

    private func signUp(identity: Data) {
        LoginController.shared.signUp(identity: identity) { [weak self] result in
            guard let self = self else {
                return
            }

            switch result {
            case .failed(let error):
                self.set(isLoading: false)
                self.placeholder(title: "Something went wrong", message: String(describing: error))
            case .success(let user):
                self.handleLogin(user: user)
            }
        }
    }

    private func handleLogin(user: User) {
        if !user.hasCompletedPlaidLink {
            let viewController = LinkPlaidViewController()
            self.show(viewController, sender: self)
        }
    }
}

func + (left: NSAttributedString, right: NSAttributedString) -> NSAttributedString {
    let result = NSMutableAttributedString()
    result.append(left)
    result.append(right)
    return result
}
