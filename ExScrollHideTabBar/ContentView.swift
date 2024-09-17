//
//  ContentView.swift
//  ExScrollHideTabBar
//
//  Created by 심성곤 on 9/17/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var tabState: Visibility = .visible
    
    var body: some View {
        TabView {
            TabStateScrollView(axis: .vertical, showsIndicator: true, tabState: $tabState) {
                VStack(spacing: 16) {
                    ForEach(1...10, id: \.self) { index in
                        Rectangle()
                            .fill(.green)
                            .frame(height: 200)
                            .clipShape(.rect(cornerRadius: 25))
                    }
                }
                .padding()
            }
            .toolbarVisibility(tabState, for: .tabBar)
            .animation(.easeOut(duration: 0.3), value: tabState)
            .tabItem {
                Image(systemName: "house")
                Text("Home")
            }
            
            Text("Favorite")
                .tabItem {
                    Image(systemName: "suit.heart")
                    Text("Favorite")
                }
        }
    }
}

#Preview {
    ContentView()
}
