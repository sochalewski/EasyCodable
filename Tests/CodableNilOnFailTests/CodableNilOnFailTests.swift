import XCTest
@testable import CodableNilOnFail

struct Model: Codable, Equatable {
    enum Value: String, Codable {
        case first, second
    }
    
    @NilOnFail var value1: Value?
    @LowercasedNilOnFail var value2: Value?
}

final class CodableNilOnFailTests: XCTestCase {
    
    private let decoder = JSONDecoder()
    
    func testSupportedValue() {
        let json = "{\"value1\":\"first\",\"value2\":\"SEcOnD\"}"
        let model = try? decoder.decode(
            Model.self,
            from: json.data(using: .utf8)!
        )
        
        XCTAssertEqual(model, .init(value1: .first, value2: .second))
    }
    
    func testNilValue() {
        let json = "{\"value1\":null,\"value2\":null}"
        let model = try? decoder.decode(
            Model.self,
            from: json.data(using: .utf8)!
        )
        
        XCTAssertEqual(model, .init(value1: nil, value2: nil))
    }
    
    func testUnsupportedValue() {
        let json = "{\"value1\":\"third\",\"value2\":\"fourth\"}"
        let model = try? decoder.decode(
            Model.self,
            from: json.data(using: .utf8)!
        )
        
        XCTAssertEqual(model, .init(value1: nil, value2: nil))
    }
}
