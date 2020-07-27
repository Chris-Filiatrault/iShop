//
//  OnboardingView.swift
//  iShop
//
//  Created by Chris Filiatrault on 19/7/20.
//  Copyright © 2020 Chris Filiatrault. All rights reserved.
//


import Foundation
import UIKit
import SwiftUI

struct OnboardingView: View {
   
   @State var currentPageIndex = 0
   @Binding var onboardingShown: Bool?
   @Binding var navBarColor: UIColor
   @Binding var navBarFont: UIColor
   
   let standardDarkBlueUIColor: UIColor = UIColor(red: 0/255, green: 10/255, blue: 30/255, alpha: 1)
   
   var subviews = [
      UIHostingController(rootView: Subview(
         imageString: "darkIconRounded",
         title:  "Welcome to iShop",
         caption: ""
      )),
      UIHostingController(rootView: Subview(
         imageString: "HomeView",
         title: "Create Multiple Lists",
         caption: "A number shows how many unchecked items are in each list."
      )),
      UIHostingController(rootView: Subview(
         imageString: "ListView",
         title: "Organise Using Categories",
         caption: "Create and delete categories."
      )),
      UIHostingController(rootView: Subview(
         imageString: "CatalogueView",
         title: "Add From Item History",
         caption: "All items entered in any list are saved. Simply tap an item to add it to the current list."
      )),
      UIHostingController(rootView: Subview(
         imageString: "FilteredCatalogueView",
         title: "Filter The Item History",
         caption: "Start typing to filter the list and quickly find the item you're looking for."
      )),
      UIHostingController(rootView: Subview(
         imageString: "iPhoneiPadOnboarding",
         title: "Use On Multiple Devices",
         caption: "Items and lists are automatically and securely synced over iCloud. No login or password required."
      )),
      UIHostingController(rootView: LastSubview())
   ]
   
   
   
   var body: some View {
      
      ZStack {
         OBPageViewController(currentPageIndex: self.$currentPageIndex, viewControllers: self.subviews)
            .edgesIgnoringSafeArea(.all)
         
         VStack {
            Spacer()
            
            HStack {
               if currentPageIndex == 0 {
                  Text("Continue")
                     .font(.headline)
                     .foregroundColor(.gray)
                  
                  Image(systemName: "arrow.right")
                     .imageScale(.large)
                     .foregroundColor(.gray)
               }
            }
            PageControl(numberOfPages: subviews.count, currentPageIndex: $currentPageIndex)
               .padding(.leading, 5)
               .padding(.bottom)
         }
      }
      .onTapGesture {
         if self.currentPageIndex + 1 == self.subviews.count {
            UserDefaults.standard.set(true, forKey: "onboardingShown")
            self.onboardingShown = true
            self.navBarColor = self.standardDarkBlueUIColor
            self.navBarFont = UIColor.white
            self.currentPageIndex = 0
         } else if self.currentPageIndex <= self.subviews.count {
            withAnimation {
               self.currentPageIndex += 1
            }
         }
      }
      
   }
}


struct Subview: View {
   
   var imageString: String
   var title: String
   var caption: String
   
   
   var body: some View {
      
      ZStack {
         
         Color(.black).edgesIgnoringSafeArea(.all)
         GeometryReader { geometry in
            VStack {
               
               Text(self.title)
                  .font(.title)
                  .foregroundColor(.white)
               Image(self.imageString)
                  .resizable()
                  .aspectRatio(contentMode: .fill)
                  .clipped()
               
               Text(self.caption)
                  .font(.subheadline)
                  .foregroundColor(.white)
                  .lineLimit(nil)
                  .padding(.vertical, 5)
               
            }
            .frame(width: UIDevice.current.userInterfaceIdiom == .phone ? geometry.size.width * 0.9 : geometry.size.height * 0.6,
                   height: UIDevice.current.userInterfaceIdiom == .phone ? geometry.size.width * 0.9 : geometry.size.height * 0.6)
         }
      }
      
   }
}

struct LastSubview: View {
   
   var body: some View {
      
      ZStack {
         
         Color(.black).edgesIgnoringSafeArea(.all)
         GeometryReader { geometry in
            VStack {
               Spacer()
               Text("Get started")
                  .bold()
//                  .frame(minWidth: 50)
                  .font(.headline)
                  .padding(10)
                  .background(Color("blueButton"))
                  .foregroundColor(.white)
                  .cornerRadius(10)
               
               
            }
            .frame(width: UIDevice.current.userInterfaceIdiom == .phone ? geometry.size.width * 0.9 : geometry.size.height * 0.6,
                   height: UIDevice.current.userInterfaceIdiom == .phone ? geometry.size.width * 0.9 : geometry.size.height * 0.6)
         }
         
      }
   }
}


struct OBPageViewController: UIViewControllerRepresentable {
   
   @Binding var currentPageIndex: Int
   
   var viewControllers: [UIViewController]
   
   func makeCoordinator() -> Coordinator {
      Coordinator(self)
   }
   
   
   func makeUIViewController(context: Context) -> UIPageViewController {
      let pageViewController = UIPageViewController(
         transitionStyle: .scroll,
         navigationOrientation: .horizontal)
      
      
      pageViewController.dataSource = context.coordinator
      pageViewController.delegate = context.coordinator
      
      
      return pageViewController
   }
   
   func updateUIViewController(_ pageViewController: UIPageViewController, context: Context) {
      pageViewController.setViewControllers(
         [viewControllers[currentPageIndex]], direction: .forward, animated: true)
   }
   
   class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
      
      var parent: OBPageViewController
      
      
      init(_ pageViewController: OBPageViewController) {
         self.parent = pageViewController
         
         
      }
      
      
      func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
         //retrieves the index of the currently displayed view controller
         guard let index = parent.viewControllers.firstIndex(of: viewController) else {
            return nil
         }
         
         //shows the last view controller when the user swipes back from the first view controller
         if index == 0 {
            return parent.viewControllers.last
         }
         
         //show the view controller before the currently displayed view controller
         
         return parent.viewControllers[index - 1]
         
      }
      
      func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
         //retrieves the index of the currently displayed view controller
         guard let index = parent.viewControllers.firstIndex(of: viewController) else {
            return nil
         }
         //shows the first view controller when the user swipes further from the last view controller
         if index + 1 == parent.viewControllers.count {
            return parent.viewControllers.first
         }
         //show the view controller after the currently displayed view controller
         return parent.viewControllers[index + 1]
      }
      
      func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
         if completed,
            let visibleViewController = pageViewController.viewControllers?.first,
            let index = parent.viewControllers.firstIndex(of: visibleViewController)
         {
            parent.currentPageIndex = index
         }
      }
   }
   
}


struct PageControl: UIViewRepresentable {
   
   var numberOfPages: Int
   
   @Binding var currentPageIndex: Int
   
   func makeUIView(context: Context) -> UIPageControl {
      let control = UIPageControl()
      control.numberOfPages = numberOfPages
      control.currentPageIndicatorTintColor = UIColor.white
      control.pageIndicatorTintColor = UIColor.darkGray
      
      return control
   }
   
   func updateUIView(_ uiView: UIPageControl, context: Context) {
      uiView.currentPage = currentPageIndex
   }
   
}
