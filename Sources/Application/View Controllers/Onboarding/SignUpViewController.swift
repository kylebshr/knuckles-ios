import AuthenticationServices
import UIKit

class SignUpViewController: ViewController {

    private let continueButton = Button(title: "→")
    private let circleView = UIView()
    private let textField = TextField()

    private let identity: Data
    private let fullName: String
    private let completion: ((Bool) -> Void)?

    override var firstResponder: UIResponder? { textField }

    init(identity: Data, fullName: String, completion: ((Bool) -> Void)?) {
        self.identity = identity
        self.fullName = fullName
        self.completion = completion
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.clipsToBounds = true

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(self.cancel))
        navigationItem.hidesBackButton = true

        let circleBottomGuide = UILayoutGuide()
        view.addLayoutGuide(circleBottomGuide)
        circleBottomGuide.bottomAnchor.pin(to: view.bottomAnchor)
        circleBottomGuide.heightAnchor.pin(to: view.heightAnchor, multiplier: 0.365)

        view.addSubview(circleView)

        circleView.backgroundColor = .customBlue
        circleView.heightAnchor.pin(to: circleView.widthAnchor)
        circleView.centerXAnchor.pin(to: view.centerXAnchor, constant: -60 - UIScreen.main.bounds.width)
        circleView.widthAnchor.pin(to: view.widthAnchor, multiplier: 2.15)
        circleView.bottomAnchor.pin(to: circleBottomGuide.topAnchor)

        textField.placeholder = "Username"
        textField.font = .systemFont(ofSize: 24, weight: .black)
        textField.insets = UIEdgeInsets(vertical: 24, horizontal: 12 * 2)
        textField.enablesReturnKeyAutomatically = true
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.returnKeyType = .go
        textField.delegate = self

        let topSpace = UIView()
        let bottomSpace = UIView()

        let stackedViews = [topSpace, bottomSpace]
        let stack = UIStackView(arrangedSubviews: stackedViews)
        stack.axis = .vertical

        let textFieldContainer = UIView()
        textFieldContainer.backgroundColor = .secondarySystemBackground
        textFieldContainer.addSubview(textField)
        textField.pinEdges(to: textFieldContainer.safeAreaLayoutGuide)

        view.addSubview(stack)
        view.addSubview(textFieldContainer)
        view.addSubview(continueButton)

        stack.pinEdges([.left, .top, .right], to: view.safeAreaLayoutGuide, insets: .init(vertical: 0, horizontal: 44))
        topSpace.heightAnchor.pin(to: bottomSpace.heightAnchor, multiplier: 0.6)
        textFieldContainer.pinEdges([.left, .bottom, .right], to: keyboardLayoutGuide)
        textFieldContainer.topAnchor.pin(to: stack.bottomAnchor)

        continueButton.addTarget(self, action: #selector(continueTapped), for: .touchUpInside)
        continueButton.pinEdges([.top, .bottom, .right], to: textField, insets: .init(vertical: 8, horizontal: 12 * 2))
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        circleView.layer.cornerRadius = circleView.bounds.midY
    }

    @objc private func cancel() {
        let sheet = UIAlertController(title: "Are you sure?", message: "You’re almost done!", preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Cancel sign up", style: .destructive, handler: { _ in
            self.completion?(false)
            self.dismissAnimated()
        }))
        sheet.addAction(UIAlertAction(title: "Nevermind", style: .cancel, handler: nil))
        present(sheet, animated: true)
    }

    @objc private func continueTapped() {
        guard let text = textField.text, !text.isEmpty else {
            return
        }

        signUp(username: text)
        textField.resignFirstResponder()
    }

    private func signUp(username: String) {
        set(isLoading: true)

        LoginController.shared.signUp(identity: identity, meta: SignUpRequest(name: fullName, username: username)) { [weak self] result in
            guard let self = self else {
                return
            }

            switch result {
            case .failed:
                self.set(isLoading: false)
                self.placeholder(message: "Something went wrong")
            case .noAccountFound:
                fatalError()
            case .success:
                self.dismiss(animated: true, completion: nil)
                self.completion?(true)
            }
        }
    }

    private func set(isLoading: Bool) {
        continueButton.isLoading = isLoading
        textField.isUserInteractionEnabled = !isLoading
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        continueTapped()
        return true
    }
}
