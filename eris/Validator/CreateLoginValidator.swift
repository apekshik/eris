//
//  CreateLoginValidator.swift
//  eris
//
//  Created by Madhan Mohan on 1/3/23.
//

import Foundation

struct CreateLoginValidator {
    // Validator to check for user input and throw errors for all possible invalid inputs
    func validateLogin(_ user: User) throws {
        if user.firstName.isEmpty {
            throw CreateLoginValidatorError.invalidfirstName
        }
        if user.lastName.isEmpty {
            throw CreateLoginValidatorError.invalidlastName
        }
        if user.userName.isEmpty {
            throw CreateLoginValidatorError.invaliduserName
        }
        if user.email.isEmpty {
            throw CreateLoginValidatorError.invalidemail
        }
    }
}

extension CreateLoginValidator {
    enum CreateLoginValidatorError: LocalizedError {
        case invalidfirstName
        case invalidlastName
        case invaliduserName
        case invalidemail
    }
}

extension CreateLoginValidator.CreateLoginValidatorError {
    
    var errorDescription: String? {
        switch self {
        case .invalidfirstName:
            return "first name field can't be empty"
        case .invalidlastName:
            return "last name field can't be empty"
        case .invaliduserName:
            return "username field can't be empty"
        case .invalidemail:
            return "email can't be empty"
        }
    }
}
