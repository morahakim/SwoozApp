//
//  Date+Ext.swift
//  Swooz
//
//  Created by mora hakim on 16/10/23.
//

import Foundation

extension Date {
    static func format(_ date: Date, format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
}
