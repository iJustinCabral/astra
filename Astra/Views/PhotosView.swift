//
//  PhotosView.swift
//  Astra
//
//  Created by Justin Cabral on 12/31/22.
//

import SwiftUI

struct PhotosView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors:colorScheme == .dark ? [] : [.indigo, .black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 10) {
                HeaderBar()
                Spacer()
                
                ScrollView {
                    Text("testing")
                }
         
            }
            
        }
    }
    
    @ViewBuilder
    func HeaderBar() -> some View {
        HStack {
            Text("Saved Photos")
                .font(.largeTitle)
                .fontWeight(.black)
                .foregroundColor(colorScheme == .dark ? .primary : .white)
            
            Spacer()
            
            Button(action: {}, label: {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.ultraThinMaterial)
                    .frame(width: 40, height: 40)
                    .shadow(radius: 2)
                    .overlay(
                        Image(systemName: "square.and.arrow.up")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 20, height: 20)
                            .foregroundColor(colorScheme == .dark ? .primary : .white)
                    )
            })
        }.padding()
    }
}

struct PhotosView_Previews: PreviewProvider {
    static var previews: some View {
        PhotosView()
    }
}
