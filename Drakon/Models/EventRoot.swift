//
//  EventRoot.swift
//  Drakon
//
//  Created by Tufan Cakir on 23.05.26.
//

struct EventRoot: Codable {
    var categories: [EventCategoryInfo]
    var events: [GameEvent]
}
