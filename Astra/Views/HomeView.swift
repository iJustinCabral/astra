//
//  HomeView.swift
//  Astra
//
//  Created by Justin Cabral on 12/31/22.
//

import SwiftUI

struct HomeView: View {
    
    // Checks for light or dark mode
    @Environment(\.colorScheme) var colorScheme
    
    // Communicates with our API and triggers the screen redraws
    @StateObject private var viewModel = HomeViewModel(service: AstraService())
    
    // Controls the sheet view
    @State private var isShowingSheet = false
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors:colorScheme == .dark ? [] : [.indigo, .black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HeaderBar()
                switch viewModel.state {
                case .success(let starPhoto):
                    StarPhotoImageView(photo: starPhoto)
                    
                    Text(starPhoto.title)
                        .font(.title)
                        .foregroundColor(colorScheme == .dark ? .primary : .white)
                        .fontWeight(.black)
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            isShowingSheet.toggle()
                        }, label: {
                            Text("Learn More")
                                .padding()
                                .background(.ultraThinMaterial)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                                .font(.title2)
                                .fontWeight(.bold)
                        })
                        
                        Spacer()
                        
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.ultraThinMaterial)
                            .frame(width: 60, height: 58)
                            .overlay(
                                Button(action: {}) {
                                    Image(systemName: "star.fill")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(.white)
                                }
                            )
                        
                        Spacer()
                    }
                    
                case .loading:
                    VStack {
                        ProgressView()
                        Text("Loading Photo...")
                    }
                case .no_photo:
                    Text("No Photo Found")
                case .failed(let error):
                    Text(error.localizedDescription)
                    let _ = print(error)
                }
                Spacer()
            }
        }
        .task {
            await viewModel.getStarPhoto()
        }
        .sheet(isPresented: $isShowingSheet) {
            ZStack {
                if colorScheme == .dark { Color.black }
                else { Color.indigo }
                
                Text(viewModel.starPhoto.explanation)
                    .padding()
                    .font(.system(size: 16))
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
            }
            .ignoresSafeArea()
                .presentationDetents([.medium, .large])
        }
    }
    
    // Button still needs be converted into a ShareLink
    @ViewBuilder
    func HeaderBar() -> some View {
        HStack {
            Text("Astra")
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
    
    @ViewBuilder
    func StarPhotoImageView(photo: StarPhoto) -> some View {
        AsyncImage(url: URL(string: photo.url)) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(12)
                    .padding()
                    .frame(maxHeight: 460)
                    
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
