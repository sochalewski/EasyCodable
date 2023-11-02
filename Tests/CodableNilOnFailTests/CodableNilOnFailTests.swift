import XCTest
@testable import CodableNilOnFail

struct Model: Codable, Equatable {
    enum Value: String, Codable {
        case first, second
    }
    
    @NilOnFail var value1: Value?
    @LowercasedNilOnFail var value2: Value?
    @EmptyArrayOnFail var array: [Value]
}

final class CodableNilOnFailTests: XCTestCase {
    
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    
    func testSupportedValue() {
        let jsons = [
            #"{"value1":"first","value2":"SEcOnD","array":["first"]}"#,
            #"{"value1":"first","value2":"SEcOnD","array":["zeroth", "first", "fifth"]}"#
        ]
        let expectedModel = Model(
            value1: .first,
            value2: .second,
            array: [.first]
        )
        
        jsons.forEach { json in
            let model = try? decoder.decode(
                Model.self,
                from: json.data(using: .utf8)!
            )
            
            XCTAssertEqual(model, expectedModel)
            
            XCTAssertEqual(model, try! decoder.decode(Model.self, from: try! encoder.encode(model)))
        }
    }
    
    func testNilValue() {
        let json = #"{"value1":null,"value2":null,"array":null}"#
        let expectedModel = Model(
            value1: nil,
            value2: nil,
            array: []
        )
        
        let model = try? decoder.decode(
            Model.self,
            from: json.data(using: .utf8)!
        )
        
        XCTAssertEqual(model, expectedModel)
        
        XCTAssertEqual(model, try! decoder.decode(Model.self, from: try! encoder.encode(model)))
    }
    
    func testUnsupportedValue() {
        let jsons = [
            #"{"value1":"third","value2":"fourth","array":["fifth"]}"#,
            #"{"value1":["third"],"value2":["fourth"],"array":"fifth"}"#
        ]
        let expectedModel = Model(
            value1: nil,
            value2: nil,
            array: []
        )
        
        jsons.forEach { json in
            let model = try? decoder.decode(
                Model.self,
                from: json.data(using: .utf8)!
            )
            
            XCTAssertEqual(model, expectedModel)
            
            XCTAssertEqual(model, try! decoder.decode(Model.self, from: try! encoder.encode(model)))
        }
    }
}
