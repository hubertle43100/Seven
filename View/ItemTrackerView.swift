import SwiftUI

struct ItemsTrackerView: View {
    @State private var trackedItems: [String] = ["YES","no"]
    
    var body: some View {
        VStack {
            Text("ItemsTrackerView")
            Button("Track Item", action: saveItem)
                .padding()
                .foregroundColor(.black)
            List(trackedItems, id: \.self) { item in
                Text(item).foregroundColor(.black)
            }
        }
        .onAppear(perform: loadTrackedItems)
    }
    
    func saveItem() {
        let expirationDate = Calendar.current.date(byAdding: .day, value: 7, to: Date())!
        
        let newItem = TrackedItem(name: "Sample Item", expirationDate: expirationDate)
        
        //trackedItems.append(newItem.name)
        
        let defaults = UserDefaults.standard
        defaults.set(trackedItems, forKey: "TrackedItems")
    }
    
    func loadTrackedItems() {
        let defaults = UserDefaults.standard
        
        if let items = defaults.array(forKey: "TrackedItems") as? [String] {
            trackedItems = items.filter { itemName in
                guard let item = loadTrackedItem(name: itemName) else { return false }
                return item.expirationDate > Date()
            }
        }
    }
    
    func loadTrackedItem(name: String) -> TrackedItem? {
        let defaults = UserDefaults.standard
        
        guard let expirationDate = defaults.object(forKey: "ExpirationDate_\(name)") as? Date else { return nil }
        return TrackedItem(name: name, expirationDate: expirationDate)
    }
}

struct TrackedItem: Identifiable {
    let id = UUID()
    let name: String
    let expirationDate: Date
}

struct ItemsTrackerView_Previews: PreviewProvider {
    
    static var previews: some View {
        ItemsTrackerView()
    }
}
