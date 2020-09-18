import LinkKit
import UIKit

class LinkPlaidViewController: ViewController {

    private let linkButton = Button(title: "Link bank account")

    override func viewDidLoad() {
        super.viewDidLoad()

        view.layoutMargins.bottom = 20

        let icon = UIImageView(image: #imageLiteral(resourceName: "plaid-icon"))

        let titleLabel = UILabel(font: .systemFont(ofSize: 38, weight: .bold))
        titleLabel.text = "Link your bank account"
        titleLabel.numberOfLines = 0

        let descriptionLabel = UILabel(font: .systemFont(ofSize: 17), color: .customSecondaryLabel)
        descriptionLabel.text = "Balance uses Plaid to connect to your bank account and access [insert all the things here]."
        descriptionLabel.numberOfLines = 0

        let disclaimerLabel = UILabel(font: .systemFont(ofSize: 14), color: .customSecondaryLabel, alignment: .center)
        disclaimerLabel.text = "By signing up you agree to our Terms of Service"
        disclaimerLabel.numberOfLines = 0

        let disclaimerWrapper = UIView()
        disclaimerWrapper.addSubview(disclaimerLabel)
        disclaimerLabel.pinEdges([.top, .bottom], to: disclaimerWrapper)
        disclaimerLabel.pinCenter(to: disclaimerWrapper)

        linkButton.addTarget(self, action: #selector(linkPlaid), for: .touchUpInside)

        let topSpacer = UIView()
        let bottomSpacer = UIView()

        let stackView = UIStackView(arrangedSubviews: [topSpacer, icon, titleLabel, descriptionLabel, bottomSpacer, linkButton, disclaimerWrapper])
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 16

        view.addSubview(stackView)

        stackView.pinEdges(to: view.layoutMarginsGuide)
        linkButton.widthAnchor.pin(to: stackView.widthAnchor)
        disclaimerWrapper.widthAnchor.pin(to: stackView.widthAnchor)
        disclaimerLabel.widthAnchor.pin(lessThan: stackView.widthAnchor, constant: -60)
        disclaimerLabel.widthAnchor.pin(lessThan: 200)
        topSpacer.heightAnchor.pin(to: bottomSpacer.heightAnchor)
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
                UserDefaults.shared.update(user: user)
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
