
import Combine
import SwiftUI

@propertyWrapper
public struct Injected<ObjectType: ObservableObject>: DynamicProperty {
    /// The registry object.
    @Environment(\.dependencyRegistry) var dependencyRegistry
    
    /// The SwiftUI `StateObject` that deals with the lifetime of the
    /// observable object.
    @StateObject private var core = Core()
    
    /// The underlying value referenced by the observed object.
    ///
    /// This property provides primary access to the value's data. However, you
    /// don't access `wrappedValue` directly. Instead, you use the property
    /// variable created with the `@ObservedObject` attribute.
    ///
    /// When a mutable value changes, the new value is immediately available.
    /// However, a view displaying the value is updated asynchronously and may
    /// not show the new value immediately.
    @MainActor public var wrappedValue: ObjectType {
        core.object ?? dependencyRegistry!.get(ObjectType.self)!
    }
    
    public func update() {
        core.update(makeObject: { dependencyRegistry!.get(ObjectType.self)! })
    }
    
    /// Create an injected dependency wrapper.
    public init() {
        
    }
    
    /// An observable object that keeps a strong reference to the object,
    /// and publishes its changes.
    private class Core: ObservableObject {
        let objectWillChange = PassthroughSubject<ObjectType.ObjectWillChangePublisher.Output, Never>()
        private var cancellable: AnyCancellable?
        private(set) var object: ObjectType?
        
        func update(makeObject: () -> ObjectType) {
            guard object == nil else { return }
            let object = makeObject()
            self.object = object
            
            // Transmit all object changes
            var isUpdating = true
            cancellable = object.objectWillChange.sink { [weak self] value in
                guard let self = self else { return }
                if !isUpdating {
                    // Avoid the runtime warning in the case of publishers
                    // that publish values right on subscription:
                    // > Publishing changes from within view updates is not
                    // > allowed, this will cause undefined behavior.
                    self.objectWillChange.send(value)
                }
            }
            isUpdating = false
        }
    }
}
