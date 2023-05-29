@testable import Lox
import XCTest

final class ScannerTests: XCTestCase {
    
    // TODO: Write cases for all tokens
    
    func testScanTokens_withStringLiteral_returnsStringToken() throws {
        let source = "\"test\""
        var scanner = Scanner(from: source)
        let tokens = try scanner.scanTokens()
        
        let resultToken = tokens[0]
        
        XCTAssertEqual(resultToken.type, .string)
        XCTAssertEqual(resultToken.lexeme, "\"test\"")
        XCTAssertEqual(resultToken.literal as! String, "test")
        XCTAssertEqual(resultToken.line, 1)
        
        XCTAssertEqual(tokens.count, 2)
    }
    
}
