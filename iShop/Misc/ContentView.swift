//
//  ContentView.swift
//  iShop
//
//  Created by Chris Filiatrault on 15/8/20.
//  Copyright © 2020 Chris Filiatrault. All rights reserved.
//

import SwiftUI

struct ContentView: View {
   
   
   @State var showActionSheetContentView: Bool = false
    var body: some View {
      NavigationView {
      VStack {
            NavigationLink(destination: SubView()) {
               Text("Go to sub view")
            }
         }
         .navigationBarItems(trailing:
            
            Button(action: {
               self.showActionSheetContentView.toggle()
            }) {
               Text("Show")
            }
         .actionSheet(isPresented: $showActionSheetContentView) {
             ActionSheet(title: Text("Options"), buttons: [
               .cancel(Text("Dismiss"))
             ])
         })
      }
      .environment(\.horizontalSizeClass, .compact)
      
      
    }
}


struct SubView: View {
   @State var showActionSheetSubView: Bool = false
    var body: some View {
      
      VStack {
         Text("SubView")
      }
      .environment(\.horizontalSizeClass, .compact)
      .navigationBarItems(trailing:
         
         Button(action: {
            self.showActionSheetSubView.toggle()
         }) {
            Text("This doesn't work")
         }
      .actionSheet(isPresented: $showActionSheetSubView) {
          ActionSheet(title: Text("Options"), buttons: [
            .cancel(Text("Dismiss"))
          ])
      })
    }
}


struct MasterView: View {
    @State private var showPopover: Bool = false

    var body: some View {
        VStack {
            Button("Show popover") {
                self.showPopover = true
            }.popover(
                isPresented: self.$showPopover,
                arrowEdge: .top
            ) { Text("Popover") }
        }
    }
}


struct ContentView2: View {
    var body: some View {
        
      Button(action: {
         
      }) {
         Text("Options")
      }
            .contextMenu {
                Button(action: {
                    // change country setting
                }) {
                    Text("Choose Country")
                    Image(systemName: "globe")
                }

                Button(action: {
                    // enable geolocation
                }) {
                    Text("Detect Location")
                    Image(systemName: "location.circle")
                }
            }
    }
}


import SwiftUI

struct ContentView3: View {
    @State private var isButtonSheetPresented = false
    @State private var isNavButtonSheetPresented = false

    var body: some View {
        NavigationView {
            Button(action: {
                // Works on iPad & iPhone
                self.isButtonSheetPresented.toggle()
              }) {
                Text("Show Button")
            }
            .actionSheet(isPresented: $isButtonSheetPresented,
                         content: {
                             ActionSheet(title: Text("ActionSheet"))
              })
            .navigationBarTitle(Text("Title"),
                                displayMode: .inline)
            .navigationBarItems(leading:
                Button(action: {
                    // Works on iPhone, fails on iPad
                    self.isNavButtonSheetPresented.toggle()
                    }) {
                    Text("Show Nav")
                }
                .actionSheet(isPresented: $isNavButtonSheetPresented,
                             content: {
                                 ActionSheet(title: Text("ActionSheet"))
                    })
            )
        }
      .environment(\.horizontalSizeClass, .compact)
//        .navigationViewStyle(StackNavigationViewStyle())
    }
}



import SwiftUI

struct ContentView4: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination : MenuView()) {
                    Text("Settings")
                }
            }
            .navigationBarTitle("Title")
        }
    }
}

struct MenuView : View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @GestureState private var dragOffset = CGSize.zero
    
    var body : some View {
        VStack {
            Text("Settings")
                .foregroundColor(Color.white)
                
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading: Button(action : {
                    self.mode.wrappedValue.dismiss()
                }){
                  HStack {
                    Image(systemName: "chevron.left")
                     .imageScale(.medium)
                     Text("Lists")
                  }
                  .foregroundColor(Color.white)
                })
                .frame(maxWidth: .infinity, maxHeight : .infinity)
                .background(Color.blue)
                
            Spacer()
        }
        .edgesIgnoringSafeArea(.top)
        .gesture(DragGesture().updating($dragOffset, body: { (value, state, transaction) in
        
            if(value.startLocation.x < 20 && value.translation.width > 100) {
                self.mode.wrappedValue.dismiss()
            }
            
        }))
    }
}
