//
//  AdaptsToSoftwareKeyboard.swift
//  iShop
//
//  Created by Chris Filiatrault on 5/5/20.
//  Copyright © 2020 Chris Filiatrault. All rights reserved.


import SwiftUI
import Combine

/// In iOS 13, the software keyboard will prevent the user from being able to view the bottom of a list. This ViewModifier can resolve this. This isn't needed for SwiftUI in iOS 14.
struct AdaptsToSoftwareKeyboard: ViewModifier {
  @State var currentHeight: CGFloat = 0
   
  func body(content: Content) -> some View {
    content
      .padding(.bottom, currentHeight)
      .edgesIgnoringSafeArea(.bottom)
      .onAppear(perform: subscribeToKeyboardEvents)
  }

  private func subscribeToKeyboardEvents() {
    NotificationCenter.Publisher(
      center: NotificationCenter.default,
      name: UIResponder.keyboardWillShowNotification
    ).compactMap { notification in
        notification.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? CGRect
    }.map { rect in
      rect.height
    }.subscribe(Subscribers.Assign(object: self, keyPath: \.currentHeight))

    NotificationCenter.Publisher(
      center: NotificationCenter.default,
      name: UIResponder.keyboardWillHideNotification
    ).compactMap { notification in
      CGFloat.zero
    }.subscribe(Subscribers.Assign(object: self, keyPath: \.currentHeight))
  }
}

