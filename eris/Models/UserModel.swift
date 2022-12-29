//
//  UserModel.swift
//  eris
//
//  Created by Apekshik Panigrahi on 12/27/22.
//

import Foundation

// MARK: User model to store users in firestore database.
struct User: Codable, Identifiable  {
    var id = UUID()
    let firstName: String
    let lastName: String
    var fullName: String { // a computable property
        return firstName + " " + lastName
    }
    var userName: String
    let email: String
    // MARK: Computable property to store all keywords for search functionality.
    var keywordsForLookup: [String] {
        // flatMap() -> Returns an array containing the concatenated results of calling the given transformation with each element of this sequence.
        [self.userName.generateStringSequence(), self.fullName.generateStringSequence(), self.firstName.generateStringSequence(), self.lastName.generateStringSequence()].flatMap { $0 }
    }
    
    enum CodingKeys: String, CodingKey {
        case firstName
        case lastName
        case userName
        case email
        // case fullName -> We don't need to store this in the DB since we can always decode and compute this inexpensive property.

    }
}

extension String {
    // MARK: generates contiguous subsequences of the given string always starting from
    // the first character in the input string.
    func generateStringSequence() -> [String] {
        /// Ex: "Apek" => ["A", "Ap", "Ape", "Apek"]
        guard self.count > 0 else { return [] }
        var sequences: [String] = []
        for i in 1...self.count {
            // prefix() Returns a subsequence, up to the specified maximum length, containing the initial elements of the collection (from Apple Developer Docs).
            sequences.append(String(self.prefix(i)))
        }
        return sequences
    }
}



