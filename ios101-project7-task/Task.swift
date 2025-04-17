
import UIKit

// The Task model
struct Task: Codable {

    var title: String
    var note: String?
    var dueDate: Date
    var isComplete: Bool = false {
        didSet {
            completedDate = isComplete ? Date() : nil
        }
    }

    private(set) var completedDate: Date?
    private(set) var createdDate: Date = Date()
    private(set) var id: String = UUID().uuidString

    init(title: String, note: String? = nil, dueDate: Date = Date()) {
        self.title = title
        self.note = note
        self.dueDate = dueDate
    }

    private static let tasksKey = "savedTasks"
}

// MARK: - Task + UserDefaults
extension Task {

    static func save(_ tasks: [Task]) {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(tasks) {
            UserDefaults.standard.set(encodedData, forKey: tasksKey)
        }
    }

    static func getTasks() -> [Task] {
        if let data = UserDefaults.standard.data(forKey: tasksKey) {
            let decoder = JSONDecoder()
            if let tasks = try? decoder.decode([Task].self, from: data) {
                return tasks
            }
        }
        return []
    }

    func save() {
        var tasks = Task.getTasks()
        if let index = tasks.firstIndex(where: { $0.id == self.id }) {
            tasks.remove(at: index)
            tasks.insert(self, at: index)
        } else {
            tasks.append(self)
        }
        Task.save(tasks)
    }
}
