
import SwiftUI

public final class DependencyRegistry {
    /// The registered instances.
    var instances: [ObjectIdentifier: any ObservableObject] = [:]
    
    /// Default initializer.
    public init() {
        
    }
    
    /// Register an injectable instance.
    public func register<Value: ObservableObject>(_ value: Value) {
        self.instances[ObjectIdentifier(Value.self)] = value
    }
    
    /// Get a dependency by type.
    public func get<Value: ObservableObject>(_ type: Value.Type) -> Value? {
        self.instances[ObjectIdentifier(Value.self)] as? Value
    }
}

struct DependencyRegistryEnvironmentKey: EnvironmentKey {
    static let defaultValue: DependencyRegistry? = nil
}

public extension EnvironmentValues {
    var dependencyRegistry: DependencyRegistry? {
        get {
            return self[DependencyRegistryEnvironmentKey.self]
        }
        set {
            self[DependencyRegistryEnvironmentKey.self] = newValue
        }
    }
}
