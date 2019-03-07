//
//  ViewController.swift
//  PickNMix
//
//  Created by Amarjit on 01/03/2019.
//  Copyright © 2019 Amarjit. All rights reserved.
//

import UIKit
import SVProgressHUD
import RealmSwift
import GameplayKit

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

    static func getRandomString(from stringArray: [String]) -> String? {
        // Shuffle using Gameplaykit
        let shuffled = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: stringArray)
        guard let first = shuffled.first else {
            return nil
        }
        return first as? String
    }

    func update(with entity: RootEntity?) {
        guard let entity = entity else {
            print ("No entity")
            return
        }

        guard let dbIndustries = entity.industries else {
            print ("There are no industries on DB")
            return
        }
        guard let dbBusinesses = entity.businessModels else {
            print ("There are no business models on DB")
            return
        }
        guard let dbTriggers = entity.triggers else {
            print ("There are no triggers on DB")
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

        print ("-------")
        print (self.industries)
        print (self.businessModels)
        print (self.triggers)
        print ("-------")

        guard let randomIndustry = PageViewModel.getRandomString(from: industries) else {
            print ("No random industries")
            return
        }
        guard let randomBusiness = PageViewModel.getRandomString(from: businessModels) else {
            print ("No random business")
            return
        }
        guard let randomTrigger = PageViewModel.getRandomString(from: triggers) else {
            print ("No random trigger")
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
        print ("notifySubscribers")
        print (subscribers.count)

        let _ = self.subscribers.map({
            $0.didUpdate(record)
        })
    }

    private func removeSubscribers() {
        self.subscribers.removeAll()
    }

}


class ViewController: UIViewController, UIScrollViewDelegate, RecordDelegate {

    @IBOutlet weak var lblTrigger: UILabel!
    @IBOutlet weak var lblBusiness: UILabel!
    @IBOutlet weak var lblIndustry: UILabel!
    @IBOutlet weak var btnGenerate: UIButton!
    @IBOutlet var lblOutletCollection: [UILabel]!


    private var model : PageViewModel!
    private var record: Record?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.model = PageViewModel()
        self.model.addSubscriber(self)

        print (Realm.Configuration.defaultConfiguration.fileURL as Any)

        reloadData { (success, rootEntity) in
            if (success) {
                self.model.update(with: rootEntity)
            }
        }
    }

    @IBAction func btnGenerateDidPress(_ sender: UIButton) {
        reloadData { (success, rootEntity) in
            if (success) {
                self.model.update(with: rootEntity)
            }
        }
    }

    func updateUI() {
        guard let record = self.record else {
            return
        }
        print ("Updating UI")

        self.lblBusiness.text = record.business
        self.lblTrigger.text = record.trigger
        self.lblIndustry.text = record.industry

        let _ = self.lblOutletCollection.map {
            $0.sizeToFit()
        }
    }


    // MARK: RecordDelegate protocol methods

    func didUpdate(_ record: Record) {
        print ("**protocol method fired**")
        self.record = record
        updateUI()
    }

}

extension ViewController {

    func didEndReloading() {
        SVProgressHUD.dismiss()
    }

    func reloadData(completion: @escaping (Bool, RootEntity?) -> ()) {
        SVProgressHUD.show()

        var rootObj: RootEntity?

        PickMixAPI.getData({ (success, error, rootEntity) in
            self.didEndReloading()

            if (success == false || error != nil || rootEntity == nil) {
                print (error?.localizedDescription as Any)
                completion(false, nil)
            }
            else {
                rootObj = rootEntity
                completion(true, rootObj)
            }
        })

    }

}
