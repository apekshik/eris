//
//  CreateValidator.swift
//  eris
//
//  Created by Madhan Mohan on 1/2/23.
//

import Foundation

struct CreateReviewFormValidator {
    // Validator to check for user input and throw errors for all possible invalid inputs
    func validateForm(_ review: Review) throws {
        if review.relation.isEmpty {
            throw CreateReviewFormValidatorError.invalidRelation
        }
        if review.comment.isEmpty {
            throw CreateReviewFormValidatorError.invalidComment
        }
        if review.experienceWithThem.isEmpty {
            throw CreateReviewFormValidatorError.invalidExperience
        }
    }
}

extension CreateReviewFormValidator {
    enum CreateReviewFormValidatorError: LocalizedError {
        case invalidRelation
        case invalidComment
        case invalidExperience
    }
}

extension CreateReviewFormValidator.CreateReviewFormValidatorError {
    
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
