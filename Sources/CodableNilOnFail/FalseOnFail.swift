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

extension FalseOnFail: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
}

extension FalseOnFail: Equatable {
    public static func == (lhs: FalseOnFail, rhs: FalseOnFail) -> Bool {
        lhs.wrappedValue == rhs.wrappedValue
    }
}
