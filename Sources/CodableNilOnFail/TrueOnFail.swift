@propertyWrapper
public struct TrueOnFail {
    public private(set) var wrappedValue: Bool
    
    public init(wrappedValue: Bool) {
        self.wrappedValue = wrappedValue
    }
}

extension TrueOnFail: Decodable {
    public init(from decoder: Decoder) throws {
        self.wrappedValue = (try? Bool(from: decoder)) ?? true
    }
}

extension TrueOnFail: Encodable { }

extension TrueOnFail: Equatable { }

public extension KeyedDecodingContainer {
    func decode(_: TrueOnFail.Type, forKey key: Key) throws -> TrueOnFail {
        if let value = try decodeIfPresent(TrueOnFail.self, forKey: key) {
            return value
        } else {
            return TrueOnFail(wrappedValue: true)
        }
    }
}

public extension KeyedEncodingContainer {
    mutating func encode(_ value: TrueOnFail, forKey key: Key) throws {
        try encode(value.wrappedValue, forKey: key)
    }
}
