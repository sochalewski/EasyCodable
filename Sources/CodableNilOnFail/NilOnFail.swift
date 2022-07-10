@propertyWrapper
public struct NilOnFail<Value>: Codable where Value: Codable & RawRepresentable {
    
    public var wrappedValue: Value?
    
    public init(wrappedValue: Value?) {
        self.wrappedValue = wrappedValue
    }
    
    public init(from decoder: Decoder) throws {
        self.wrappedValue = try? Value(from: decoder)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        if let value = wrappedValue {
            try container.encode(value)
        } else {
            try container.encodeNil()
        }
    }
}

extension NilOnFail: Equatable where Value: Equatable {
    public static func == (lhs: NilOnFail, rhs: NilOnFail) -> Bool {
        lhs.wrappedValue == rhs.wrappedValue
    }
}
