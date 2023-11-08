@propertyWrapper
public struct EasyEmptyArray<Value> where Value: Sequence {
    public private(set) var wrappedValue: Value
    
    public init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }
}

extension EasyEmptyArray: Decodable where Value: Decodable, Value.Element: Decodable {
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

extension EasyEmptyArray: Encodable where Value: Encodable, Value.Element: Decodable { }

extension EasyEmptyArray: Equatable where Value: Equatable, Value.Element: Equatable { }

public extension KeyedDecodingContainer {
    func decode<Value: Sequence>(_: EasyEmptyArray<Value>.Type, forKey key: Key) throws -> EasyEmptyArray<Value> where Value: Decodable, Value.Element: Decodable {
        if let value = try decodeIfPresent(EasyEmptyArray<Value>.self, forKey: key) {
            return value
        } else {
            return EasyEmptyArray<Value>(wrappedValue: [Value.Element]() as! Value)
        }
    }
}

public extension KeyedEncodingContainer {
    mutating func encode<Value: Encodable>(_ value: EasyEmptyArray<Value>, forKey key: Key) throws {
        try encode(value.wrappedValue, forKey: key)
    }
}

struct EmptyCodable: Codable {}
