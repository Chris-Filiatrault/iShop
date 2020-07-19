//
//  NavigationConfigurator.swift
//  iShop
//
//  Created by Chris Filiatrault on 17/5/20.
//  Copyright © 2020 Chris Filiatrault. All rights reserved.
//

import SwiftUI

// For changing nav bar colours & font
struct NavigationConfigurator: UIViewControllerRepresentable {
    var configure: (UINavigationController) -> Void = { _ in }

    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
        UIViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
        if let nc = uiViewController.navigationController {
            self.configure(nc)
        }
    }
   
}
