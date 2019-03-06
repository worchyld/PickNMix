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

class PageViewModel {
    private let entityModel : RootEntity

    init(model: RootEntity) {
        self.entityModel = model
    }

    /*
    private struct Mix {
        var industries: [String]
        var businesses: [String]
        var triggers: [String]

        lazy var randomIndustry: String? = {
            // Shuffle using Gameplaykit
            let shuffled = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: industries)
            guard let first = shuffled.first else {
                return nil
            }
            return first as? String
        }()

        lazy var randomBusinessModel: String? = {
            // Shuffle using Gameplaykit
            let shuffled = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: businesses)
            guard let first = shuffled.first else {
                return nil
            }
            return first as? String
        }()

        lazy var randomTrigger: String? = {
            // Shuffle using Gameplaykit
            let shuffled = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: triggers)
            guard let first = shuffled.first else {
                return nil
            }
            return first as? String
        }()
    }

    func populate() {
        guard let industries = entityModel.industries else {
            return
        }
        guard let triggers = entityModel.triggers else {
            return
        }
        guard let businessModels = entityModel.businessModels else {
            return
        }

        for industry in industries {
            self.mix?.industries.append(industry.name)
        }

        for trigger in triggers {
            self.mix?.triggers.append(trigger.name)
        }

        for business in businessModels {
            self.mix?.businesses.append(business.name)
        }
    }
 */
}

extension PageViewModel : CustomStringConvertible {
    var description: String {
        return ("description: \(self.entityModel.description)")
    }
}

class ViewController: UIViewController, UIScrollViewDelegate {

    lazy var refreshCtrl: UIRefreshControl = {
        let ctrl = UIRefreshControl()
        ctrl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        return ctrl
    }()

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnGenerate: UIButton!

    private var model: PageViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.model = PageViewModel(model: RootEntity())

        print (Realm.Configuration.defaultConfiguration.fileURL as Any)

        reloadData()
    }

    @IBAction func btnGenerateDidPress(_ sender: UIButton) {
        print("btnGenerateDidPress:")
    }

    @objc func reloadData() {
        // Move to a background thread to do some long running work
        SVProgressHUD.show()
        DispatchQueue.global(qos: .userInitiated).async {

            PickMixAPI.getData({ (success, error, rootEntity) in
                if (success == false || error != nil || rootEntity == nil) {
                    print (error?.localizedDescription as Any)
                }
                else {
                    guard let rootEntity = rootEntity else {
                        SVProgressHUD.dismiss()
                        self.refreshCtrl.endRefreshing()
                        return
                    }
                    self.model = PageViewModel.init(model: rootEntity)
                }
            })
            
            // Bounce back to the main thread to update the UI
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                self.refreshCtrl.endRefreshing()
                print("Bounce back: \(self.model.description)")
            }
        }
    }


}

