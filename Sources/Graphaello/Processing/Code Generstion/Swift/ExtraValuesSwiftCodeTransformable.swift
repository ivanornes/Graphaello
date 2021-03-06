import Foundation
import Stencil

protocol ExtraValuesSwiftCodeTransformable: SwiftCodeTransformable {
    func arguments(from context: Stencil.Context, arguments: [Any?]) throws -> [String : Any]
}

extension ExtraValuesSwiftCodeTransformable {

    func code(using context: Stencil.Context, arguments: [Any?]) throws -> String {
        let name = String(describing: Self.self)
        let dictionary = try self.arguments(from: context, arguments: arguments).merging([name.camelized : self]) { $1 }
        return try context.render(template: "swift/\(name).swift.stencil", context: dictionary)
    }

}
