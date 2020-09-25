//
//  LogInView.swift
//  Knuckles
//
//  Created by Kyle Bashour on 9/25/20.
//

import SwiftUI

struct LogInView: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Balance")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(.customSecondaryLabel))

                Spacer()
                Text("Please open the app to log in.")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(.emphasis))
                Spacer()
            }
            .padding()

            Spacer()
        }
    }
}
