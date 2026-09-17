import Foundation

enum APIConstants {

    //static let baseURL =  "https://kaushal.rural.gov.in/backend/"      //Live
     static let baseURL =  "https://kaushal.dord.gov.in/demobackend/"      //demo


    static let apiBackend = "kaushalpanjee/"

    static let apiCitizen = "panjeeapi/"

    static let login = apiBackend + apiCitizen + "login"

    static let generateToken = apiBackend + apiCitizen + "generateToken"
    
    
    static let sendMobileOTP =  apiBackend + apiCitizen + "generateMobileOtp"

    static let sendEmailOTP = apiBackend + apiCitizen + "generateMailOtp"
    
    static let validateOTP =   apiBackend + apiCitizen + "validateOtp"
    
    
    static let stateOtpList =   apiBackend + apiCitizen + "stateOTPVerifiedList"
    
    
    static let checkUserExistance =   apiBackend + apiCitizen + "checkUserExistance"
    
    static let insertAadhaarTxn =   apiBackend + apiCitizen + "saveAadhaarTxn"
        
    static let API_CREATE_USER =   apiBackend + apiCitizen + "createUser"
    
    static let getUnnati = apiBackend + apiCitizen + "getLink"
}
