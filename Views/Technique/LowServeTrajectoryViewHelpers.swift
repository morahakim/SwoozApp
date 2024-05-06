//
//  LowServeTrajectoryViewHelpers.swift
//  ascenttt
//
//  Created by Hanifah BN on 05/05/24.
//

import Foundation
import SwiftUI

class LowServeTrajectoryViewHelpers {
    public func getAverate(_ data: [RecordSkill]) -> Double {
        if data.count == 0 {
            return 0
        } else {
            var total: Double = 0.0
            for element in data {
                total += Double(element.hitPerfect)
            }
            return Double(total/Double(data.count))
        }
    }

    public func getLatestLowest(_ data: FetchedResults<RecordSkill>) -> Double {
        if data.count > 0 {
            return data[0].minDistance
        } else {
            return 0
        }
    }

    public func getLatesAvg(_ data: FetchedResults<RecordSkill>) -> Double {
        if data.count > 0 {
            return data[0].avgDistance
        } else {
            return 0
        }
    }

    public func getMonthBestAvg(_ data: [RecordSkill]) -> Double {
        if data.count > 0 {
            return data[0].avgDistance
        } else {
            return 0
        }
    }

    public func getMonthLowest(_ data: [RecordSkill]) -> Double {
        if data.count > 0 {
            return data[0].minDistance
        } else {
            return 0
        }
    }
}
