@propertyWrapper
public struct LowercasedNilOnFail<Value> where Value: RawRepresentable, Value.RawValue == String {
    public private(set) var wrappedValue: Value?
    
    public init(wrappedValue: Value?) {
        self.wrappedValue = wrappedValue
    }
}

extension LowercasedNilOnFail: Decodable where Value: Decodable {
    public init(from decoder: Decoder) throws {
        guard
            let container = try? decoder.singleValueContainer(),
            let rawString = try? container.decode(String.self)
        else { return }
        
        self.wrappedValue = Value(rawValue: rawString.lowercased())
    }
}

extension LowercasedNilOnFail: Encodable where Value: Encodable { }

extension LowercasedNilOnFail: Equatable where Value: Equatable { }

public extension KeyedDecodingContainer {
    func decode<Value: Decodable>(_: LowercasedNilOnFail<Value>.Type, forKey key: Key) throws -> LowercasedNilOnFail<Value> {
        if let value = try decodeIfPresent(LowercasedNilOnFail<Value>.self, forKey: key) {
            return value
        } else {
            return LowercasedNilOnFail<Value>(wrappedValue: nil)
        }
    }
}

public extension KeyedEncodingContainer {
    mutating func encode<Value: Encodable>(_ value: LowercasedNilOnFail<Value>, forKey key: Key) throws {
        try encode(value.wrappedValue, forKey: key)
    }
}
