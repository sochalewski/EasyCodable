import XCTest
@testable import CodableNilOnFail

struct Model: Codable, Equatable {
    enum Value: String, Codable {
        case first
    }
    
    @NilOnFail var value: Value?
}

final class CodableNilOnFailTests: XCTestCase {
    
    private let decoder = JSONDecoder()
    
    func testSupportedValue() {
        let json = "{\"value\":\"first\"}"
        let model = try? decoder.decode(
            Model.self,
            from: json.data(using: .utf8)!
        )
        
        XCTAssertEqual(model, .init(value: .first))
    }
    
    func testNilValue() {
        let json = "{\"value\":null}"
        let model = try? decoder.decode(
            Model.self,
            from: json.data(using: .utf8)!
        )
        
        XCTAssertEqual(model, .init(value: nil))
    }
    
    func testUnsupportedValue() {
        let json = "{\"value\":\"second\"}"
        let model = try? decoder.decode(
            Model.self,
            from: json.data(using: .utf8)!
        )
        
        XCTAssertEqual(model, .init(value: nil))
    }
}
