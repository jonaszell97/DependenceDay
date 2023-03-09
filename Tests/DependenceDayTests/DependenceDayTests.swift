import SwiftUI
import XCTest
@testable import DependenceDay

final class ExampleViewModel: ObservableObject {
    @Published var observableProperty: Int = 0
}

struct MyView: View {
    @Injected var myViewModel: ExampleViewModel
    
    var body: some View {
        VStack {
            
        }
    }
}

final class DependenceDayTests: XCTestCase {
    func testExample() throws {
        
    }
}
