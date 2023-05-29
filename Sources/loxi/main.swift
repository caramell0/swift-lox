import ArgumentParser
import Foundation
import Lox

struct Interpret: ParsableCommand {
    
    enum Error: LocalizedError {
        case invalidInput

        var errorDescription: String? {
            switch self {
            case .invalidInput:
                return "Input does not exist or it's encoding is not supported."
            }
        }
    }
    
    @Argument(help: "The .lox file to run")
    var inputFile: String?
    
    // TODO: proper exit code when error is thrown
    func run() throws {
        // Check if input file is passed, if not, run as prompt
        guard let inputFile = inputFile else {
            try runPrompt()
            return
        }
        
        // Get contents of file, if not, throw invalid argument error
        guard
            let url = URL(string: inputFile),
            let data = try? Data(contentsOf: url),
            let source = String(data: data, encoding: .utf8) else {
            throw Error.invalidInput
        }
        
        try Lox.run(source: source)
    }
    
    private func run(file: String) throws {
        
    }
    
    private func runPrompt() throws {
        while true {
            print("> ", terminator: "")
            guard let line = readLine() else { break }
            try Lox.run(source: line)
        }
    }
}

Interpret.main()
