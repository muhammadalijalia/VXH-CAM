//
//  UserRemoteDataSource.swift
//  Celeritas_Test
//
//  Created by Admin on 3/31/24.
//

import Foundation
struct UserRemoteDataSource {
    func getAllUsers(appendingUrl: String?, completion: @escaping (UserModel?,Failure?) -> ()) {
        Router.APIRouter(endPoint: .allusers,appendingURL: appendingUrl, parameters: nil, method: .get) { response in
            switch response {
            case .success(let success):
                guard let data = try? JSONDecoder().decode(UserModel.self, from: success.data) else {
                    completion(nil, Failure(message: "Unable to parse User Data", state: .unknown, data: nil, code: nil))
                    return
                }
                completion(data,nil)
            case .failure(let failure):
                completion(nil,failure)
            }
        }
    }
    
}
