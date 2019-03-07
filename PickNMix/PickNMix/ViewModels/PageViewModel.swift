//
//  PageViewModel
//  PickNMix
//
//  Created by Amarjit on 01/03/2019.
//  Copyright © 2019 Amarjit. All rights reserved.
//

import Foundation
import GameplayKit
import RealmSwift


struct Record {
    let industry: String
    let business: String
    let trigger: String
}

extension Record : CustomStringConvertible {
    var description: String {
        return ( "\(industry) \(business) \(trigger)" )
    }
}

protocol RecordDelegate {
    func didUpdate(_ record: Record)
}

class PageViewModel {
    public fileprivate (set) var subscribers: [RecordDelegate] = []

    var industries: [String] = [String]()
    var businessModels: [String] = [String]()
    var triggers: [String] = [String]()

    deinit {
        self.removeSubscribers()
    }

    // Shuffle using Gameplaykit
    static func getRandomString(from stringArray: [String]) -> String? {
        let shuffled = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: stringArray)
        guard let first = shuffled.first else {
            return nil
        }
        return first as? String
    }

    func update(with entity: RootEntity?) {
        guard let entity = entity else {
            return
        }

        guard let dbIndustries = entity.industries else {
            return
        }
        guard let dbBusinesses = entity.businessModels else {
            return
        }
        guard let dbTriggers = entity.triggers else {
            return
        }

        self.industries.removeAll()
        self.businessModels.removeAll()
        self.triggers.removeAll()

        dbIndustries.forEach { (industryEntity) in
            self.industries.append(industryEntity.name)
        }
        dbTriggers.forEach { (triggerEntity) in
            self.triggers.append(triggerEntity.name)
        }
        dbBusinesses.forEach { (businessEntity) in
            self.businessModels.append(businessEntity.name)
        }

        guard let randomIndustry = PageViewModel.getRandomString(from: industries) else {
            return
        }
        guard let randomBusiness = PageViewModel.getRandomString(from: businessModels) else {
            return
        }
        guard let randomTrigger = PageViewModel.getRandomString(from: triggers) else {
            return
        }

        let record = Record.init(industry: randomIndustry, business: randomBusiness, trigger: randomTrigger)

        // Notify to update with recordModel
        notifySubscribers(record: record)
    }
}

extension PageViewModel {
    func addSubscriber(_ subscriber: RecordDelegate) {
        self.subscribers.append(subscriber)
    }

    func notifySubscribers(record: Record) {
        let _ = self.subscribers.map({
            $0.didUpdate(record)
        })
    }

    private func removeSubscribers() {
        self.subscribers.removeAll()
    }
}

