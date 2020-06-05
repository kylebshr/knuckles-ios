import LinkKit
import UIKit

class LinkPlaidViewController: ViewController {

    private let linkButton = Button(title: "Link bank account")

    override func viewDidLoad() {
        super.viewDidLoad()

        view.layoutMargins.bottom = 20

        let titleLabel = UILabel(font: .rubik(ofSize: 24, weight: .medium))
        titleLabel.text = "Link your bank account"
        titleLabel.numberOfLines = 0

        let descriptionLabel = UILabel(font: .rubik(ofSize: 16, weight: .regular), color: .secondaryLabel)
        descriptionLabel.text = "Balance uses Plaid to connect your bank account and access [insert all the things here]."
        descriptionLabel.numberOfLines = 0

        let disclaimerLabel = UILabel(font: .rubik(ofSize: 14, weight: .regular), color: .secondaryLabel, alignment: .center)
        disclaimerLabel.text = "By signing up you agree to\nour Terms of Services"
        disclaimerLabel.numberOfLines = 0

        linkButton.addTarget(self, action: #selector(linkPlaid), for: .touchUpInside)

        let stackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel, linkButton, disclaimerLabel])
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 30

        stackView.setCustomSpacing(90, after: descriptionLabel)

        view.addSubview(stackView)
        stackView.pinEdges([.left, .right, .bottom], to: view.layoutMarginsGuide)

        linkButton.widthAnchor.pin(to: view.widthAnchor, constant: -40)
        titleLabel.widthAnchor.pin(to: view.widthAnchor, constant: -60)
        descriptionLabel.widthAnchor.pin(to: view.widthAnchor, constant: -60)
        disclaimerLabel.widthAnchor.pin(to: view.widthAnchor, constant: -60)

        let shapeView = ShapeView()
        view.addSubview(shapeView)
        shapeView.pinEdges([.left, .right, .top], to: view)
        shapeView.bottomAnchor.pin(to: stackView.topAnchor, constant: -30)
    }

    @objc private func linkPlaid() {
        let configuration = PLKConfiguration(key: Environment.plaidPublicKey,
                                             env: Environment.current.plaidEnvironment,
                                             product: .transactions)
        configuration.webhook = Environment.current.baseURL.appendingPathComponent("plaid_webhook")

        let viewController = PLKPlaidLinkViewController(configuration: configuration, delegate: self)
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true, completion: nil)
    }

    private func set(isLoading: Bool) {
        linkButton.isLoading = isLoading
        linkButton.isEnabled = !isLoading
    }
}

extension LinkPlaidViewController: PLKPlaidLinkViewDelegate {
    func linkViewController(_ linkViewController: PLKPlaidLinkViewController,
                            didSucceedWithPublicToken publicToken: String,
                            metadata: [String: Any]?)
    {
        dismiss(animated: true, completion: nil)
        set(isLoading: true)

        let token = PlaidPublicToken(value: publicToken)

        ResourceProvider.shared.createResource(token, at: "link_plaid_token") { [weak self] (result: Result<User, Error>) in
            guard let self = self else { return }
            self.set(isLoading: false)

            switch result {
            case .success(let user):
                UserDefaults.standard.update(user: user)
            case .failure(let error):
                self.placeholder(title: "Error saving plaid token", message: error.localizedDescription)
            }
        }
    }

    func linkViewController(_ linkViewController: PLKPlaidLinkViewController,
                            didExitWithError error: Error?,
                            metadata: [String: Any]?)
    {
        dismiss(animated: true, completion: nil)
    }
}
