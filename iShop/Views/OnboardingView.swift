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
      UIHostingController(rootView: ImageView(imageString: "meditating")),
      UIHostingController(rootView: ImageView(imageString: "skydiving")),
      UIHostingController(rootView: ImageView(imageString: "sitting"))
   ]
   
   var titles = [
      "Take some time out",
      "Overcome obstacles",
      "Create a peaceful mind"]
   
   var captions =  [
      "Take your time out and bring awareness into your everyday life",
      "Meditating helps you dealing with anxiety and other psychic problems",
      "Regular meditation sessions creates a peaceful inner mind"
   ]
   
   
   var body: some View {
      
      
      VStack(alignment: .leading) {
         GeometryReader { geometry in
            PageViewController(currentPageIndex: self.$currentPageIndex, viewControllers: self.subviews)
               .frame(height: geometry.size.height * 0.9)
         }
         
         
         Group {
            Text(titles[currentPageIndex])
               .font(.title)
            
            Text(captions[currentPageIndex])
               .font(.subheadline)
               .foregroundColor(.gray)
               .lineLimit(nil)
               .padding(.vertical, 5)
            
            HStack {
               PageControl(numberOfPages: subviews.count, currentPageIndex: $currentPageIndex)
                  .padding(.leading, 5)
               Spacer()
               Button(action: {
                  if self.currentPageIndex + 1 == self.subviews.count {
                     UserDefaults.standard.set(true, forKey: "onboardingShown")
                     self.onboardingShown = true
                     self.navBarColor = self.standardDarkBlueUIColor
                     self.navBarFont = UIColor.white
                     self.currentPageIndex = 0
                  } else {
                  }
                  self.currentPageIndex += 1
               }) {
                  ButtonContent()
               }
            }
         }.padding()
      }
   }
}



struct ButtonContent: View {
   var body: some View {
      Image(systemName: "arrow.right")
         .resizable()
         .foregroundColor(.white)
         .frame(width: 30, height: 30)
         .padding()
         .background(Color.orange)
         .cornerRadius(30)
   }
}


struct ImageView: View {
   
   var imageString: String
   
   var body: some View {
      Image(self.imageString)
         .resizable()
         .aspectRatio(contentMode: .fill)
         .clipped()
   }
}


struct PageViewController: UIViewControllerRepresentable {
   
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
      
      var parent: PageViewController
      
      init(_ pageViewController: PageViewController) {
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
      control.currentPageIndicatorTintColor = UIColor.orange
      control.pageIndicatorTintColor = UIColor.gray
      
      return control
   }
   
   func updateUIView(_ uiView: UIPageControl, context: Context) {
      uiView.currentPage = currentPageIndex
   }
   
}
