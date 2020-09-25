//
//  NavigationConfigurator.swift
//  iShop
//
//  Created by Chris Filiatrault on 17/5/20.
//  Copyright © 2020 Chris Filiatrault. All rights reserved.
//

import SwiftUI

//// For changing nav bar colours & font
//struct NavigationConfigurator: UIViewControllerRepresentable {
//    var configure: (UINavigationController) -> Void = { _ in }
//
//    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
//        UIViewController()
//    }
//    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
//        if let nc = uiViewController.navigationController {
//            self.configure(nc)
//        }
//    }
//   
//}


struct NavigationBarModifier: ViewModifier {
        
    var backgroundColor: UIColor?
   var fontColor: UIColor?
    
   init( backgroundColor: UIColor?, fontColor: UIColor?) {
        self.backgroundColor = backgroundColor
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithTransparentBackground()
        coloredAppearance.backgroundColor = .clear
      coloredAppearance.titleTextAttributes = [.foregroundColor: fontColor ?? UIColor.white]
      coloredAppearance.largeTitleTextAttributes = [.foregroundColor: fontColor ?? UIColor.white]
//
        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
        UINavigationBar.appearance().tintColor = .white

    }
    
    func body(content: Content) -> some View {
        ZStack{
            content
            VStack {
                GeometryReader { geometry in
                    Color(self.backgroundColor ?? .clear)
                        .frame(height: geometry.safeAreaInsets.top)
                        .edgesIgnoringSafeArea(.top)
                    Spacer()
                }
            }
        }
    }
}


extension View {
 
   func navigationBarColor(backgroundColor: UIColor?, fontColor: UIColor?) -> some View {
      self.modifier(NavigationBarModifier(backgroundColor: backgroundColor, fontColor: fontColor))
    }

}
