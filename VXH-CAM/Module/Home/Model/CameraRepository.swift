//
//  HomeRepository.swift
//  Celeritas_Test
//
//  Created by Admin on 3/31/24.
//

import Foundation
class CameraRepository: BaseRepository {
    private var remoteDataSource: UserRemoteDataSource!
    
    override init() {
        super.init()
        remoteDataSource = UserRemoteDataSource()
    }
    func getAllUsers(appendingUrl:String?, completion: @escaping (UserModel?) -> (), errorCompletion: @escaping (ServerErrorResponse?, String?) -> () ) {
        
        remoteDataSource.getAllUsers(appendingUrl:appendingUrl) {
            (user, failure) in
            guard failure == nil else {
                self.switchFailure(failure!, errorCompletion: errorCompletion)
                return
            }
            completion(user)
        }
    }
}
