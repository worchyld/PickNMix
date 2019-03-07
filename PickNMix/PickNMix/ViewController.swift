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

        self.lblBusiness.text = record.business
        self.lblTrigger.text = record.trigger
        self.lblIndustry.text = record.industry

        let _ = self.lblOutletCollection.map {
            $0.sizeToFit()
        }
    }


    // MARK: RecordDelegate protocol methods

    func didUpdate(_ record: Record) {
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
