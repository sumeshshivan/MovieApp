//
//  NavbarView.swift
//  MovieApp
//
//  Created by sumesh shivan on 24/04/22.
//

import SwiftUI

struct NavbarView: View {
    @Environment(\.router) var router

    var body: some View {
        ZStack {
            Color(uiColor: .black)
                .ignoresSafeArea()
            HStack {
                VStack(alignment: .leading, spacing: 4.0) {
                    Text("Browse")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .font(.largeTitle)
                    Text("Movies")
                        .foregroundColor(Color("AccentColor"))
                        .font(.subheadline)
                }
                Spacer()
                NavigationLink {
                    router.searchHistoryView()
                } label: {
                    Image(systemName: "clock")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 50.0)
    }
}

struct NavbarView_Previews: PreviewProvider {
    static var previews: some View {
        NavbarView()
            .previewLayout(.sizeThatFits)
    }
}
