@propertyWrapper
public struct EasyNil<Value> {
    public private(set) var wrappedValue: Value?
    
    public init(wrappedValue: Value?) {
        self.wrappedValue = wrappedValue
    }
}

extension EasyNil: Decodable where Value: Decodable {
    public init(from decoder: Decoder) throws {
        self.wrappedValue = try? Value(from: decoder)
    }
}

extension EasyNil: Encodable where Value: Encodable { }

extension EasyNil: Equatable where Value: Equatable { }

public extension KeyedDecodingContainer {
    func decode<Value: Decodable>(_: EasyNil<Value>.Type, forKey key: Key) throws -> EasyNil<Value> {
        if let value = try decodeIfPresent(EasyNil<Value>.self, forKey: key) {
            return value
        } else {
            return EasyNil<Value>(wrappedValue: nil)
        }
    }
}

public extension KeyedEncodingContainer {
    mutating func encode<Value: Encodable>(_ value: EasyNil<Value>, forKey key: Key) throws {
        try encode(value.wrappedValue, forKey: key)
    }
}
