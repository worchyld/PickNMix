//
//  PageViewModel
//  PickNMix
//
//  Created by Amarjit on 01/03/2019.
//  Copyright © 2019 Amarjit. All rights reserved.
//

import Foundation
import Gameplaykit

struct PageViewModel {
	private let industries : [Industry]
	private let triggers : [Trigger]
	private let businesses : [Business]

	init(businesses: [Business], industries: [Industry], triggers: [Trigger]) {
		self.industries = industries
		self.businesses = businesses
		self.triggers = triggers
	}
}

extension PageViewModel {


	// Early attempt at refactor
	// Could this be done with an enum?
	func getRandomObjectFrom(array: Array) -> nil {
		guard array.count > 0 else {
			return nil
		}

		let shuffled = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: array)
		guard let first = shuffled.first else {
			return nil
		}
		return first
	}


	// Older versions

	func getRandomIndustry() -> String? {
		guard industries.count > 0 else {
			return nil
		}
		
		// Shuffle using Gameplaykit
		let shuffled = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: industries)
		guard let first = shuffled.first else {
			return nil
		}
		return first
	}

	func getRandomBusiness() -> String? {
		guard businesses.count > 0 else {
			return nil
		}

		// Shuffle using Gameplaykit
		let shuffled = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: businesses)
		guard let first = shuffled.first else {
			return nil
		}
		return first
	}
	func getRandomTrigger() -> String? {
		guard triggers.count > 0 else {
			return nil
		}

		// Shuffle using Gameplaykit
		let shuffled = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: triggers)
		guard let first = shuffled.first else {
			return nil
		}
		return first
	}

}
