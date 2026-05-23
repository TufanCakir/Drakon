//
//  WardrobeView.swift
//  Drakon
//
//  Created by Tufan Cakir on 24.05.26.
//

import SwiftUI

struct WardrobeView: View {
    @ObservedObject var teamManager: TeamManager
    @ObservedObject private var skinInventory = SkinInventoryManager.shared

    @State private var skins: [DrakonSkinDefinition] = []
    @State private var selectedCharacterId: String?

    private var ownedCharacters: [OwnedCharacter] {
        teamManager.ownedCharacters
    }

    private var activeCharacterId: String? {
        selectedCharacterId ?? ownedCharacters.first?.baseId
    }

    private var visibleSkins: [DrakonSkinDefinition] {
        guard let activeCharacterId else { return [] }
        return skins.filter { $0.characterId == activeCharacterId }
    }

    var body: some View {
        VStack(spacing: 14) {
            characterStrip

            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(visibleSkins) { skin in
                        skinCard(skin)
                    }
                }
                .padding(.horizontal, 18)
                .padding(.bottom, 24)
            }
            .scrollIndicators(.hidden)
        }
        .padding(.top, 18)
        .background(DrakonScreenBackground())
        .navigationTitle("Wardrobe")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            skins = SkinConfigLoader.load().skins
            selectedCharacterId =
                selectedCharacterId ?? ownedCharacters.first?.baseId
        }
    }

    private var characterStrip: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(ownedCharacters) { owned in
                    let selected = activeCharacterId == owned.baseId

                    Button {
                        selectedCharacterId = owned.baseId
                    } label: {
                        VStack(spacing: 5) {
                            RemoteAssetImage(
                                name: SkinInventoryManager.shared.activeImage(
                                    for: owned.base
                                )
                            )
                            .scaledToFit()
                            .frame(width: 54, height: 54)

                            Text(owned.base.name.uppercased())
                                .font(
                                    .system(
                                        size: 9,
                                        weight: .black,
                                        design: .rounded
                                    )
                                )
                                .foregroundStyle(.white)
                                .lineLimit(1)
                                .minimumScaleFactor(0.65)
                        }
                        .frame(width: 92, height: 82)
                        .background(
                            selected
                                ? DrakonBladePalette.gold.opacity(0.25)
                                : DrakonBladePalette.panel
                        )
                        .clipShape(DrakonCutRectangle(cut: 14))
                        .overlay(
                            DrakonCutRectangle(cut: 14)
                                .stroke(
                                    selected
                                        ? DrakonBladePalette.gold
                                        : DrakonBladePalette.blue.opacity(0.65),
                                    lineWidth: 1.5
                                )
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 18)
        }
    }

    private func skinCard(_ skin: DrakonSkinDefinition) -> some View {
        let unlocked = skinInventory.isUnlocked(skin)
        let equipped =
            skinInventory.equippedSkinId(for: skin.characterId) == skin.id

        return HStack(spacing: 14) {
            RemoteAssetImage(name: skin.image)
                .scaledToFit()
                .frame(width: 92, height: 92)
                .opacity(unlocked ? 1 : 0.35)

            VStack(alignment: .leading, spacing: 7) {
                HStack(spacing: 7) {
                    Text(skin.title.uppercased())
                        .font(
                            .system(size: 16, weight: .black, design: .rounded)
                        )
                        .foregroundStyle(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.72)

                    Text(skin.rarity.rawValue.uppercased())
                        .font(
                            .system(size: 8, weight: .black, design: .rounded)
                        )
                        .foregroundStyle(skin.rarity.color)
                }

                Text((skin.description ?? skin.source ?? "Skin").uppercased())
                    .font(.system(size: 10, weight: .black, design: .rounded))
                    .foregroundStyle(DrakonBladePalette.mutedText)
                    .lineLimit(2)

                Button {
                    skinInventory.equip(skin)
                } label: {
                    Text(equipped ? "EQUIPPED" : unlocked ? "EQUIP" : "LOCKED")
                        .font(
                            .system(size: 11, weight: .black, design: .rounded)
                        )
                        .foregroundStyle(
                            unlocked
                                ? DrakonBladePalette.black
                                : DrakonBladePalette.mutedText
                        )
                        .frame(maxWidth: .infinity)
                        .frame(height: 36)
                        .background(
                            unlocked
                                ? DrakonBladePalette.gold
                                : DrakonBladePalette.black
                        )
                        .clipShape(DrakonBladeShape(pointDepth: 14, slant: 8))
                }
                .buttonStyle(.plain)
                .disabled(!unlocked || equipped)
            }

            Spacer(minLength: 0)
        }
        .padding(14)
        .background(DrakonBladePalette.panel)
        .clipShape(DrakonCutRectangle(cut: 18))
        .overlay(
            DrakonCutRectangle(cut: 18)
                .stroke(
                    equipped
                        ? DrakonBladePalette.gold
                        : skin.rarity.color.opacity(0.75),
                    lineWidth: equipped ? 2 : 1.4
                )
        )
    }
}

#Preview {
    WardrobeView(teamManager: TeamManager())
}
