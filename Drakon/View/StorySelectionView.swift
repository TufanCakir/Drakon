//
//  StorySelectionView.swift
//  Drakon
//
//  Created by Tufan Cakir on 23.05.26.
//

import SwiftUI

struct StorySelectionView: View {
    @EnvironmentObject private var appModel: AppModel

    @State private var config = GameConfigManager.shared.config
    @State private var selectedDifficultyId: String = "normal"

    private var difficulties: [BattleDifficulty] {
        config.battleDifficulties.isEmpty
            ? GameConfig.fallback.battleDifficulties
            : config.battleDifficulties
    }

    private var selectedDifficulty: BattleDifficulty {
        difficulties.first { $0.id == selectedDifficultyId }
            ?? difficulties[0]
    }

    var body: some View {
        VStack(spacing: 14) {
            difficultyBar

            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 14) {
                    ForEach(config.storyChapters) { chapter in
                        chapterCard(chapter)
                    }
                }
                .padding(18)
                .padding(.bottom, 24)
            }
        }
        .background(DrakonScreenBackground())
        .navigationTitle("Story")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            config = GameConfigManager.shared.config
            selectedDifficultyId = difficulties.first?.id ?? "normal"
        }
    }

    private var difficultyBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(difficulties) { difficulty in
                    let selected = selectedDifficultyId == difficulty.id

                    Button {
                        selectedDifficultyId = difficulty.id
                    } label: {
                        Text(difficulty.title.uppercased())
                            .font(
                                .system(
                                    size: 11,
                                    weight: .black,
                                    design: .rounded
                                )
                            )
                            .foregroundStyle(
                                selected ? DrakonBladePalette.black : .white
                            )
                            .padding(.horizontal, 16)
                            .frame(height: 38)
                            .background(
                                selected
                                    ? DrakonBladePalette.gold
                                    : DrakonBladePalette.panel
                            )
                            .clipShape(
                                DrakonBladeShape(pointDepth: 14, slant: 8)
                            )
                            .overlay(
                                DrakonBladeShape(pointDepth: 14, slant: 8)
                                    .stroke(
                                        selected
                                            ? DrakonBladePalette.blue
                                            : DrakonBladePalette.gold
                                                .opacity(0.45),
                                        lineWidth: 1.2
                                    )
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 18)
            .padding(.top, 14)
        }
    }

    private func chapterCard(_ chapter: StoryChapter) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 14) {
                RemoteAssetImage(name: chapter.icon)
                    .scaledToFit()
                    .frame(width: 76, height: 76)
                    .background(DrakonBladePalette.black.opacity(0.58))
                    .clipShape(DrakonCutRectangle(cut: 12))

                VStack(alignment: .leading, spacing: 6) {
                    Text(chapter.title.uppercased())
                        .font(
                            .system(size: 17, weight: .black, design: .rounded)
                        )
                        .foregroundStyle(.white)

                    Text(chapter.description.uppercased())
                        .font(
                            .system(size: 10, weight: .bold, design: .rounded)
                        )
                        .foregroundStyle(DrakonBladePalette.mutedText)
                        .lineLimit(2)

                    Text(
                        "\(selectedDifficulty.title.uppercased())  HP x\(selectedDifficulty.enemyHpMultiplier, specifier: "%.1f")"
                    )
                    .font(.system(size: 10, weight: .black, design: .rounded))
                    .foregroundStyle(DrakonBladePalette.gold)
                }

                Spacer(minLength: 0)
            }

            Text(chapter.storyText)
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .foregroundStyle(.white.opacity(0.78))
                .lineLimit(3)

            rewardStrip(chapter.rewards)

            Button {
                appModel.navigateWithLoading {
                    appModel.startStoryBattle(
                        chapter: chapter,
                        difficulty: selectedDifficulty
                    )
                }
            } label: {
                Text("KAPITEL STARTEN")
                    .font(.system(size: 14, weight: .black, design: .rounded))
                    .foregroundStyle(DrakonBladePalette.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(DrakonBladePalette.gold)
                    .clipShape(DrakonBladeShape(pointDepth: 22, slant: 11))
            }
            .buttonStyle(.plain)
        }
        .padding(16)
        .background(DrakonBladePalette.panel)
        .clipShape(DrakonBladeShape(pointDepth: 32, slant: 14))
        .overlay(
            DrakonBladeShape(pointDepth: 32, slant: 14)
                .stroke(DrakonBladePalette.gold, lineWidth: 1.7)
        )
    }

    private func rewardStrip(_ rewards: EventRewards?) -> some View {
        HStack(spacing: 7) {
            rewardChip("COINS", rewards?.coins, icon: "icon_drakon_coin")
            rewardChip("GEMS", rewards?.gems, icon: "icon_drakon_gem")
            rewardChip("RUBY", rewards?.ruby, icon: "icon_drakon_ruby")
            rewardChip("DRAKEN", rewards?.draken, icon: "icon_draken")
            Spacer(minLength: 0)
        }
    }

    @ViewBuilder
    private func rewardChip(_ title: String, _ value: Int?, icon: String)
        -> some View
    {
        if let value, value > 0 {
            DrakonRewardChip(title: title, value: value, icon: icon)
        }
    }
}

#Preview {
    StorySelectionView()
        .environmentObject(AppModel())
}
