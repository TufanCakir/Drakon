//
//  DailyLoginPopupView.swift
//  Drakon
//
//  Created by Tufan Cakir on 23.05.26.
//

import SwiftUI

struct DailyLoginPopupView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var manager = DailyRewardManager.shared

    var body: some View {
        VStack(spacing: 18) {
            RemoteAssetImage(name: "drakon_icon")
                .scaledToFit()
                .frame(width: 86, height: 86)

            VStack(spacing: 5) {
                Text("DAILY LOGIN")
                    .font(.system(size: 24, weight: .black, design: .rounded))
                    .foregroundStyle(.white)

                Text("TAG \(manager.currentDay)")
                    .font(.system(size: 13, weight: .black, design: .rounded))
                    .foregroundStyle(DrakonBladePalette.gold)
            }

            rewardPanel

            Button {
                manager.claim()
                dismiss()
            } label: {
                Text("ABHOLEN")
                    .font(.system(size: 17, weight: .black, design: .rounded))
                    .foregroundStyle(DrakonBladePalette.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 58)
                    .background(DrakonBladePalette.gold)
                    .clipShape(DrakonBladeShape(pointDepth: 28, slant: 14))
            }
            .buttonStyle(.plain)

            Button {
                dismiss()
            } label: {
                Text("SPATER")
                    .font(.system(size: 12, weight: .black, design: .rounded))
                    .foregroundStyle(DrakonBladePalette.mutedText)
            }
            .buttonStyle(.plain)
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(DrakonScreenBackground())
    }

    private var rewardPanel: some View {
        VStack(spacing: 10) {
            if let reward = manager.todaysReward {
                rewardLine(title: "COINS", value: reward.coins)
                rewardLine(title: "RUBY", value: reward.gems)
                rewardLine(title: "EXP", value: reward.exp)
                rewardLine(title: "EVENT", value: reward.corruptedCoins)
            } else {
                Text("Keine Belohnung konfiguriert")
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .foregroundStyle(DrakonBladePalette.mutedText)
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity)
        .background(DrakonBladePalette.panel)
        .overlay(
            DrakonCutRectangle(cut: 18)
                .stroke(DrakonBladePalette.blue, lineWidth: 1.6)
        )
        .clipShape(DrakonCutRectangle(cut: 18))
    }

    @ViewBuilder
    private func rewardLine(title: String, value: Int?) -> some View {
        if let value, value > 0 {
            HStack {
                Text(title)
                    .font(.system(size: 12, weight: .black, design: .rounded))
                    .foregroundStyle(DrakonBladePalette.mutedText)

                Spacer()

                Text("+\(value)")
                    .font(.system(size: 16, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
            }
        }
    }
}

#Preview {
    DailyLoginPopupView()
}
