import SwiftUI

struct TaskTrackerView: View {
    @State private var currentTaskIndex: Int = 0
    let tasks = ["Going home", "Staying", "Cleaning", "Drink", "Slow"]
    
    var body: some View {
        VStack {
            Text("Task for \(formattedDate(for: currentTaskIndex)):")
                .font(.headline)
            if currentTaskIndex < 5 {
                Text(tasks[currentTaskIndex])
                    .font(.title)
                    .padding()
            } else {
                Text("STUPID")
            }
            Button("Mark as Completed") {
                markTaskAsCompleted()
            }
        }
        .onAppear {
            // Set up a Timer to update the task index daily
            Timer.scheduledTimer(withTimeInterval: 86400, repeats: true) { timer in
                markTaskAsCompleted()
                
            }
        }
    }
    
    func formattedDate(for taskIndex: Int) -> String {
        let calendar = Calendar.current
        if let firstTaskDate = calendar.date(byAdding: .day, value: taskIndex, to: Date()) {
            let formatter = DateFormatter()
            formatter.dateFormat = "M/d"
            return formatter.string(from: firstTaskDate)
        }
        return ""
    }
    
    func markTaskAsCompleted() {
        // Save the completed task for the current index to UserDefaults
        UserDefaults.standard.set(true, forKey: "completedTaskIndex\(currentTaskIndex)")
        
        // Move to the next task
        currentTaskIndex = (currentTaskIndex + 1)
    }
}

struct TaskTrackerView_Previews: PreviewProvider {
    static var previews: some View {
        TaskTrackerView()
    }
}
