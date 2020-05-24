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

    var expenses: [Expense] {
        get { codable(forKey: #function) ?? [] }
        set { set(codable: newValue, forKey: #function) }
    }
}