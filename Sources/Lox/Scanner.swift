import Foundation

struct Scanner {
    
    private let source: String
    private var tokens: [Token] = []
    
    private var start: Int = 0
    private var current: Int = 0
    private var line: Int = 1
    
    private var isAtEnd: Bool {
        current >= source.count
    }
    
    init(from source: String) {
        self.source = source
    }
    
    mutating func scanTokens() throws -> [Token] {
        while !isAtEnd {
            start = current
            try scanToken()
        }
        
        let eofToken = Token(type: .eof, lexeme: "", literal: nil, line: line)
        tokens.append(eofToken)
        
        return tokens
    }
    
    mutating private func scanToken() throws {
        let char = advance()
        
        switch char {
        case "(": add(type: .leftParen)
        case ")": add(type: .rightParen)
        case "{": add(type: .leftBrace)
        case "}": add(type: .rightBrace)
        case ",": add(type: .comma)
        case ".": add(type: .dot)
        case "-": add(type: .minus)
        case "+": add(type: .plus)
        case ";": add(type: .semicolon)
        case "*": add(type: .star)
        case "!": add(type: match(expected: "=") ? .bangEqual : .bang)
        case "=": add(type: match(expected: "=") ? .equalEqual : .equal)
        case "<": add(type: match(expected: "=") ? .lessEqual : .less)
        case ">": add(type: match(expected: "=") ? .greaterEqual : .greater)
        case "/":
            if match(expected: "/") {
                // This is a comment, go to end of line
                while peek() != "\n" && !isAtEnd {
                    advance()
                }
            } else {
                add(type: .slash)
            }
        case " ": break
        case "\r": break
        case "\t": break // Ignore whitespace
        case "\n":
            line += 1
        case "\"": try string()
        default:
            // TODO: Instead of throwing here, add this to a collection of error and throw after full scan is done
            throw LoxError.general(line: line, location: "", message: "Unexpected character.")
        }
    }
    
    mutating private func string() throws {
        while peek() != "\"" && !isAtEnd {
            if peek() == "\n" {
                line += 1
            }
            
            advance()
        }
        
        if isAtEnd {
            throw LoxError.general(line: line, location: "", message: "Unterminated string.")
        }
        
        // The closing "
        advance()
        
        
        // TODO: Many times in the code, this type of index handling is done, remove duplication at some point
        let startIndex = source.startIndex
        let start = source.index(startIndex, offsetBy: 1)
        let end = source.index(startIndex, offsetBy: current - 1)
        
        let value = String(source[start..<end])
        add(type: .string, literal: value)
    }
    
    mutating private func match(expected: Character) -> Bool {
        guard !isAtEnd else {
            return false
        }
        
        // TODO: Many times in the code, this type of index handling is done, remove duplication at some point
        let startIndex = source.startIndex
        let index = source.index(startIndex, offsetBy: current)
        
        guard source[index] == expected else {
            return false
        }
        
        current += 1
        
        return true
    }
    
    mutating private func peek() -> Character {
        guard !isAtEnd else {
            return "\0"
        }
        
        let startIndex = source.startIndex
        let index = source.index(startIndex, offsetBy: current)
        
        return source[index]
    }
    
    @discardableResult
    mutating private func advance() -> Character {
        let startIndex = source.startIndex
        let index = source.index(startIndex, offsetBy: current)
        
        current += 1 // TODO: Check if this should really be here and not before index gets created
        
        return source[index]
    }
    
    mutating private func add(type: TokenType, literal: Any? = nil) {
        let startIndex = source.startIndex
        let start = source.index(startIndex, offsetBy: start)
        let current = source.index(startIndex, offsetBy: current)
        let text = String(source[start..<current])
        
        let token = Token(type: type, lexeme: text, literal: literal, line: line)
        tokens.append(token)
    }
}
