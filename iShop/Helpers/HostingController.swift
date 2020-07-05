//
//  HostingController.swift
//  iShop
//
//  Created by Chris Filiatrault on 18/5/20.
//  Copyright © 2020 Chris Filiatrault. All rights reserved.

import SwiftUI

class HostingController<Home>: UIHostingController<Home> where Home : View {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}


