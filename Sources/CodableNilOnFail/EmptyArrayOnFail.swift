@propertyWrapper
public struct EmptyArrayOnFail<Value> where Value: Sequence {
    public private(set) var wrappedValue: Value
    
    public init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }
}

extension EmptyArrayOnFail: Decodable where Value: Decodable, Value.Element: Decodable {
    public init(from decoder: Decoder) throws {
        var value = [Value.Element]()
        guard var container = try? decoder.unkeyedContainer() else {
            self.wrappedValue = value as! Value
            return
        }
        
        while !container.isAtEnd {
            guard let element = try? container.decode(Value.Element.self) else {
                _ = try? container.decode(EmptyCodable.self)
                continue
            }
            value.append(element)
        }
        
        self.wrappedValue = value as! Value
    }
}

extension EmptyArrayOnFail: Encodable where Value: Encodable, Value.Element: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
}

extension EmptyArrayOnFail: Equatable where Value: Equatable, Value.Element: Equatable {
    public static func == (lhs: EmptyArrayOnFail, rhs: EmptyArrayOnFail) -> Bool {
        lhs.wrappedValue == rhs.wrappedValue
    }
}

struct EmptyCodable: Codable {}
