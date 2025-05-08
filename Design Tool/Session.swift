import Foundation

struct Session: Identifiable, Codable {
    let id: UUID
    var title: String
    var duration: TimeInterval
    var isBreak: Bool
    
    init(id: UUID = UUID(), title: String, duration: TimeInterval, isBreak: Bool) {
        self.id = id
        self.title = title
        self.duration = duration
        self.isBreak = isBreak
    }
}
