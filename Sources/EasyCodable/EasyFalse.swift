@propertyWrapper
public struct EasyFalse {
    public private(set) var wrappedValue: Bool
    
    public init(wrappedValue: Bool) {
        self.wrappedValue = wrappedValue
    }
}

extension EasyFalse: Decodable {
    public init(from decoder: Decoder) throws {
        self.wrappedValue = (try? Bool(from: decoder)) ?? false
    }
}

extension EasyFalse: Encodable { }

extension EasyFalse: Equatable { }

public extension KeyedDecodingContainer {
    func decode(_: EasyFalse.Type, forKey key: Key) throws -> EasyFalse {
        if let value = try decodeIfPresent(EasyFalse.self, forKey: key) {
            return value
        } else {
            return EasyFalse(wrappedValue: false)
        }
    }
}

public extension KeyedEncodingContainer {
    mutating func encode(_ value: EasyFalse, forKey key: Key) throws {
        try encode(value.wrappedValue, forKey: key)
    }
}
