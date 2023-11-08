@propertyWrapper
public struct EasyTrue {
    public private(set) var wrappedValue: Bool
    
    public init(wrappedValue: Bool) {
        self.wrappedValue = wrappedValue
    }
}

extension EasyTrue: Decodable {
    public init(from decoder: Decoder) throws {
        self.wrappedValue = (try? Bool(from: decoder)) ?? true
    }
}

extension EasyTrue: Encodable { }

extension EasyTrue: Equatable { }

public extension KeyedDecodingContainer {
    func decode(_: EasyTrue.Type, forKey key: Key) throws -> EasyTrue {
        if let value = try decodeIfPresent(EasyTrue.self, forKey: key) {
            return value
        } else {
            return EasyTrue(wrappedValue: true)
        }
    }
}

public extension KeyedEncodingContainer {
    mutating func encode(_ value: EasyTrue, forKey key: Key) throws {
        try encode(value.wrappedValue, forKey: key)
    }
}
