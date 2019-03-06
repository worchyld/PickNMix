//
//  RootEntity.swift
//  PickNMix
//
//  Created by Amarjit on 06/03/2019.
//  Copyright © 2019 Amarjit. All rights reserved.
//

import Foundation
import RealmSwift

class RootEntity {
    private let _industries : Results<IndustryEntity>?
    private let _businessModels : Results<BusinessEntity>?
    private let _triggers : Results<TriggerEntity>?

    public var industries: Results<IndustryEntity>? {
        return self._industries
    }

    public var businessModels : Results<BusinessEntity>? {
        return self._businessModels
    }

    public var triggers : Results<TriggerEntity>? {
        return self._triggers
    }

    init() {
        self._industries = DBManager.getIndustryEntities()
        self._businessModels = DBManager.getBusinessEntities()
        self._triggers = DBManager.getTriggerEntities()
    }
}

extension RootEntity : CustomStringConvertible {
    var description: String {
        let bmodelsCount: Int = self.businessModels?.count ?? 0
        let triggerCount: Int = self.triggers?.count ?? 0
        let industryCount: Int = self.industries?.count ?? 0

        let text = "Businesses #: \(bmodelsCount) Triggers: #\(triggerCount)  Industries: #\(industryCount)"
        return (text)
    }
}
