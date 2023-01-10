//
//  Examples.swift
//  eris
//
//  Created by Apekshik Panigrahi on 12/28/22.
//

import Foundation

let exampleUsers: [User] =  [
  User(firestoreID: "j7ZfXsnfHvXm2C6OiqnOCXUmbpj2", firstName: "Tim", lastName: "Henson", userName: "timTheHenson", email: "test2@gmail.com", blockedUsers: []),
  User(firestoreID: "j7ZfXsnfHvXm2C6OiqnOCXUmbpj2", firstName: "Rob", lastName: "Myers", userName: "halloween", email: "test2@gmail.com", blockedUsers: []),
  ]


let exampleReviews: [Post] = [
  Post(uid: "", authorID: "", reviewID: "", createdAt: Date(),
         relation: "Ex-",
         comment: "You really won't believe what he had for dinner: SUSHI. F**KING Sushi. Like I really don't know how else...",
         rating: 1,
         experienceWithThem: "Fantastic"),
  Post(uid: "", authorID: "", reviewID: "", createdAt: Date(),
         relation: "Co-Worker",
         comment: "You really won't believe what he had for dinner: SUSHI. F**KING Sushi. Like I really don't know how else...",
         rating: 1,
         experienceWithThem: "Fantastic"),
  Post(uid: "", authorID: "", reviewID: "", createdAt: Date(),
         relation: "Friend",
         comment: "You really won't believe what he had for dinner: SUSHI. F**KING Sushi. Like I really don't know how else...",
         rating: 1,
         experienceWithThem: "Fantastic"),
  Post(uid: "", authorID: "", reviewID: "", createdAt: Date(),
         relation: "Friend",
         comment: "You really won't believe what he had for dinner: SUSHI. F**KING Sushi. Like I really don't know how else...",
         rating: 1,
         experienceWithThem: "Fantastic"),
  Post(uid: "", authorID: "", reviewID: "", createdAt: Date(),
         relation: "Friend",
         comment: "You really won't believe what he had for dinner: SUSHI. F**KING Sushi. Like I really don't know how else...",
         rating: 1,
         experienceWithThem: "Fantastic"),
  Post(uid: "", authorID: "", reviewID: "", createdAt: Date(),
         relation: "Friend",
         comment: "You really won't believe what he had for dinner: SUSHI. F**KING Sushi. Like I really don't know how else...",
         rating: 1,
         experienceWithThem: "Fantastic"),
]

let exampleComments: [Comment] = [
    Comment(authorID: "", authorUserName: "cobraTate", reviewID: "", content: "Lmao what the hell happened?"),
    Comment(authorID: "", authorUserName: "chuckNorris", reviewID: "", content: "Lorem Ipsum lmao what the hell happened?"),
    Comment(authorID: "", authorUserName: "ladiesMan2698", reviewID: "", content: "No way bro. Eat KFC. Real Chicken!!!"),
    Comment(authorID: "", authorUserName: "guitarNerd420", reviewID: "", content: "Have you ever sat in a room with someone who vapes? Breathe AIR"),
    Comment(authorID: "", authorUserName: "guitarNerd420", reviewID: "", content: "Never seen someone who doesn't start eating gluten as soon as you slap the shit outta them a few times."),
]
