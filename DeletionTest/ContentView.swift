//
//  ContentView.swift
//  DeletionTest
//
//  Created by Matthew Gadda on 12/20/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
  @Environment(\.managedObjectContext) private var viewContext

  @FetchRequest(
      sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
      animation: .default)
  private var items: FetchedResults<Item>

  var body: some View {
    NavigationStack {
      List {
        ForEach(items) { item in
          NavigationLink {
            DetailView(item: item)
          } label: {
            // A preview of the item
            Text(item.timestamp!, formatter: itemFormatter)
          }
        }
        .onDelete(perform: deleteItems)
      }
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          EditButton()
        }
        ToolbarItem {
          Button(action: addItem) {
              Label("Add Item", systemImage: "plus")
          }
        }
      }
      Text("Select an item")
    }
  }

  private func addItem() {
    withAnimation {
      let newItem = Item(context: viewContext)
      newItem.timestamp = Date()

      do {
        try viewContext.save()
      } catch {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        let nsError = error as NSError
        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
      }
    }
  }

  private func deleteItems(offsets: IndexSet) {
    withAnimation {
        offsets.map { items[$0] }.forEach(viewContext.delete)

        do {
          try viewContext.save()
        } catch {
          // Replace this implementation with code to handle the error appropriately.
          // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
          let nsError = error as NSError
          fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
  }
}

struct DetailView: View {
  @Environment(\.managedObjectContext) private var viewContext
  @ObservedObject var item: Item
  @Environment(\.dismiss) var dismiss

  var body: some View {
    VStack {
      Text("Item at \(item.timestamp!, formatter: itemFormatter)")
      Button("Delete") {
        dismiss()
        // Defer deletion until have DetailView has been popped from the view stack
        DispatchQueue.main.async {
          viewContext.delete(item)
        }
        do {
            try viewContext.save()
        } catch {
            print("Error saving context: \(error)")
        }
      }
    }
  }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
