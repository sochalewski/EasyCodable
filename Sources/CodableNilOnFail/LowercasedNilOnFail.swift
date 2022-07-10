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

extension LowercasedNilOnFail: Encodable where Value: Encodable {
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
