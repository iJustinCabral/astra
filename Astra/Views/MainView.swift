//
//  MainView.swift
//  Astra
//
//  Created by Justin Cabral on 12/31/22.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Ad Astra", systemImage: "moon.stars.fill")
                }
            
            PhotosView()
                .tabItem {
                    Label("Saved Photos", systemImage: "star.fill")
                }
        }
        .accentColor(.indigo)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
