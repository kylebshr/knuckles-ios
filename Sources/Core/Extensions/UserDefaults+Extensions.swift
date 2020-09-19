//
//  UserDefaults+Extensions.swift
//  Knuckles
//
//  Created by Kyle Bashour on 5/22/20.
//

import Foundation

extension UserDefaults {

    private static let encoder = JSONEncoder()
    private static let decoder = JSONDecoder()

    static let shared = UserDefaults(suiteName: "group.com.kylebashour.knuckles")!

    func codable<T: Codable>(forKey key: String) -> T? {
        guard let data = data(forKey: key) else {
            return nil
        }

        guard let decoded = try? Self.decoder.decode(T.self, from: data) else {
            return nil
        }

        return decoded
    }

    func set<T: Codable>(codable value: T, forKey key: String) {
        guard let data = try? Self.encoder.encode(value) else {
            return
        }

        set(data, forKey: key)
    }

    @objc var expenses: [Expense] {
        get { codable(forKey: #function) ?? [] }
        set { set(codable: newValue, forKey: #function) }
    }

    var goals: [Goal] {
        get { codable(forKey: #function) ?? [] }
        set { set(codable: newValue, forKey: #function) }
    }

    var balance: Decimal {
        get { codable(forKey: #function) ?? 0 }
        set { set(codable: newValue, forKey: #function) }
    }

    @objc private(set) var authenticationToken: String? {
        get { string(forKey: "authtoken") }
        set { set(newValue, forKey: "authtoken") }
    }

    @objc private(set) var loggedInUser: User? {
        get { codable(forKey: "user") }
        set { set(codable: newValue, forKey: "user") }
    }

    func login(token: UserToken) {
        loggedInUser = token.user
        authenticationToken = token.value
    }

    func update(user: User) {
        self.loggedInUser = user
    }

    func logout() {
        loggedInUser = nil
        authenticationToken = nil
    }

    func updateUser(_ user: User) {
        loggedInUser = user
    }
}
