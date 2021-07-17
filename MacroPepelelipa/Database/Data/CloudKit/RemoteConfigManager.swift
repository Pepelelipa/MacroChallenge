//
//  RemoteConfigManager.swift
//  Database
//
//  Created by Pedro Farina on 17/07/21.
//  Copyright © 2021 Pedro Giuliano Farina. All rights reserved.
//

import CloudKit

public class RemoteConfigManager {
    
    private static var records: [CloudKitRemoteConfig] = []
    private static let queue = DispatchQueue(label: "RemoteConfig", qos: .background)
    private static let userDefaults = UserDefaults.standard
    
    private static var isFetching: Bool = false
    private static func fetchValues() {
        guard !isFetching else {
            return
        }
        queue.sync {
            isFetching = true
        }
        DataManager.shared().fetchRemoveConfigs { result in
            if let answer = try? result.get() {
                records = answer
            }
            queue.sync {
                isFetching = false
                executePending()
            }
        }
    }
    private static func executePending() {
        pendingList.forEach { pendingAction in
            pendingAction.action(answerFor(key: pendingAction.key))
        }
        pendingList.removeAll()
    }
    
    private static var pendingList: [(key: String, action: (Bool) -> Void)] = []
    public static func value(forKey key: String, _ completionHandler: @escaping (Bool) -> Void) {
        if records.contains(where: { $0.identifier == key }) {
            completionHandler(answerFor(key: key))
        } else {
            queue.sync {
                pendingList.append((key, completionHandler))
            }
            fetchValues()
        }
    }
    
    private static func answerFor(key: String) -> Bool {
        guard let config = records.first(where: { $0.identifier == key }),
              config.isActive.value == 1 else {
            return false
        }
        let versionKey = "\(key)Ver"
        let executionKey = "\(key)Ex"
        
        let currentVersion = Int64(userDefaults.integer(forKey: versionKey))
        let remoteVersion = config.version.value
        if currentVersion != remoteVersion {
            userDefaults.setValue(remoteVersion, forKeyPath: versionKey)
            userDefaults.setValue(0, forKeyPath: executionKey)
        }
        
        let currentExecution = Int64(userDefaults.integer(forKey: executionKey))
        
        if let maxExecution = config.maxExecutions.value {
            if currentExecution < maxExecution {
                userDefaults.setValue(currentExecution + 1, forKeyPath: executionKey)
                return true
            } else {
                return false
            }
        }
        
        return true
    }
}
