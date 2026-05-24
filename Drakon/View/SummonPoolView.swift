//
//  SummonPoolView.swift
//  Drakon
//
//  Created by Tufan Cakir on 23.05.26.
//

import SwiftUI

struct SummonPoolView: View {
    let banner: SummonBanner
    let rates: [CharacterRate]

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    header

                    LazyVStack(spacing: 10) {
                        ForEach(rates) { entry in
                            poolRow(entry)
                        }
                    }
                }
                .padding(18)
                .padding(.bottom, 24)
            }
            .scrollIndicators(.hidden)
            .background(DrakonScreenBackground())
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 13, weight: .black))
                            .foregroundStyle(.white)
                            .frame(width: 34, height: 34)
                            .background(DrakonBladePalette.panel)
                            .clipShape(
                                DrakonBladeShape(pointDepth: 10, slant: 6)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var header: some View {
        HStack(spacing: 14) {
            RemoteAssetImage(name: banner.bannerImage)
                .scaledToFit()
                .frame(width: 86, height: 86)

            VStack(alignment: .leading, spacing: 7) {
                Text(banner.title.uppercased())
                    .font(.system(size: 20, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
                    .lineLimit(2)
                    .minimumScaleFactor(0.72)

                Text("\(rates.count) DRAGONS IM POOL")
                    .font(.system(size: 11, weight: .black, design: .rounded))
                    .foregroundStyle(DrakonBladePalette.gold)

                Text("Rates sind normalisiert und enthalten RateUp.")
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .foregroundStyle(DrakonBladePalette.mutedText)
            }

            Spacer(minLength: 0)
        }
        .padding(16)
        .background(DrakonBladePalette.panel)
        .clipShape(DrakonCutRectangle(cut: 18))
        .overlay(
            DrakonCutRectangle(cut: 18)
                .stroke(DrakonBladePalette.gold, lineWidth: 1.6)
        )
    }

    private func poolRow(_ entry: CharacterRate) -> some View {
        let character = entry.character

        return HStack(spacing: 12) {
            RemoteAssetImage(name: character.sprite)
                .scaledToFit()
                .frame(width: 62, height: 62)

            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 7) {
                    Text(character.name.uppercased())
                        .font(
                            .system(size: 14, weight: .black, design: .rounded)
                        )
                        .foregroundStyle(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.72)

                    if entry.isRateUp {
                        Text("RATE UP")
                            .font(
                                .system(
                                    size: 8,
                                    weight: .black,
                                    design: .rounded
                                )
                            )
                            .foregroundStyle(DrakonBladePalette.black)
                            .padding(.horizontal, 6)
                            .frame(height: 18)
                            .background(DrakonBladePalette.gold)
                            .clipShape(
                                DrakonBladeShape(pointDepth: 6, slant: 4)
                            )
                    }
                }

                HStack(spacing: 8) {
                    Text(character.rarity.rawValue.uppercased())
                        .foregroundStyle(character.rarity.color)

                    Text(DrakonElement.parse(character.energyType).title)
                        .foregroundStyle(DrakonBladePalette.blue)
                }
                .font(.system(size: 10, weight: .black, design: .rounded))
            }

            Spacer(minLength: 0)

            VStack(alignment: .trailing, spacing: 3) {
                Text(entry.ratePercent)
                    .font(.system(size: 17, weight: .black, design: .rounded))
                    .foregroundStyle(DrakonBladePalette.gold)

                Text("DROP")
                    .font(.system(size: 9, weight: .black, design: .rounded))
                    .foregroundStyle(DrakonBladePalette.mutedText)
            }
        }
        .padding(12)
        .background(DrakonBladePalette.panel)
        .clipShape(DrakonCutRectangle(cut: 14))
        .overlay(
            DrakonCutRectangle(cut: 14)
                .stroke(
                    entry.isRateUp
                        ? DrakonBladePalette.gold
                        : DrakonBladePalette.blue.opacity(0.72),
                    lineWidth: 1.3
                )
        )
    }
}

extension CharacterRate {
    var ratePercent: String {
        String(format: "%.2f%%", rate * 100)
    }
}
