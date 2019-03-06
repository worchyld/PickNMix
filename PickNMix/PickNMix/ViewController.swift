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

class PageViewModel {
    private let entityModel : RootEntity
    
    init(model: RootEntity) {
        self.entityModel = model
    }
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

    init(model: PageViewModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

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
                print(self.model.description)
            }
        }
    }


}

