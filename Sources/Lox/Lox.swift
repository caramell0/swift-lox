import Foundation

final public class Lox {
    
    public static func run(source: String) throws {
        var scanner = Scanner(from: source)
        let tokens = try scanner.scanTokens()
        
        for token in tokens {
            print(token)
        }
    }
    
}
