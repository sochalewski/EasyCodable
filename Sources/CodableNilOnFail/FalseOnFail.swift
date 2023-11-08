@propertyWrapper
public struct FalseOnFail {
    public private(set) var wrappedValue: Bool
    
    public init(wrappedValue: Bool) {
        self.wrappedValue = wrappedValue
    }
}

extension FalseOnFail: Decodable {
    public init(from decoder: Decoder) throws {
        self.wrappedValue = (try? Bool(from: decoder)) ?? false
    }
}

extension FalseOnFail: Encodable { }

extension FalseOnFail: Equatable { }

public extension KeyedDecodingContainer {
    func decode(_: FalseOnFail.Type, forKey key: Key) throws -> FalseOnFail {
        if let value = try decodeIfPresent(FalseOnFail.self, forKey: key) {
            return value
        } else {
            return FalseOnFail(wrappedValue: false)
        }
    }
}

public extension KeyedEncodingContainer {
    mutating func encode(_ value: FalseOnFail, forKey key: Key) throws {
        try encode(value.wrappedValue, forKey: key)
    }
}
