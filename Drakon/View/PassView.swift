//
//  PassView.swift
//  Drakon
//
//  Created by Tufan Cakir on 23.05.26.
//

import SwiftUI

struct PassView: View {
    @EnvironmentObject private var appModel: AppModel
    @ObservedObject private var progress = PassProgressManager.shared

    @State private var config = PassLoader.load()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                header

                if let config {
                    ForEach(config.tiers) { tier in
                        tierRow(tier, config: config)
                    }
                } else {
                    Text("pass_rewards.json fehlt")
                        .font(
                            .system(size: 15, weight: .bold, design: .rounded)
                        )
                        .foregroundStyle(DrakonBladePalette.mutedText)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 80)
                }
            }
            .padding(20)
            .padding(.bottom, 24)
        }
        .scrollIndicators(.hidden)
        .background(DrakonScreenBackground())
        .navigationTitle("BabyPass")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            config = PassLoader.load()
        }
    }

    private var header: some View {
        HStack(spacing: 14) {
            RemoteAssetImage(name: config?.icon ?? "drakon_icon")
                .scaledToFit()
                .frame(width: 70, height: 70)

            VStack(alignment: .leading, spacing: 5) {
                Text((config?.title ?? "BABYPASS").uppercased())
                    .font(.system(size: 26, weight: .black, design: .rounded))
                    .foregroundStyle(.white)

                Text("PROGRESS \(progress.points)")
                    .font(.system(size: 12, weight: .black, design: .rounded))
                    .foregroundStyle(DrakonBladePalette.gold)
            }
        }
    }

    private func tierRow(_ tier: PassTier, config: PassConfig) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("TIER \(tier.tier)")
                .font(.system(size: 13, weight: .black, design: .rounded))
                .foregroundStyle(DrakonBladePalette.gold)

            HStack(spacing: 12) {
                rewardBox(
                    tier.free,
                    tier: tier.tier,
                    lane: "free",
                    config: config
                )
                rewardBox(
                    tier.premium,
                    tier: tier.tier,
                    lane: "premium",
                    config: config
                )
            }
        }
        .padding(14)
        .background(DrakonBladePalette.panel)
        .overlay(
            DrakonCutRectangle(cut: 16)
                .stroke(DrakonBladePalette.blue, lineWidth: 1.4)
        )
        .clipShape(DrakonCutRectangle(cut: 16))
    }

    private func rewardBox(
        _ reward: PassReward?,
        tier: Int,
        lane: String,
        config: PassConfig
    ) -> some View {
        let claimed = progress.isClaimed(tier: tier, lane: lane)
        let canClaim = progress.canClaim(
            tier: tier,
            pointsPerTier: config.pointsPerTier,
            lane: lane
        )

        return Button {
            guard let reward, canClaim else { return }
            RewardApplier.apply(
                type: reward.type,
                amount: reward.amount,
                characterId: reward.characterId,
                eggId: reward.eggId,
                skinId: reward.skinId,
                teamManager: appModel.teamManager
            )
            progress.claim(tier: tier, lane: lane)
        } label: {
            VStack(spacing: 7) {
                Text(lane.uppercased())
                    .font(.system(size: 9, weight: .black, design: .rounded))
                    .foregroundStyle(
                        lane == "premium"
                            ? DrakonBladePalette.gold : DrakonBladePalette.blue
                    )

                Text(reward?.title.uppercased() ?? "EMPTY")
                    .font(.system(size: 12, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.72)

                Text(claimed ? "CLAIMED" : (canClaim ? "CLAIM" : "LOCKED"))
                    .font(.system(size: 10, weight: .black, design: .rounded))
                    .foregroundStyle(
                        canClaim
                            ? DrakonBladePalette.black
                            : DrakonBladePalette.mutedText
                    )
                    .frame(height: 26)
                    .frame(maxWidth: .infinity)
                    .background(
                        canClaim
                            ? DrakonBladePalette.gold : DrakonBladePalette.black
                    )
                    .clipShape(DrakonBladeShape(pointDepth: 12, slant: 7))
            }
            .padding(10)
            .frame(maxWidth: .infinity)
            .frame(height: 118)
            .background(DrakonBladePalette.panelLight)
            .clipShape(DrakonCutRectangle(cut: 12))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    PassView()
        .environmentObject(AppModel())
}
