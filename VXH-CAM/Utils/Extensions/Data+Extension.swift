//
//  Data+Extensionn.swift
//  Celeritas_Test
//
//  Created by Admin on 3/31/24.
//

import Foundation
import CryptoSwift
extension Data {
    init?(hexString: String) {
        let len = hexString.count / 2
        var data = Data(capacity: len)
        for i in 0..<len {
            let j = hexString.index(hexString.startIndex, offsetBy: i*2)
            let k = hexString.index(j, offsetBy: 2)
            if let b = UInt8(hexString[j..<k], radix: 16) {
                data.append(b)
            } else {
                return nil
            }
        }
        self = data
    }
    func convertSecretTo32Bit()-> Data? {
        var keyData = Data(Enviroment.SECRET_KEY.utf8)
        if keyData.count > 32 {
            keyData = keyData.subdata(in: 0..<32)
        } else if keyData.count < 32 {
            keyData.append(contentsOf: repeatElement(0, count: 32 - keyData.count))
        }
        return keyData
    }
    func decryptAESCBC(encryptedDataHexString: String, ivHexString: String) -> Self? {
        guard let encryptedData = Data(hexString: encryptedDataHexString),
              let iv = Data(hexString: ivHexString),
              let keyData = convertSecretTo32Bit() else {
            print("Invalid input strings.")
            return nil
        }
        do {
            let aes = try AES(key: keyData.bytes, blockMode: CBC(iv: iv.bytes), padding: .pkcs7)
            let decryptedData = try aes.decrypt(encryptedData.bytes)
            return Data(decryptedData)
        } catch {
            print("Decryption error: \(error)")
            return nil
        }
    }
}
