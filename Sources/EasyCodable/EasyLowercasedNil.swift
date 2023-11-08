@propertyWrapper
public struct EasyLowercasedNil<Value> where Value: RawRepresentable, Value.RawValue == String {
    public private(set) var wrappedValue: Value?
    
    public init(wrappedValue: Value?) {
        self.wrappedValue = wrappedValue
    }
}

extension EasyLowercasedNil: Decodable where Value: Decodable {
    public init(from decoder: Decoder) throws {
        guard
            let container = try? decoder.singleValueContainer(),
            let rawString = try? container.decode(String.self)
        else { return }
        
        self.wrappedValue = Value(rawValue: rawString.lowercased())
    }
}

extension EasyLowercasedNil: Encodable where Value: Encodable { }

extension EasyLowercasedNil: Equatable where Value: Equatable { }

public extension KeyedDecodingContainer {
    func decode<Value: Decodable>(_: EasyLowercasedNil<Value>.Type, forKey key: Key) throws -> EasyLowercasedNil<Value> {
        if let value = try decodeIfPresent(EasyLowercasedNil<Value>.self, forKey: key) {
            return value
        } else {
            return EasyLowercasedNil<Value>(wrappedValue: nil)
        }
    }
}

public extension KeyedEncodingContainer {
    mutating func encode<Value: Encodable>(_ value: EasyLowercasedNil<Value>, forKey key: Key) throws {
        try encode(value.wrappedValue, forKey: key)
    }
}
