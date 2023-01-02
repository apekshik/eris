//
//  CreateValidator.swift
//  eris
//
//  Created by Madhan Mohan on 1/2/23.
//

import Foundation

struct CreateValidator {
    // Validator to check for user input and throw errors for all possible invalid inputs
    func validate(_ review: Review) throws {
        if review.relation.isEmpty {
            throw CreateValidatorError.invalidRelation
        }
        if review.comment.isEmpty {
            throw CreateValidatorError.invalidComment
        }
        if review.experienceWithThem.isEmpty {
            throw CreateValidatorError.invalidExperience
        }
    }
}

extension CreateValidator {
    enum CreateValidatorError: LocalizedError {
        case invalidRelation
        case invalidComment
        case invalidExperience
    }
}

extension CreateValidator.CreateValidatorError {
    
    var errorDescription: String? {
        switch self {
        case .invalidRelation:
            return "Relation to reviewee can't be empty"
        case .invalidComment:
            return "Comment about reviewee can't be empty"
        case .invalidExperience:
            return "Experience with reviewee can't be empty"
        }
    }
}
