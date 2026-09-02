
import Foundation
import XMLCoder

struct CaptureRdResponse: Codable {
    var pidData: PidData
    var txnId: String
}

struct Auth: Codable {
    var uid: String
    var rc: String
    var tid: String
    var ac: String
    var sa: String
    var ver: String
    var txn: String
    var lk: String
    var Uses: Uses?
    var Device: Device?
    var Skey: SKey?
    var Hmac: String
    var Data: DataField?
    var Signature:String
}

struct Uses: Codable {
    var pi: String
    var pa: String
    var pfa: String
    var bio: String
    var bt: String
    var pin: String
    var otp: String
}

struct Device: Codable {
    var rdsId: String
    var rdsVer: String
    var dpId: String
    var dc: String
    var mi: String
    var mc: String
}

struct PidData: Codable {
    let resp: Resp
    let deviceInfo: DeviceInfo
    let skey: SKey
    let hmac: String
    let data: DataField
    let custOpts: CustOpts

    enum CodingKeys: String, CodingKey {
        case resp = "Resp"
        case deviceInfo = "DeviceInfo"
        case skey = "Skey"
        case hmac = "Hmac"
        case data = "Data"
        case custOpts = "CustOpts"
    }
}

struct Resp: Codable {
    let errCode: String
    let errInfo: String
    let fCount: String
    let fType: String
    let iCount: String
    let iType: String
    let pCount: String
    let pType: String
    let nmPoints: String
    let qScore: String
}

struct DeviceInfo: Codable {
    let rdsId: String
    let rdsVer: String
    let dpId: String
    let dc: String
    let mi: String
    let mc: String
}

struct SKey: Codable {
    let ci: String
    let value: String

    enum CodingKeys: String, CodingKey {
        case ci
        case value = ""
    }
}

struct DataField: Codable {
    let type: String
    let value: String

    enum CodingKeys: String, CodingKey {
        case type = "type"
        case value = ""
    }
}

struct CustOpts: Codable {
    var params: [Param]

    enum CodingKeys: String, CodingKey {
        case params = "Param"
    }
}

struct Param: Codable {
    let name: String
    let value: String
}
struct Kyc: Codable {
    let de: String
    let lr: String
    let pfr: String
    let ra: String
    let rc: String
    let ver: String
    let Rad: String

    enum CodingKeys: String, CodingKey {
        case de = "de"
        case lr = "lr"
        case pfr = "pfr"
        case ra = "ra"
        case rc = "rc"
        case ver = "ver"
        case Rad = "Rad"
    }
}
