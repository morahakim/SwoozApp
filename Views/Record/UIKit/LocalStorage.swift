//
//  LocalStorage.swift
//  ascenttt
//
//  Created by Aang Muammar Zein on 17/11/23.
//

import Foundation
import UIKit

class LocalStorage {
    func saveColor(_ color: UIColor, forKey key: String) {
        do {
            let colorData = try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false)
            UserDefaults.standard.set(colorData, forKey: key)
        } catch {
            print("Error saving color data: \(error.localizedDescription)")
        }
    }

    func loadColor(forKey key: String) -> UIColor? {
        if let colorData = UserDefaults.standard.data(forKey: key) {
            do {
                if let color = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData) {
                    return color
                }
            } catch {
                print("Error loading color data: \(error.localizedDescription)")
            }
        }
        if key == "Green"{
            saveColor(UIColor.green, forKey: key)
            return loadColor(forKey: key)
        } else if key == "Yellow"{
            saveColor(UIColor.yellow, forKey: key)
            return loadColor(forKey: key)
        } else if key == "Red"{
            saveColor(UIColor.red, forKey: key)
            return loadColor(forKey: key)
        }
        return nil
    }

    func saveSize(_ val: Float, forKey key: String) {
        UserDefaults.standard.set(val, forKey: key)
    }

    func loadSize(forKey key: String) -> Float? {
        let val = UserDefaults.standard.float(forKey: key)
        if val > 0 {
            return val
        }
        if key == "0"{
            saveSize(0.88, forKey: key)
            return loadSize(forKey: key)
        } else if key == "1"{
            saveSize(0.88, forKey: key)
            return loadSize(forKey: key)
        }
        return nil
    }
}
