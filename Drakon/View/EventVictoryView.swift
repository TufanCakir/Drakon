//
//  EventVictoryView.swift
//  Drakon
//
//  Created by Tufan Cakir on 23.05.26.
//

import SwiftUI

struct EventVictoryView: View {
    let result: EventVictoryResult
    let onContinue: () -> Void

    var body: some View {
        VStack(spacing: 18) {
            Spacer()

            RemoteAssetImage(name: result.icon)
                .scaledToFit()
                .frame(width: 132, height: 132)

            Text("VICTORY")
                .font(.system(size: 34, weight: .black, design: .rounded))
                .foregroundStyle(DrakonBladePalette.gold)

            Text(result.title.uppercased())
                .font(.system(size: 14, weight: .black, design: .rounded))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)

            VStack(spacing: 10) {
                DrakonRewardLine(
                    title: "COINS",
                    value: result.coins,
                    icon: "evolution_drakon_baby"
                )
                DrakonRewardLine(
                    title: "RUBY",
                    value: result.rubies,
                    icon: "evolution_drakon_rookie"
                )
                DrakonRewardLine(
                    title: "EVENT",
                    value: result.eventTokens,
                    icon: "drakon_icon"
                )
                DrakonRewardLine(
                    title: "DRAKEN",
                    value: result.draken,
                    icon: "icon_draken"
                )
                ForEach(result.eggRewards) { reward in
                    let egg = EggConfigLoader.load().eggs.first {
                        $0.id == reward.eggId
                    }
                    DrakonRewardLine(
                        title: (egg?.title ?? reward.eggId).uppercased(),
                        value: reward.amount,
                        icon: egg?.eggImage ?? "egg_drakon_fire"
                    )
                }
                if let medalId = result.medalId {
                    DrakonRewardLine(
                        title: (result.medalTitle ?? medalId).uppercased(),
                        value: result.medals,
                        icon: result.medalIcon ?? "drakon_icon"
                    )
                }
            }
            .padding(18)
            .frame(maxWidth: .infinity)
            .background(DrakonBladePalette.panel)
            .overlay(
                DrakonCutRectangle(cut: 18)
                    .stroke(DrakonBladePalette.blue, lineWidth: 1.8)
            )
            .clipShape(DrakonCutRectangle(cut: 18))

            Button(action: onContinue) {
                Text("ZURUCK ZUM MENU")
                    .font(.system(size: 15, weight: .black, design: .rounded))
                    .foregroundStyle(DrakonBladePalette.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 58)
                    .background(DrakonBladePalette.gold)
                    .clipShape(DrakonBladeShape(pointDepth: 28, slant: 14))
            }
            .buttonStyle(.plain)

            Spacer()
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(DrakonScreenBackground())
    }

}
