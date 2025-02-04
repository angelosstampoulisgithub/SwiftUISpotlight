//
//  ContentView.swift
//  SwiftUISpotlight
//
//  Created by Angelos Staboulis on 4/2/25.
//

import SwiftUI
import CoreSpotlight
struct ContentView: View {
    let appData = [11, 12, 13, 14,15, 653, 17, 18, 19, 20]
    @State private var selection: Int?

    var body: some View {
        VStack {
                    List {
                        Section {
                            ForEach(appData, id: \.self) { value in
                                    Text("\(value)")
                              }
                        }
                        Section {
                            Button("Index Data", action: indexData)
                        }
                    }
                    .navigationTitle("SwiftUISpotlight")
                }
                .onContinueUserActivity(CSSearchableItemActionType, perform: handleSpotlight)
                .onContinueUserActivity(CSQueryContinuationActionType, perform: handleSpotlightSearchContinuation)
    }
    func indexData() {
            var searchableItems = [CSSearchableItem]()
            appData.forEach {
                let attributeSet = CSSearchableItemAttributeSet(contentType: .content)
                attributeSet.displayName = $0.description
                let searchableItem = CSSearchableItem(uniqueIdentifier: $0.description, domainIdentifier: "sample", attributeSet: attributeSet)
                searchableItems.append(searchableItem)
            }

            CSSearchableIndex.default().indexSearchableItems(searchableItems)
        }


        func handleSpotlight(userActivity: NSUserActivity) {
            guard let element = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String else {
                return
            }

            if let actionIdentifier = userActivity.userInfo?[CSActionIdentifier] as? String {
                if actionIdentifier == "CS_ACTION_1" {
                    print("Perform action 1")
                } else if actionIdentifier == "CS_ACTION_2" {
                    print("Perform action 2")
                }
            }
            else {
                self.selection = Int(element)
            }
        }

        func handleSpotlightSearchContinuation(userActivity: NSUserActivity) {
            guard let searchString = userActivity.userInfo?[CSSearchQueryString] as? String else {
                return
            }
            print(searchString)
        }
}

#Preview {
    ContentView()
}
