//
//  DetailView.swift
//  Celeritas_Test
//
//  Created by Admin on 3/31/24.
//

import SwiftUI

struct OnboardView: View,Routeable {
   
    
    var body: some View {
        BaseView {
            VStack {
                Text("Go Zindabad").onTapGesture {
                    route(to: AnyView(HomeView()), navigation: .push)
                }
            }
        }
    }
}
