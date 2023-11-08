@propertyWrapper
public struct NilOnFail<Value> {
    public private(set) var wrappedValue: Value?
    
    public init(wrappedValue: Value?) {
        self.wrappedValue = wrappedValue
    }
}

extension NilOnFail: Decodable where Value: Decodable {
    public init(from decoder: Decoder) throws {
        self.wrappedValue = try? Value(from: decoder)
    }
}

extension NilOnFail: Encodable where Value: Encodable { }

extension NilOnFail: Equatable where Value: Equatable { }

public extension KeyedDecodingContainer {
    func decode<Value: Decodable>(_: NilOnFail<Value>.Type, forKey key: Key) throws -> NilOnFail<Value> {
        if let value = try decodeIfPresent(NilOnFail<Value>.self, forKey: key) {
            return value
        } else {
            return NilOnFail<Value>(wrappedValue: nil)
        }
    }
}

public extension KeyedEncodingContainer {
    mutating func encode<Value: Encodable>(_ value: NilOnFail<Value>, forKey key: Key) throws {
        try encode(value.wrappedValue, forKey: key)
    }
}
