//
//  AuthProvider.swift
//  HateDatingApp
//
//  Created by Prithviraj Murthy on 30/06/18.
//  Copyright © 2018 Prithviraj Murthy. All rights reserved.
//

import Foundation
import FirebaseAuth

typealias loginHandler  = (_ msg : String?) -> Void

struct LoginErrorCode {
    
    static let INVALID_EMAIL = "Invalid email address"
    static let WRONG_PASSWORD = "Wrong password"
    static let USER_NOT_FOUND = "User not found, Please Register"
    static let EMAIL_ALREADY_IN_USE = "Email Alread In Use"
    static let WEAK_PASSWORD = "Password should be atleast 6 characters long"
    
}

class AuthProvider {
    private static let _instance = AuthProvider()
    
    static var Instance: AuthProvider {
        return _instance
    }
    
    func login(withEmail: String, password: String, loginHandler: loginHandler?){
        
        
        Auth.auth().signIn(withEmail: withEmail, password: password) { (user, error) in
            
            if error != nil {
                self.handleErrors(err: error as! NSError, loginHandler: loginHandler)
            }else{
                loginHandler?(nil)
            }
        }
    }
    
    func signUp(withEmail: String, password: String, loginHandler: loginHandler?) {
        
        Auth.auth().createUser(withEmail: withEmail, password: password) { (user, error) in
            
            if error != nil {
                self.handleErrors(err: error! as NSError, loginHandler: loginHandler)
            } else {
                
                if user?.additionalUserInfo != nil {
                    // Store the user in the database
                    
                    //Login the user
                    
                    self.login(withEmail: withEmail, password: password, loginHandler: loginHandler)
                    
                }
                
            }
            
        }
        
    }
    
    func logOut() -> Bool {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                return true
            } catch {
                return false
            }
        }
        
        return true
    }
    
    private func handleErrors(err: NSError, loginHandler: loginHandler?){
        
        if let errCode = AuthErrorCode(rawValue: err.code) { //Testing if we have any error
            
            switch errCode {

            case .invalidEmail:
                loginHandler?(LoginErrorCode.INVALID_EMAIL)
                break;
                
            case .wrongPassword:
                loginHandler?(LoginErrorCode.WRONG_PASSWORD)

                break;
                
            case .emailAlreadyInUse:
                loginHandler?(LoginErrorCode.EMAIL_ALREADY_IN_USE)

                break;
                
            case .userNotFound:
                loginHandler?(LoginErrorCode.USER_NOT_FOUND)

                break;
                
            case .weakPassword:
                loginHandler?(LoginErrorCode.WEAK_PASSWORD)

                break;
                
            default:
                break;
                
            }

        }
    }
}
