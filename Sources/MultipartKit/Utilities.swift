#if canImport(FoundationEssentials)
    import FoundationEssentials
#else
    import Foundation
#endif
import HTTPTypes

extension HTTPFields {
    func getParameter(_ name: HTTPField.Name, _ key: String) -> String? {
        headerParts(name: name)?
            .filter { $0.contains("\(key)=") }
            .first?
            .split(separator: "=")
            .last?
            .trimmingCharacters(in: .quotes)
    }

    mutating func setParameter(
        _ name: HTTPField.Name,
        _ key: String,
        to value: String?,
        defaultValue: String
    ) {
        var current: [String]

        if let existing = self.headerParts(name: name) {
            current = existing.filter { !$0.hasPrefix("\(key)=") }
        } else {
            current = [defaultValue]
        }

        if let value = value {
            current.append("\(key)=\"\(value)\"")
        }

        let new = current.joined(separator: "; ").trimmingCharacters(in: .whitespaces)

        self[name] = new
    }

    func headerParts(name: HTTPField.Name) -> [String]? {
        self[name]
            .flatMap {
                $0.split(separator: ";")
                    .map { $0.trimmingCharacters(in: .whitespaces) }
            }
    }
}

extension CharacterSet {
    static var quotes: CharacterSet {
        return .init(charactersIn: #""'"#)
    }
}
