//
//  CustomTabBar.swift
//  hackwestern11
//
//  Created by Michael Di Giuseppe on 2024-11-30.
//


import SwiftUI

enum TabModel: String, CaseIterable {
    case chords = "pianokeys"
    case progressions = "music.note.list"
    case settings = "gear"
    case shop = "storefront.fill"
    
    var title: String {
        switch self {
        case .chords: "Chords"
        case .progressions: "Progressions"
        case .settings: "Settings"
        case .shop: "Shop"
        }
    }
}
struct CustomTabBar: View {
    var activeForeground: Color = .primary
    var activeBackground: Color = .secondary
    @Binding var activeTab: TabModel
    /// For Matched Geometry Effect
    @Namespace private var animation
    /// View Properties
    @State private var tabLocation: CGRect = .zero
    var body: some View {
    
    
        HStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(TabModel.allCases, id: \.rawValue) { tab in
                    Button {
                        activeTab = tab
                    } label: {
                        HStack(spacing: 5) {
                            Image(systemName: tab.rawValue)
                                .font(.title3)
                                .frame(width: 30, height: 30)
                            
                            if activeTab == tab {
                                Text(tab.title)
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .lineLimit(1)
                            }
                        }
                        .foregroundStyle(activeTab == tab ? activeForeground : .gray)
                        .padding(.vertical, 2)
                        .padding(.leading, 10)
                        .padding(.trailing, 15)
                        .contentShape(.rect)
                        .background {
                            if activeTab == tab {
                                Capsule()
                                    .fill(.clear)
                                    .onGeometryChange(for: CGRect.self, of: {
                                        $0.frame(in: .named("TABBARVIEW"))
                                    }, action: { newValue in
                                        tabLocation = newValue
                                    })
                                    .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                            }
                        }
                    }
                    
                }
            }
            .background(alignment: .leading) {
                Capsule()
                    .fill(activeBackground/*.gradient*/)
                    .frame(width: tabLocation.width, height: tabLocation.height)
                    .offset(x: tabLocation.minX)
            }
            .coordinateSpace(.named("TABBARVIEW"))
            .padding(.horizontal, 5)
            .frame(height: 45)
            .background(
                .background
                    .shadow(.drop(color: .black.opacity(0.08), radius: 5, x: 5, y: 5))
                    .shadow(.drop(color: .black.opacity(0.06), radius: 5, x: -5, y: -5)),
                in: .capsule
            )
            .zIndex(10)
        }
        .padding(.bottom, 10)
        .animation(.smooth(duration: 0.3, extraBounce: 0), value: activeTab)
        .frame(maxWidth: .infinity)
    }
}
