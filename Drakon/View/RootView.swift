//
//  RootView.swift
//  Drakon
//
//  Created by Tufan Cakir on 27.02.26.
//

import SwiftUI

struct RootView: View {

    enum Tab: Hashable { case home, team, summon, shop, exchange, upgrade }

    @EnvironmentObject var appModel: AppModel
    @State private var selectedTab: Tab = .home

    var body: some View {

        GameLayout(selectedTab: $selectedTab) {
            currentView
        }
        .onAppear {
            selectedTab = appModel.selectedTab
        }
        .onChange(of: selectedTab) { _, tab in
            appModel.selectedTab = tab
        }
        .onChange(of: appModel.selectedTab) { _, tab in
            selectedTab = tab
        }
    }
}

extension RootView {

    @ViewBuilder
    var currentView: some View {

        switch selectedTab {

        case .home:
            MenuView()

        case .team:
            TeamView(teamManager: appModel.teamManager)

        case .summon:
            SummonView(teamManager: appModel.teamManager)

        case .shop:
            ShopView()

        case .exchange:
            ExchangeView()

        case .upgrade:
            UpgradeView(teamManager: appModel.teamManager)
        }
    }
}
