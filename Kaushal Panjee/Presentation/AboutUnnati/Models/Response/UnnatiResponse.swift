import Foundation

struct UnnatiResponse: Decodable {

    let data: UnnatiData?
    let message: String?
    let responseCode: String?
}

struct UnnatiData: Decodable {

    let DDUGKY: String?
    let NRLM: String?
    let PMKVY: String?
    let PM_VISHWAKARMA: String?
    let RSETI: String?
}
