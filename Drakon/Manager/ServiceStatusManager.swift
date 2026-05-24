//
//  ServiceStatusManager.swift
//  Drakon
//
//  Created by Tufan Cakir on 23.05.26.
//

import Combine
import Foundation

final class ServiceStatusManager: ObservableObject {
    static let shared = ServiceStatusManager()

    @Published private(set) var status = ServiceStatusRoot(
        maintenance: nil,
        announcements: []
    )

    private init() {}

    func refresh() {
        status = ServiceStatusLoader.load()
    }

    var activeMaintenance: MaintenanceWindow? {
        status.maintenance?.isActive == true ? status.maintenance : nil
    }

    var activeAnnouncements: [ServiceAnnouncement] {
        status.announcements.filter(\.isActive)
    }
}
