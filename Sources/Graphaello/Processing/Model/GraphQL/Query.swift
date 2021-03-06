import Foundation

struct GraphQLQuery: Hashable {
    let name: String
    let api: API

    @OrderedHashableDictionary
    var components: [GraphQLField : GraphQLComponent]
}

extension GraphQLQuery {

    var arguments: OrderedSet<GraphQLArgument> {
        return components.keys.flatMap { $0.arguments } +
            components.values.flatMap { $0.arguments }
    }

}

extension GraphQLQuery {
    
    static func + (lhs: GraphQLQuery, rhs: GraphQLQuery) throws -> GraphQLQuery {
        guard lhs.api.name == rhs.api.name else {
            throw GraphQLFragmentResolverError.cannotQueryDataFromTwoAPIsFromTheSameStruct(lhs.api, rhs.api)
        }
        let components = lhs.components.merging(rhs.components) { $0 + $1 }
        return GraphQLQuery(name: lhs.name,
                            api: lhs.api,
                            components: components)
    }
    
    static func + (lhs: GraphQLQuery?, rhs: GraphQLQuery) throws -> GraphQLQuery {
        return try lhs.map { try $0 + rhs } ?? rhs
    }
    
}
