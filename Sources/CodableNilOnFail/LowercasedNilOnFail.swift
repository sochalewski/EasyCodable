@propertyWrapper
public struct LowercasedNilOnFail<Value>: Codable where Value: Codable & RawRepresentable, Value.RawValue == String {
    
    public var wrappedValue: Value?
    
    public init(wrappedValue: Value?) {
        self.wrappedValue = wrappedValue
    }
    
    public init(from decoder: Decoder) throws {
        guard
            let container = try? decoder.singleValueContainer(),
            let rawString = try? container.decode(String.self)
        else { return }
        
        self.wrappedValue = Value(rawValue: rawString.lowercased())
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

extension LowercasedNilOnFail: Equatable where Value: Equatable {
    public static func == (lhs: LowercasedNilOnFail, rhs: LowercasedNilOnFail) -> Bool {
        lhs.wrappedValue == rhs.wrappedValue
    }
}
