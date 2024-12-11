//
//  BaseView.swift
//  Celeritas_Test
//
//  Created by Admin on 3/30/24.
//

import SwiftUI

struct BaseView<Content: View>: View {
   
    
    
    /// MARK:- Variables:
//    let nullView: NullDataView = NullDataView()
    var viewModel: BaseViewModel? = BaseViewModel() {
        didSet {
            self.commonInit()
        }
    }
    let content: Content
 
    
    /// Performs common initialization tasks for the view controller.
    /// This method sets up bindings with loader status, toast status, and failure response from the view model.
    /// These bindings ensure that the UI is updated based on changes in the loader status, toast messages, and failure responses.
    func commonInit() {
        self.bindWithLoaderStatus()
        self.bindWithToastStatus()
        self.bindWithFailureResponse()
    }
    
    /// Binds the view controller with the loader status from the view model.
    /// This method sets up a loading closure that is called when the loading status changes.
    /// When isLoading is true, it shows the loader, and when isLoading is false, it hides the loader.
    /// The operations are performed on the main queue to ensure UI updates are handled properly.
    private func bindWithLoaderStatus() {
        viewModel?.setLoading = { (isLoading) in
            if isLoading {
                DispatchQueue.main.async {
                    Loader.getInstance().showLoader()
                }
            } else {
                DispatchQueue.main.async {
                    Loader.getInstance().hideLoader()
                }
            }
        }
    }
    
    /// Binds the toast status from the view model to the UI.
    /// This method sets up a closure that is called when a toast message is received from the view model.
    /// It displays the toast message as a success alert view on the main queue.
    private func bindWithToastStatus() {
        viewModel?.setToastView = { (message) in
            DispatchQueue.main.async {
                self.showToast(message: message)
            }
        }
    }
    
    /// Binds the failure response from the view model to the UI.
    /// This method sets up a closure that is called when a failure message is received from the view model.
    /// It displays the failure message as an alert view on the main queue.
    private func bindWithFailureResponse() {
        viewModel?.setFailureMessage = {
            (message) in
            DispatchQueue.main.async {
                self.showToast(message: message)
            }
        }
    }
    
    init(viewModel: BaseViewModel? = BaseViewModel(), @ViewBuilder content: () -> Content) {
        self.viewModel = viewModel
        self.content = content()
    }
    var body: some View {
        content
    }
} /// class end here:
