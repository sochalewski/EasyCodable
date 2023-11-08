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

extension EmptyArrayOnFail: Encodable where Value: Encodable, Value.Element: Decodable { }

extension EmptyArrayOnFail: Equatable where Value: Equatable, Value.Element: Equatable { }

public extension KeyedDecodingContainer {
    func decode<Value: Sequence>(_: EmptyArrayOnFail<Value>.Type, forKey key: Key) throws -> EmptyArrayOnFail<Value> where Value: Decodable, Value.Element: Decodable {
        if let value = try decodeIfPresent(EmptyArrayOnFail<Value>.self, forKey: key) {
            return value
        } else {
            return EmptyArrayOnFail<Value>(wrappedValue: [Value.Element]() as! Value)
        }
    }
}

public extension KeyedEncodingContainer {
    mutating func encode<Value: Encodable>(_ value: EmptyArrayOnFail<Value>, forKey key: Key) throws {
        try encode(value.wrappedValue, forKey: key)
    }
}

struct EmptyCodable: Codable {}
