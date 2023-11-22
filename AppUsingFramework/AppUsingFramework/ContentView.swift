import SomeFramework
import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .onAppear {
            // should ideally not be accessible as those are private headers of "SomeFramework"
            let config = PLCrashReporterConfig(signalHandlerType: .BSD, symbolicationStrategy: [])
            let reporter = PLCrashReporter(configuration: config)!
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
