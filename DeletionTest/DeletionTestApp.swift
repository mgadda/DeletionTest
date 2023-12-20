//
//  DeletionTestApp.swift
//  DeletionTest
//
//  Created by Matthew Gadda on 12/20/23.
//

import SwiftUI

@main
struct DeletionTestApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
