
import Combine
import SwiftUI

@propertyWrapper
public struct Injected<ObjectType: ObservableObject>: DynamicProperty {
    /// The registry object.
    @Environment(\.dependencyRegistry) var dependencyRegistry
    
    /// This state object is responsible for reacting to changes in the injected view model.
    @StateObject private var core = Core()
    
    /// The injected view model.
    ///
    /// This property provides primary access to the value's data. However, you
    /// don't access `wrappedValue` directly. Instead, you use the property
    /// variable created with the `@Injected` attribute.
    @MainActor public var wrappedValue: ObjectType {
        core.object ?? dependencyRegistry!.get(ObjectType.self)!
    }
    
    public func update() {
        core.update(registry: self.dependencyRegistry!)
    }
    
    /// Create an injected dependency wrapper.
    public init() {
        
    }
    
    /// Publishes changes to the underlying observable object.
    /// Mostly taken from https://github.com/groue/GRDBQuery/blob/main/Sources/GRDBQuery/EnvironmentStateObject.swift
    private class Core: ObservableObject {
        let objectWillChange = PassthroughSubject<ObjectType.ObjectWillChangePublisher.Output, Never>()

        var cancellable: AnyCancellable?
        var object: ObjectType?
        
        func update(registry: DependencyRegistry) {
            guard object == nil else {
                return
            }
            
            // Load the object from the registry
            let object = registry.get(ObjectType.self)!
            self.object = object
            
            // Pass through all object changes
            var isUpdating = true
            cancellable = object.objectWillChange.sink { [weak self] value in
                guard let self = self else {
                    return
                }
                
                if !isUpdating {
                    self.objectWillChange.send(value)
                }
            }
            
            isUpdating = false
        }
    }
}
