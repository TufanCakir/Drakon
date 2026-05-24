//
//  DrakonDateParser.swift
//  Drakon
//
//  Created by Tufan Cakir on 23.05.26.
//

import Foundation

enum DrakonDateParser {
    static func date(from string: String?) -> Date? {
        guard let string else { return nil }

        if let isoDate = ISO8601DateFormatter().date(from: string) {
            return isoDate
        }

        return germanDateFormatter.date(from: string)
    }

    private static let germanDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "de_DE")
        formatter.timeZone = TimeZone(identifier: "Europe/Berlin")
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        return formatter
    }()
}
