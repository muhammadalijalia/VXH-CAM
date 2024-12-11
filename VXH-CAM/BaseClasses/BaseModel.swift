//
//  BaseModel.swift
//  Celeritas_Test
//
//  Created by Admin on 3/31/24.
//

import Foundation
struct EncryptionModel: Codable {
    var iv: String?
    var encryptedData: String?
}
struct ServerErrorResponse: Decodable {
    var code: Int?
    var message: String?
}
struct CustomServerError : Decodable {
    var errors : [ErrorModel]
}
struct ErrorModel : Decodable{
    var Password : String
}
struct PaymentErrorResponse: Decodable {
    var error: ErrorMessage?
}
struct ErrorMessage : Decodable {
    var code : String
    var message : String
}
struct PhoneVerifyFailure : Decodable{
    var message : String?
}

class ResponseModel : Decodable {
    var message : String?
    var status: Bool?
}

