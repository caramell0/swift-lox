import Foundation

public enum LoxError {
    case general(line: Int, location: String, message: String)
}

extension LoxError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .general(let line, let location, let message):
            return "[line \(line)] Error\(location): \(message)"
        }
    }
}
