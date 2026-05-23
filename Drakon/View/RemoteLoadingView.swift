//
//  RemoteLoadingView.swift
//  Drakon
//
//  Created by Tufan Cakir on 23.05.26.
//

import SwiftUI

struct RemoteLoadingView: View {
    @EnvironmentObject private var appModel: AppModel
    @ObservedObject private var remote = RemoteDownloadManager.shared

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            RemoteAssetImage(name: "drakon_icon")
                .scaledToFit()
                .frame(width: 118, height: 118)

            VStack(spacing: 7) {
                Text("REMOTE LOAD")
                    .font(.system(size: 28, weight: .black, design: .rounded))
                    .foregroundStyle(.white)

                Text(remote.statusText.uppercased())
                    .font(.system(size: 11, weight: .black, design: .rounded))
                    .foregroundStyle(DrakonBladePalette.gold)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
            }

            VStack(spacing: 10) {
                GeometryReader { proxy in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(DrakonBladePalette.black)

                        Rectangle()
                            .fill(DrakonBladePalette.gold)
                            .frame(width: proxy.size.width * remote.progress)
                    }
                }
                .frame(height: 16)
                .overlay(
                    DrakonCutRectangle(cut: 5)
                        .stroke(DrakonBladePalette.blue, lineWidth: 1.5)
                )
                .clipShape(DrakonCutRectangle(cut: 5))

                HStack {
                    Text("\(Int(remote.progress * 100))%")
                    Spacer()
                    Text("\(remote.completedItems) / \(remote.totalItems)")
                    Spacer()
                    Text(remote.formattedBytes(remote.downloadedBytes))
                }
                .font(.system(size: 11, weight: .black, design: .rounded))
                .foregroundStyle(DrakonBladePalette.mutedText)
            }
            .padding(16)
            .background(DrakonBladePalette.panel)
            .clipShape(DrakonCutRectangle(cut: 18))

            VStack(spacing: 11) {
                actionButton(
                    title: "ALLES HERUNTERLADEN",
                    tint: DrakonBladePalette.gold
                ) {
                    remote.downloadAll {
                        appModel.appState = .start
                    }
                }

                actionButton(
                    title: "REMOTE STARTEN",
                    tint: DrakonBladePalette.blue
                ) {
                    remote.preload {
                        appModel.appState = .start
                    }
                }
            }
            .disabled(remote.isLoading)
            .opacity(remote.isLoading ? 0.55 : 1)

            Spacer()
        }
        .padding(22)
        .background(DrakonScreenBackground())
        .onAppear {
            remote.refreshManifest()
            continueIfCached()
        }
    }

    private func continueIfCached() {
        guard remote.hasCompleteCache else { return }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            appModel.appState = .start
        }
    }

    private func actionButton(
        title: String,
        tint: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 15, weight: .black, design: .rounded))
                .foregroundStyle(
                    tint == DrakonBladePalette.gold
                        ? DrakonBladePalette.black : .white
                )
                .frame(maxWidth: .infinity)
                .frame(height: 58)
                .background(tint)
                .clipShape(DrakonBladeShape(pointDepth: 28, slant: 14))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    RemoteLoadingView()
        .environmentObject(AppModel())
}
