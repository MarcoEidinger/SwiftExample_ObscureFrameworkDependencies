import Foundation
@_implementationOnly import SomeFramework.PrivateDependencies

public struct MyCoolAPI {
    public init() {}
    public func doCoolStuff() {
        let config = PLCrashReporterConfig(signalHandlerType: .BSD, symbolicationStrategy: [])
        let reporter = PLCrashReporter(configuration: config)!
    }
}
