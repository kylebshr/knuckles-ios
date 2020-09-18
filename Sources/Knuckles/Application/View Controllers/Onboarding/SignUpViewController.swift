import AuthenticationServices
import UIKit

class SignUpViewController: ViewController {

    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    private let textField = TextField()

    private let identity: Data
    private let name: PersonNameComponents?

    init(identity: Data, name: PersonNameComponents?) {
        self.identity = identity
        self.name = name
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let formatter = PersonNameComponentsFormatter()
        formatter.style = .short
        textField.text = name.flatMap(formatter.string)

        textField.placeholder = "First name only is 👌"
        textField.insets = .zero
        textField.font = .systemFont(ofSize: 20, weight: .regular)
        textField.enablesReturnKeyAutomatically = true
        textField.autocapitalizationType = .words
        textField.returnKeyType = .go
        textField.delegate = self

        textField.addSubview(activityIndicator)
        activityIndicator.trailingAnchor.pin(to: textField.trailingAnchor)
        activityIndicator.centerYAnchor.pin(to: textField.centerYAnchor)

        let label = UILabel(font: .systemFont(ofSize: 38, weight: .bold))
        label.text = "What’s your name?"

        let stackView = UIStackView(arrangedSubviews: [label, textField])
        stackView.axis = .vertical
        stackView.spacing = 30
        stackView.alignment = .fill
        stackView.distribution = .fill

        view.addSubview(stackView)
        stackView.pinEdges([.left, .right], to: view.layoutMarginsGuide)
        stackView.bottomAnchor.pin(to: keyboardLayoutGuide.bottomAnchor, constant: -40)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textField.becomeFirstResponder()
    }

    @objc private func continueTapped() {
        guard let text = textField.text, !text.isEmpty else {
            return
        }

        signUp(name: text)
        textField.resignFirstResponder()
    }

    private func signUp(name: String) {
        set(isLoading: true)

        LoginController.shared.signUp(identity: identity) { [weak self] result in
            guard let self = self else {
                return
            }

            switch result {
            case .failed:
                self.set(isLoading: false)
                self.placeholder(message: "Something went wrong")
            case .success(let user):
                if !user.hasCompletedPlaidLink {
                    let viewController = LinkPlaidViewController()
                    self.show(viewController, sender: self)
                }
            }
        }
    }

    private func set(isLoading: Bool) {
        isLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        textField.isUserInteractionEnabled = !isLoading
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        continueTapped()
        return true
    }
}
