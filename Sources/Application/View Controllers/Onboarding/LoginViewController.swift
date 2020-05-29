import AuthenticationServices
import UIKit

class LoginViewController: ViewController {

    private let appleButton = Button(title: "Sign in with Apple")

    override func viewDidLoad() {
        super.viewDidLoad()

        view.layoutMargins.bottom = 20

        let titleLabel = UILabel(font: .rubik(ofSize: 24, weight: .medium))
        titleLabel.text = "Welcome to Balance"
        titleLabel.numberOfLines = 0

        let descriptionLabel = UILabel(font: .rubik(ofSize: 16, weight: .regular), color: .secondaryLabel)
        descriptionLabel.text = "Sign in with Apple to start monitoring your budget."
        descriptionLabel.numberOfLines = 0

        let disclaimerLabel = UILabel(font: .rubik(ofSize: 14, weight: .regular), color: .secondaryLabel, alignment: .center)
        disclaimerLabel.text = "By signing up you agree to\nour Terms of Services"
        disclaimerLabel.numberOfLines = 0

        appleButton.addTarget(self, action: #selector(signIn), for: .touchUpInside)

        let stackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel, appleButton, disclaimerLabel])
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 30

        stackView.setCustomSpacing(90, after: descriptionLabel)

        view.addSubview(stackView)
        stackView.pinEdges([.left, .right, .bottom], to: view.layoutMarginsGuide)

        appleButton.widthAnchor.pin(to: view.widthAnchor, constant: -40)
        titleLabel.widthAnchor.pin(to: view.widthAnchor, constant: -60)
        descriptionLabel.widthAnchor.pin(to: view.widthAnchor, constant: -60)
        disclaimerLabel.widthAnchor.pin(to: view.widthAnchor, constant: -60)

        let shapeView = ShapeView()
        view.addSubview(shapeView)
        shapeView.pinEdges([.left, .right, .top], to: view)
        shapeView.bottomAnchor.pin(to: stackView.topAnchor, constant: -30)
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
                let viewController = SignUpViewController(identity: identity, name: authorization.fullName)
                self.show(viewController, sender: self)
            case .success(let user):
                if !user.hasCompletedPlaidLink {
                    let viewController = LinkPlaidViewController()
                    self.show(viewController, sender: self)
                }
            }
        }
    }
}
