import Foundation

struct StateDataResponse: Decodable {

    let responseCode: Int?
    let responseDesc: String?
    let stateList: [StateItem]?
}

struct StateItem: Decodable, Identifiable, Hashable {

    let stateName: String
    let stateCode: String
    let lgdStateCode: String

    var id: String {
        stateCode
    }
}
