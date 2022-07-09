# CodableNilOnFail

Easy failable optional enum properties in Swift Codable.

## Installation

You can add CodableNilOnFail to an Xcode project by adding it as a package dependency.

  1. From the **File** menu, select **Add Packages…**
  2. Enter `https://github.com/sochalewski/CodableNilOnFail` into the package repository URL text field.
  3. Add the package to your app target.

## Why?

Consider the following data model:

```swift
struct Car: Codable {
    enum Manufacturer: String, Codable {
        case toyota, volkswagen, ford, honda, generalMotors
    }
    
    var manufacturer: Manufacturer?
    var vin: String?
    var owner: String?
}
```

Everything works perfectly if the received JSON matches the available `Manufacturer` enum values, like this:

```json
{
    "manufacturer": "toyota",
    "vin": "JT4RN67S0G0002845",
    "owner": null
}
```

But `Car.manufacturer` is optional, so it makes sense to have a valid model, even if the received manufacturer doesn't match one of the currently supported ones:

```json
{
    "manufacturer": "tesla",
    "vin": "5YJSA2DP8DFP22249",
    "owner": "Elon Musk"
}
```

Unfortunately decoding this with `JSONDecoder` results in getting `nil` for the whole `Car` instead of just `Car.manufacturer`.

This can be solved by custom `init(from:)` of the `Decodable` protocol, but that's a lot of boilerplate, especially when you have dozens of enums in your models.

This is where CodableNilOnFail comes in!

## Usage

Just add the `@NilOnFail` property wrapper to your optional `RawRepresentable` properties.

```swift
struct Car: Codable, Equatable {
    enum Manufacturer: String, Codable {
        case toyota, volkswagen, ford, honda, generalMotors
    }
    
    @NilOnFail var manufacturer: Manufacturer?
    var vin: String?
    var owner: String?
}
```

## Author

Piotr Sochalewski, <a href="http://sochalewski.github.io">sochalewski.github.io</a>
