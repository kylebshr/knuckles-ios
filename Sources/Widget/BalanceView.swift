//
//  BalanceView.swift
//  Knuckles
//
//  Created by Kyle Bashour on 9/25/20.
//

import SwiftUI

struct BalanceView: View {
    var balance: String
    var showUpNext: Bool
    var upNext: Expense?

    var body: some View {
        let willShowUpNext = showUpNext && upNext != nil

        HStack {
            VStack(alignment: .leading) {
                if !willShowUpNext {
                    Spacer()
                }

                Text("Balance")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(.customSecondaryLabel))
                Text(balance)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(Color(.emphasis))
                    .minimumScaleFactor(0.1)
                    .scaledToFit()
                Spacer()

                if showUpNext, let expense = upNext {
                    Text("Up next")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color(.customSecondaryLabel))
                    Spacer()
                    ZStack {
                        Color(.bubbleBackground)
                            .clipShape(ContainerRelativeShape())
                        HStack {
                            VStack(alignment: .leading) {
                                Text(expense.name)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(Color(.customLabel))
                                Text(DateFormatter.readyByFormatter.string(from: expense.nextDueDate()))
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundColor(Color(.customLabel))
                            }
                            Spacer()
                            Image(systemName: "arrow.up.right")
                                .font(Font.system(size: 16, weight: .semibold))
                                .foregroundColor(.red)
                        }
                        .padding(8)
                    }
                    .padding([.leading, .trailing, .bottom], -8)
                }
            }
            .padding()

            if !willShowUpNext {
                Spacer()
            }
        }
    }
}
