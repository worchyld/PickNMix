//
//  ViewController.swift
//  PickNMix
//
//  Created by Amarjit on 01/03/2019.
//  Copyright © 2019 Amarjit. All rights reserved.
//

import UIKit
import SVProgressHUD

class ViewController: UIViewController, UIScrollViewDelegate {

    lazy var refreshCtrl: UIRefreshControl = {
        let ctrl = UIRefreshControl()
        ctrl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        return ctrl
    }()

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnGenerate: UIButton!

    //private var model: PageViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()


        reloadData()
    }

    @IBAction func btnGenerateDidPress(_ sender: UIButton) {
        print("btnGenerateDidPress:")
    }

    @objc func reloadData() {
        // Move to a background thread to do some long running work
        SVProgressHUD.show()
        DispatchQueue.global(qos: .userInitiated).async {

            PickMixAPI.makeRequest()

            // Bounce back to the main thread to update the UI
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                self.refreshCtrl.endRefreshing()
            }
        }
    }


}

