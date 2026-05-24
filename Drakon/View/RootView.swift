//
//  RootView.swift
//  Drakon
//
//  Created by Tufan Cakir on 23.05.26.
//

import SwiftUI

struct RootView: View {

    enum Tab: Hashable { case home, team, summon, shop, exchange, upgrade }

    @EnvironmentObject var appModel: AppModel
    @ObservedObject private var dailyRewardManager = DailyRewardManager.shared
    @State private var selectedTab: Tab = .home
    @State private var showsDailyLogin = false
    @State private var didPresentDailyLoginThisSession = false

    var body: some View {

        GameLayout(selectedTab: $selectedTab) {
            currentView
        }
        .onAppear {
            selectedTab = appModel.selectedTab
            refreshDailyLogin()
        }
        .sheet(isPresented: $showsDailyLogin) {
            DailyLoginPopupView()
        }
        .onChange(of: selectedTab) { _, tab in
            appModel.selectedTab = tab
            refreshDailyLogin()
        }
        .onChange(of: appModel.selectedTab) { _, tab in
            selectedTab = tab
        }
        .onChange(of: appModel.appState) { _, _ in
            refreshDailyLogin()
        }
    }

    private func refreshDailyLogin() {
        guard appModel.appState == .home else { return }
        guard !didPresentDailyLoginThisSession else { return }
        dailyRewardManager.refreshAvailability()
        if dailyRewardManager.canClaimToday {
            showsDailyLogin = true
            didPresentDailyLoginThisSession = true
        }
    }
}

extension RootView {

    @ViewBuilder
    var currentView: some View {

        switch selectedTab {

        case .home:
            NavigationStack {
                MenuView()
            }

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
