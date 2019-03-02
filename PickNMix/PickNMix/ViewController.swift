//
//  ViewController.swift
//  PickNMix
//
//  Created by Amarjit on 01/03/2019.
//  Copyright © 2019 Amarjit. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {

    lazy var refreshCtrl: UIRefreshControl = {
        let ctrl = UIRefreshControl()
        ctrl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        return ctrl
    }()

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnGenerate: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.scrollView.addSubview(refreshCtrl)
        self.scrollView.sendSubviewToBack(refreshCtrl)

    }

    @IBAction func btnGenerateDidPress(_ sender: UIButton) {
    }

    @objc func reloadData() {
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scrollViewDidScroll...")
    }

}

