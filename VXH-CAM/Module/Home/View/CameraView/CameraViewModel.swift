//
//  HomeViewModel.swift
//  Celeritas_Test
//
//  Created by Admin on 3/30/24.
//

import Foundation

protocol CameraViewDelegate : AnyObject {
    func moveToHome(users: UserModel)
    func ifError(error: ServerErrorResponse)
}
class CameraViewModel : BaseViewModel {
    
    let homeRepostiory : CameraRepository = CameraRepository()
    weak var delegate : CameraViewDelegate?
    var pageNo = 1
    
    init(binding: CameraViewDelegate) {
        super.init()
        self.delegate = binding
        getAllUserData()
    }
    func getAllUserData() {
        self.isLoading = true
        let appendingUrl = "?page=\(pageNo)"
        homeRepostiory.getAllUsers(appendingUrl: appendingUrl) {[weak self] res in
            guard let self else { return }
            self.isLoading = false
            if let res {
                self.delegate?.moveToHome(users: res)
            }
        } errorCompletion: { serverError, error in
            self.isLoading = false
            if let serverError {
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    self.delegate?.ifError(error: ServerErrorResponse(message: serverError.message ?? "Something went wrong"))
                }
            }
            if let error = error {
                self.delegate?.ifError(error: ServerErrorResponse(message: error))
            }
        }

    }
    
    
}
