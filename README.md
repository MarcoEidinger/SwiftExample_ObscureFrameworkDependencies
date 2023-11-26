An SDK may provide binary framework(s) that use static libraries and declare its dependencies through private headers and a module map. Here is an example of using PLCrashReporter as a static library.


Unfortunately, an app developer can easily find, access and use those dependencies with the regular `import` statement

```swift
import SomeFramework

// should ideally not be accessible as those are private headers of "SomeFramework"
let config = PLCrashReporterConfig(signalHandlerType: .BSD, symbolicationStrategy: [])
let reporter = PLCrashReporter(configuration: config)!
```

An SDK can better hide such dependencies by introducing an explicit module in the modulemap file.

```swift
framework module SomeFramework {
    umbrella header "SomeFramework.h"
    export *
    module * { export * }
}

explicit module SomeFramework.PrivateDependencies {
    /*CrashReporting Headers*/
    header "CrashReporter.h"
    header "PLCrashNamespace.h"
    header "PLCrashReporter.h"
    header "PLCrashReport.h"
    header "PLCrashReportTextFormatter.h"
    header "PLCrashReporterConfig.h"
    header "PLCrashMacros.h"
    header "PLCrashReportApplicationInfo.h"
    header "PLCrashReportBinaryImageInfo.h"
    header "PLCrashReportExceptionInfo.h"
    header "PLCrashReportMachineInfo.h"
    header "PLCrashReportMachExceptionInfo.h"
    header "PLCrashReportProcessInfo.h"
    header "PLCrashReportProcessorInfo.h"
    header "PLCrashReportRegisterInfo.h"
    header "PLCrashReportSignalInfo.h"
    header "PLCrashReportStackFrameInfo.h"
    header "PLCrashReportSymbolInfo.h"
    header "PLCrashReportSystemInfo.h"
    header "PLCrashReportThreadInfo.h"
    header "PLCrashReportFormatter.h"
    header "PLCrashFeatureConfig.h"
    
    export *
}
```

In addition, the SDK developer has to use `@_implementationOnly import` statement whenever such dependencies shall be used.

```swift
import Foundation
@_implementationOnly import SomeFramework.PrivateDependencies

let config = PLCrashReporterConfig(signalHandlerType: .BSD, symbolicationStrategy: [])
let reporter = PLCrashReporter(configuration: config)!
```

**Types of such dependencies shall not be used in public APIs!**

An app developer will encounter build issues when trying to use the dependencies with the regular import statement for the framework.

```swift
import SomeFramework

let config = PLCrashReporterConfig(signalHandlerType: .BSD, symbolicationStrategy: []) // Cannot find 'PLCrashReporterConfig' in scope
let reporter = PLCrashReporter(configuration: config)! // Cannot find 'PLCrashReporter' in scope
```

The App developer can fix this by using the correct `import` statement but this would no longer be accidental but on purpose and discouraged by the SDK.

```swift
import SomeFramework
import SomeFramework.PrivateDependencies

let config = PLCrashReporterConfig(signalHandlerType: .BSD, symbolicationStrategy: [])
let reporter = PLCrashReporter(configuration: config)!
```