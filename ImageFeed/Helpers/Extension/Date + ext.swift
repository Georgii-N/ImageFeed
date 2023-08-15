import Foundation

extension String {
    func toDate() -> Date? {
        let dateFormatter = ISO8601DateFormatter()
        return dateFormatter.date(from: self)
    }
}

