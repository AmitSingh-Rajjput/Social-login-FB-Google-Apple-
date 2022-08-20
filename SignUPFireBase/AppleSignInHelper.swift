//
//  AppleSignInHelper.swift
//  SignUPFireBase
//
//  Created by Amit Kumar Singh on 25/04/22.
//

import Foundation
import AuthenticationServices

extension ViewController {
    
    func appleLogin() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}


@available(iOS 13.0, *)
extension ViewController : ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding{
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            appleIDProvider.getCredentialState(forUserID: appleIDCredential.user) { [weak self] (state, error) in
                switch state {
                case .authorized:
                    var name: String = ""
                    if let nameComponent = appleIDCredential.fullName, !nameComponent.description.isEmpty{
                        name = (nameComponent.givenName ?? "") + " " + (nameComponent.familyName ?? "")
                    }
                    
                    var email: String?
                    if let emailComponent = appleIDCredential.email, !emailComponent.isEmpty{
                        email = emailComponent
                    }
                    DispatchQueue.main.async { [weak self] in
                        print(appleIDCredential.user , name , email)
                    }
                default:
                    print(error?.localizedDescription ?? "")
            }
        }
        }}
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error.localizedDescription)
    }
}

struct AppleUser {
    let userId: String
    let name: String?
    let email: String?
    
    init(userId: String, name: String?, email: String?) {
        self.userId = userId
        self.name = name
        self.email = email
    }
}
