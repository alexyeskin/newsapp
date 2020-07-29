//
//  RootRootViewController.swift
//  NewsApp
//
//  Created by Alexander Eskin on 12.12.2019.
//  Copyright © 2019 PixelPlex. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    var output: RootViewOutput!

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }
}

// MARK: - RootViewInput

extension RootViewController: RootViewInput {
	func setupInitialState() {
  	}
}
