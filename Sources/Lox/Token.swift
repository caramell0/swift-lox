import Foundation

struct Token {
    let type: TokenType
    let lexeme: String
    let literal: Any? // TODO: Proper type to this
    let line: Int

    var description: String {
        return "\(type) \(lexeme) \(String(describing: literal))"
    }
}
