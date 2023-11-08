import XCTest
@testable import EasyCodable

struct Model: Codable, Equatable {
    enum Value: String, Codable {
        case first, second
    }
    
    @EasyNil var value1: Value?
    @EasyLowercasedNil var value2: Value?
    @EasyNil var string: String?
    @EasyEmptyArray var array1: [Value]
    @EasyEmptyArray var array2: [String]
    @EasyTrue var bool1: Bool
    @EasyFalse var bool2: Bool
}

final class EasyCodableTests: XCTestCase {
    
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    
    func testSupportedValue() {
        let jsons = [
            #"{"value1":"first","value2":"SEcOnD","string":"lorem ipsum","array1":["first"],"array2":["first"],"bool1":false,"bool2":true}"#,
            #"{"value1":"first","value2":"SEcOnD","string":"lorem ipsum","array1":["zeroth", "first", "fifth"],"array2":["first"],"bool1":false,"bool2":true}"#
        ]
        let expectedModel = Model(
            value1: .first,
            value2: .second,
            string: "lorem ipsum",
            array1: [.first],
            array2: ["first"],
            bool1: false,
            bool2: true
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
        let jsons = [
            #"{"value1":null,"value2":null,"string":null,"array1":null,"array2":null,"bool1":null,"bool2":null}"#,
            #"{}"#
        ]
        let expectedModel = Model(
            value1: nil,
            value2: nil,
            string: nil,
            array1: [],
            array2: [],
            bool1: true,
            bool2: false
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
    
    func testUnsupportedValue() {
        let jsons = [
            #"{"value1":"third","value2":"fourth","string":-1,"array1":["fifth"],"array2":0,"bool1":0,"bool2":1}"#,
            #"{"value1":["third"],"value2":["fourth"],"string":["fifth"],"array1":"sixth","array2":"seventh","bool1":"eighth","bool2":"ninth"}"#
        ]
        let expectedModel = Model(
            value1: nil,
            value2: nil,
            string: nil,
            array1: [],
            array2: [],
            bool1: true,
            bool2: false
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
