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

enum ModelType : Int {
    case industry
    case trigger
    case business
}

struct PageViewModel {

    private func clearDB() {
        //let realm = try! Realm()
        //DBManager.clearAll()
    }

}

//
//struct PageViewModel {
//    private let industries : [Industry]
//    private let triggers : [Trigger]
//    private let businesses : [Business]
//
//    init(businesses: [Business], industries: [Industry], triggers: [Trigger]) {
//        self.industries = industries
//        self.businesses = businesses
//        self.triggers = triggers
//    }
//
//    func getRandomItemFor(model: ModelType)  -> String? {
//        switch model {
//        case .business:
//            return self.getRandomBusiness()
//        case .industry:
//            return self.getRandomIndustry()
//        case .trigger:
//            return self.getRandomTrigger()
//        }
//    }
//}
//
//extension PageViewModel {
//
//    // Probably should be refactored
//
//    func getRandomIndustry() -> String? {
//        guard industries.count > 0 else {
//            return nil
//        }
//        
//        // Shuffle using Gameplaykit
//        let shuffled = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: industries)
//        guard let first = shuffled.first else {
//            return nil
//        }
//        return first  as? String
//    }
//
//    func getRandomBusiness() -> String? {
//        guard businesses.count > 0 else {
//            return nil
//        }
//
//        // Shuffle using Gameplaykit
//        let shuffled = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: businesses)
//        guard let first = shuffled.first else {
//            return nil
//        }
//        return first as? String
//    }
//    func getRandomTrigger() -> String? {
//        guard triggers.count > 0 else {
//            return nil
//        }
//
//        // Shuffle using Gameplaykit
//        let shuffled = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: triggers)
//        guard let first = shuffled.first else {
//            return nil
//        }
//        return first as? String
//    }
//
//}
