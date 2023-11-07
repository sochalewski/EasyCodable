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

extension TrueOnFail: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
}

extension TrueOnFail: Equatable {
    public static func == (lhs: TrueOnFail, rhs: TrueOnFail) -> Bool {
        lhs.wrappedValue == rhs.wrappedValue
    }
}
