//
//  EventView.swift
//  Drakon
//
//  Created by Tufan Cakir on 28.02.26.
//

import SwiftUI

struct EventView: View {
    @EnvironmentObject private var appModel: AppModel
    @EnvironmentObject private var eventManager: EventManager

    @State private var selectedCategory: EventCategory = .boss
    @State private var infoEvent: GameEvent?
    @State private var upgradeConfig = UpgradeConfigLoader.load()

    private var events: [GameEvent] {
        eventManager.events(for: selectedCategory, mode: .island)
    }

    var body: some View {
        VStack(spacing: 14) {
            categoryBar

            ScrollView {
                VStack(spacing: 14) {
                    if events.isEmpty {
                        emptyState
                    } else {
                        ForEach(events) { event in
                            eventCard(event)
                        }
                    }
                }
                .padding(20)
                .padding(.bottom, 24)
            }
            .scrollIndicators(.hidden)
        }
        .background(DrakonScreenBackground())
        .navigationTitle("Events")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            eventManager.load()
            upgradeConfig = UpgradeConfigLoader.load()
        }
        .sheet(item: $infoEvent) { event in
            eventInfoSheet(event)
        }
    }

    private var categoryBar: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 10) {
                ForEach(EventCategory.allCases, id: \.self) { category in
                    Button {
                        selectedCategory = category
                    } label: {
                        Text(eventManager.title(for: category).uppercased())
                            .font(
                                .system(
                                    size: 11,
                                    weight: .black,
                                    design: .rounded
                                )
                            )
                            .foregroundStyle(
                                selectedCategory == category
                                    ? DrakonBladePalette.black : .white
                            )
                            .padding(.horizontal, 16)
                            .frame(height: 38)
                            .background(
                                selectedCategory == category
                                    ? DrakonBladePalette.gold
                                    : DrakonBladePalette.panel
                            )
                            .clipShape(
                                DrakonBladeShape(pointDepth: 16, slant: 8)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 14)
        }
        .scrollIndicators(.hidden)
    }

    private var emptyState: some View {
        VStack(spacing: 14) {
            RemoteAssetImage(name: "drakon_icon")
                .scaledToFit()
                .frame(width: 82, height: 82)
                .opacity(0.7)

            Text("KEINE EVENTS")
                .font(.system(size: 18, weight: .black, design: .rounded))
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 90)
    }

    private func eventCard(_ event: GameEvent) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 14) {
                RemoteAssetImage(name: event.icon ?? "drakon_icon")
                    .scaledToFill()
                    .frame(width: 74, height: 74)
                    .clipShape(DrakonCutRectangle(cut: 12))

                VStack(alignment: .leading, spacing: 5) {
                    Text(event.title.uppercased())
                        .font(
                            .system(size: 17, weight: .black, design: .rounded)
                        )
                        .foregroundStyle(.white)
                        .lineLimit(2)

                    Text((event.description ?? "Event Battle").uppercased())
                        .font(
                            .system(size: 10, weight: .bold, design: .rounded)
                        )
                        .foregroundStyle(DrakonBladePalette.mutedText)
                        .lineLimit(2)
                }

                Spacer()

                Button {
                    infoEvent = event
                } label: {
                    Text("i")
                        .font(
                            .system(size: 14, weight: .black, design: .rounded)
                        )
                        .foregroundStyle(DrakonBladePalette.black)
                        .frame(width: 30, height: 30)
                        .background(DrakonBladePalette.gold)
                        .clipShape(DrakonCutRectangle(cut: 8))
                }
                .buttonStyle(.plain)
            }

            rewardStrip(event)

            Button {
                start(event)
            } label: {
                Text("EVENT BATTLE")
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
        .overlay(
            DrakonBladeShape(pointDepth: 32, slant: 14)
                .stroke(
                    event.category == .boss
                        ? DrakonBladePalette.gold : DrakonBladePalette.blue,
                    lineWidth: 1.8
                )
        )
        .clipShape(DrakonBladeShape(pointDepth: 32, slant: 14))
    }

    private func rewardStrip(_ event: GameEvent) -> some View {
        HStack(spacing: 7) {
            rewardChip(
                "COINS",
                event.rewards?.coins,
                icon: "evolution_drakon_baby"
            )
            rewardChip(
                "RUBY",
                event.rewards?.gems,
                icon: "evolution_drakon_rookie"
            )
            rewardChip("EVENT", event.rewards?.eventToken, icon: "drakon_icon")
            if let medals = event.rewards?.medals,
                let medal = medalDefinition(for: event.rewards?.medalId)
            {
                DrakonRewardChip(
                    title: medal.title,
                    value: medals,
                    icon: medal.icon
                )
            }
            Spacer(minLength: 0)
        }
    }

    @ViewBuilder
    private func rewardChip(_ title: String, _ value: Int?, icon: String)
        -> some View
    {
        if let value {
            DrakonRewardChip(title: title, value: value, icon: icon)
        }
    }

    private func medalDefinition(for medalId: String?) -> DrakonMedalDefinition?
    {
        guard let medalId else { return nil }
        return upgradeConfig.medalDefinitions.first { $0.id == medalId }
    }

    private func eventInfoSheet(_ event: GameEvent) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 14) {
                RemoteAssetImage(name: event.icon ?? "drakon_icon")
                    .scaledToFit()
                    .frame(width: 72, height: 72)

                VStack(alignment: .leading, spacing: 5) {
                    Text(event.title.uppercased())
                        .font(
                            .system(size: 20, weight: .black, design: .rounded)
                        )
                        .foregroundStyle(.white)

                    Text(
                        "ELEMENT \(DrakonElement.parse(event.enemyElement).title)"
                    )
                    .font(.system(size: 11, weight: .black, design: .rounded))
                    .foregroundStyle(DrakonBladePalette.gold)
                }
            }

            Text(event.description ?? "Event Battle")
                .font(.system(size: 13, weight: .bold, design: .rounded))
                .foregroundStyle(DrakonBladePalette.mutedText)

            if let medal = medalDefinition(for: event.rewards?.medalId),
                let medals = event.rewards?.medals
            {
                DrakonRewardLine(
                    title: medal.title.uppercased(),
                    value: medals,
                    icon: medal.icon
                )
            }

            Text(
                "Feuer > Pflanze, Pflanze > Wasser, Wasser > Feuer. Licht und Dunkelheit treffen sich stark."
            )
            .font(.system(size: 12, weight: .bold, design: .rounded))
            .foregroundStyle(DrakonBladePalette.mutedText)

            Spacer()
        }
        .padding(24)
        .background(DrakonScreenBackground())
    }

    private func start(_ event: GameEvent) {
        EventRuntime.shared.activate(event)
        appModel.selectedLevelId = event.bossLevelId ?? event.id
        appModel.appState = .game
    }
}

#Preview {
    NavigationStack {
        EventView()
            .environmentObject(AppModel())
            .environmentObject(EventManager.shared)
    }
}
