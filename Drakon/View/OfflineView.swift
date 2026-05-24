//
//  OfflineView.swift
//  Drakon
//
//  Created by Tufan Cakir on 23.05.26.
//

import SwiftUI

struct OfflineView: View {
    @ObservedObject private var network = NetworkMonitor.shared
    @State private var scanOffset: CGFloat = -120

    var body: some View {
        ZStack {
            DrakonScreenBackground()

            VStack(spacing: 22) {
                Spacer()

                statusMark

                VStack(spacing: 9) {
                    Text("REMOTE LOST")
                        .font(
                            .system(size: 31, weight: .black, design: .rounded)
                        )
                        .foregroundStyle(.white)
                        .tracking(1.2)

                    Text("DRAKON BRAUCHT EINE AKTIVE VERBINDUNG")
                        .font(
                            .system(size: 12, weight: .black, design: .rounded)
                        )
                        .foregroundStyle(DrakonBladePalette.mutedText)
                        .multilineTextAlignment(.center)
                }

                connectionPanel

                retryButton

                Spacer()
            }
            .padding(24)
        }
        .onAppear {
            scanOffset = 120
        }
        .animation(
            .linear(duration: 1.15).repeatForever(autoreverses: false),
            value: scanOffset
        )
    }

    private var statusMark: some View {
        ZStack {
            DrakonBladeShape(pointDepth: 42, slant: 18)
                .stroke(DrakonBladePalette.gold, lineWidth: 3)
                .frame(width: 164, height: 116)

            DrakonBladeShape(pointDepth: 38, slant: 16)
                .stroke(DrakonBladePalette.blue, lineWidth: 2)
                .frame(width: 132, height: 90)
                .offset(x: scanOffset)
                .mask(
                    DrakonBladeShape(pointDepth: 42, slant: 18)
                        .frame(width: 164, height: 116)
                )

            RemoteAssetImage(name: "drakon_icon")
                .scaledToFit()
                .frame(width: 78, height: 78)
                .opacity(network.isChecking ? 0.45 : 1)

            if network.isChecking {
                ProgressView()
                    .tint(DrakonBladePalette.gold)
                    .scaleEffect(1.2)
            }
        }
    }

    private var connectionPanel: some View {
        VStack(spacing: 12) {
            HStack {
                Text("STATUS")
                    .font(.system(size: 11, weight: .black, design: .rounded))
                    .foregroundStyle(DrakonBladePalette.gold)

                Spacer()

                Text(network.isChecking ? "CHECKING" : "OFFLINE")
                    .font(.system(size: 11, weight: .black, design: .rounded))
                    .foregroundStyle(
                        network.isChecking ? DrakonBladePalette.blue : .red
                    )
            }

            Rectangle()
                .fill(DrakonBladePalette.gold.opacity(0.75))
                .frame(height: 2)

            Text(
                "Remote JSONs und Assets koennen gerade nicht synchronisiert werden."
            )
            .font(.system(size: 12, weight: .bold, design: .rounded))
            .foregroundStyle(DrakonBladePalette.mutedText)
            .multilineTextAlignment(.center)
        }
        .padding(16)
        .background(DrakonBladePalette.panel)
        .clipShape(DrakonCutRectangle(cut: 18))
        .overlay(
            DrakonCutRectangle(cut: 18)
                .stroke(DrakonBladePalette.blue, lineWidth: 1.6)
        )
    }

    private var retryButton: some View {
        Button {
            network.checkConnection()
        } label: {
            HStack(spacing: 10) {
                if network.isChecking {
                    ProgressView()
                        .tint(DrakonBladePalette.black)
                }

                Text(network.isChecking ? "PRUEFE REMOTE" : "ERNEUT PRUEFEN")
                    .font(.system(size: 15, weight: .black, design: .rounded))
                    .foregroundStyle(DrakonBladePalette.black)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 58)
            .background(DrakonBladePalette.gold)
            .clipShape(DrakonBladeShape(pointDepth: 30, slant: 15))
            .overlay(
                DrakonBladeShape(pointDepth: 30, slant: 15)
                    .stroke(DrakonBladePalette.blue, lineWidth: 1.6)
            )
        }
        .buttonStyle(.plain)
        .disabled(network.isChecking)
        .opacity(network.isChecking ? 0.72 : 1)
    }
}

#Preview {
    OfflineView()
}
