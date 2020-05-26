import AuthenticationServices
import UIKit

class LoginViewController: ViewController {

    private let circleView = UIView()
    private let appleButton = Button(title: " Sign in with Apple")
    private let disclosureLabel = UILabel()
    private lazy var stackView = UIStackView(arrangedSubviews: [appleButton, disclosureLabel])

    private let completion: (Bool) -> Void

    init(completion: @escaping (Bool) -> Void) {
        self.completion = completion
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let cancel = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(self.cancel))
        navigationItem.rightBarButtonItem = cancel

        let circleBottomGuide = UILayoutGuide()
        view.addLayoutGuide(circleBottomGuide)
        circleBottomGuide.bottomAnchor.pin(to: view.bottomAnchor)
        circleBottomGuide.heightAnchor.pin(to: view.heightAnchor, multiplier: 0.365)

        view.addSubview(circleView)

        circleView.backgroundColor = .customBlue
        circleView.heightAnchor.pin(to: circleView.widthAnchor)
        circleView.centerXAnchor.pin(to: view.centerXAnchor, constant: -60)
        circleView.widthAnchor.pin(to: view.widthAnchor, multiplier: 2.15)
        circleView.bottomAnchor.pin(to: circleBottomGuide.topAnchor)

        appleButton.addTarget(self, action: #selector(signIn), for: .touchUpInside)

        disclosureLabel.text = "By signing up you agree to our\nTerms of Service"
        disclosureLabel.numberOfLines = 0
        disclosureLabel.textAlignment = .center
        disclosureLabel.textColor = .secondaryLabel

        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.pinEdges([.left, .right], to: view.safeAreaLayoutGuide)
        stackView.bottomAnchor.pin(to: view.safeAreaLayoutGuide.bottomAnchor)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        circleView.layer.cornerRadius = circleView.bounds.midY
    }

    @objc private func signIn() {
        set(isLoading: true)
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.email, .fullName]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.performRequests()
    }

    @objc private func cancel() {
        dismiss(animated: true) {
            self.completion(false)
        }
    }

    private func set(isLoading: Bool) {
        appleButton.isLoading = isLoading
        appleButton.isEnabled = !isLoading
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        set(isLoading: false)
        completion(false)
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let authorization = authorization.credential as? ASAuthorizationAppleIDCredential,
            let identity = authorization.identityToken, let name = authorization.fullName else
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
                let nameFormatter = PersonNameComponentsFormatter()
                let nameString = nameFormatter.string(from: name)
                let viewController = SignUpViewController(identity: identity, fullName: nameString, completion: self.completion)
                self.show(viewController, sender: self)
            case .success:
                self.dismiss(animated: true, completion: nil)
                self.completion(true)
            }
        }
    }
}
