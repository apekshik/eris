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
         caption: "You really won't believe what he had for dinner: SUSHI. F**KING Sushi. Like I really don't know how else...",
         rating: 1,
       experienceWithThem: "Fantastic", imageURL: URL(string: "gs://fir-eris.appspot.com/TestImages/Apek1Large.jpeg"), username: "epicShit"),
  Post(uid: "", authorID: "", reviewID: "", createdAt: Date(),
         relation: "Co-Worker",
         caption: "You really won't believe what he had for dinner: SUSHI. F**KING Sushi. Like I really don't know how else...",
         rating: 1,
       experienceWithThem: "Fantastic", imageURL: URL(string: "gs://fir-eris.appspot.com/TestImages/Mad1Large.jpeg"), username: "Madhansolo"),
  Post(uid: "", authorID: "", reviewID: "", createdAt: Date(),
         relation: "Friend",
         caption: "You really won't believe what he had for dinner: SUSHI. F**KING Sushi. Like I really don't know how else...",
         rating: 1,
         experienceWithThem: "Fantastic", imageURL: nil, username: "jerryRigsEverything"),
  Post(uid: "", authorID: "", reviewID: "", createdAt: Date(),
         relation: "Friend",
         caption: "You really won't believe what he had for dinner: SUSHI. F**KING Sushi. Like I really don't know how else...",
         rating: 1,
         experienceWithThem: "Fantastic", imageURL: nil, username: "sweet"),
  Post(uid: "", authorID: "", reviewID: "", createdAt: Date(),
         relation: "Friend",
         caption: "You really won't believe what he had for dinner: SUSHI. F**KING Sushi. Like I really don't know how else...",
         rating: 1,
         experienceWithThem: "Fantastic", imageURL: nil, username: "nikki"),
  Post(uid: "", authorID: "", reviewID: "", createdAt: Date(),
         relation: "Friend",
         caption: "You really won't believe what he had for dinner: SUSHI. F**KING Sushi. Like I really don't know how else...",
         rating: 1,
         experienceWithThem: "Fantastic", imageURL: nil, username: "TSM_imperialhal"),
]

let exampleComments: [Comment] = [
    Comment(authorID: "", authorUserName: "cobraTate",
            reviewID: "",
            content: "Lmao what the hell happened?",
            createdAt: Date(),
            chainPostID: nil),
    Comment(authorID: "", authorUserName: "chuckNorris",
            reviewID: "",
            content: "Lorem Ipsum lmao what the hell happened?",
            createdAt: Date(),
            chainPostID: nil),
    Comment(authorID: "", authorUserName: "ladiesMan2698",
            reviewID: "",
            content: "No way bro. Eat KFC. Real Chicken!!!",
            createdAt: Date(),
            chainPostID: nil),
    Comment(authorID: "", authorUserName: "guitarNerd420",
            reviewID: "",
            content: "Have you ever sat in a room with someone who vapes? Breathe AIR",
            createdAt: Date(),
            chainPostID: nil),
    Comment(authorID: "", authorUserName: "guitarNerd420",
            reviewID: "",
            content: "Never seen someone who doesn't start eating gluten as soon as you slap the shit outta them a few times.",
            createdAt: Date(),
            chainPostID: nil),
]


let exampleLivePosts: [LivePost] = [
  LivePost(
    userID: "",
    authorID: "",
    selfID: "",
    createdAt: Date(),
    text: "test live post 1 gonna flood these with text to see the limits of the scroll view",
    authorUsername: "epicShit",
    recipientUsername: "madhansolo",
    anonymous: false
  ),
  LivePost(
    userID: "",
    authorID: "",
    selfID: "",
    createdAt: Date(),
    text: "test live post 2 more flooding of text. Hmmm... What more could I write to make this longer? How about some more? Maybe even more? No, even more",
    authorUsername: "Ananya",
    recipientUsername: "potatoHead",
    anonymous: false
  ),
  LivePost(userID: "", authorID: "", selfID: "", createdAt: Date(), text: "test live post 3", authorUsername: "Aniket", recipientUsername: "Ananya", anonymous: false),
  LivePost(userID: "", authorID: "", selfID: "", createdAt: Date(), text: "test live post 4", authorUsername: "Dips", recipientUsername: "madhansolo", anonymous: true),
  LivePost(userID: "", authorID: "", selfID: "", createdAt: Date(), text: "test live post 5", authorUsername: "Dips", recipientUsername: "Ananya", anonymous: false),
  LivePost(userID: "", authorID: "", selfID: "", createdAt: Date(), text: "test live post 6", authorUsername: "epicShit",recipientUsername: "madhansolo", anonymous: false),
  LivePost(userID: "", authorID: "", selfID: "", createdAt: Date(), text: "test live post 1 gonna flood these with text to see the limits of the scroll view", authorUsername: "epicShit", recipientUsername: "madhansolo", anonymous: false),
  LivePost(userID: "", authorID: "", selfID: "", createdAt: Date(), text: "test live post 2 more flooding of text. Hmmm... What more could I write to make this longer? How about some more? Maybe even more?", authorUsername: "Ananya", recipientUsername: "madhansolo", anonymous: false),
  LivePost(userID: "", authorID: "", selfID: "", createdAt: Date(), text: "test live post 3", authorUsername: "Aniket", recipientUsername: "madhansolo", anonymous: false),
  LivePost(userID: "", authorID: "", selfID: "", createdAt: Date(), text: "test live post 4", authorUsername: "Dips", recipientUsername: "epicShit", anonymous: true),
  LivePost(userID: "", authorID: "", selfID: "", createdAt: Date(), text: "test live post 5", authorUsername: "Dips", recipientUsername: "epicShit", anonymous: false),
  LivePost(userID: "", authorID: "", selfID: "", createdAt: Date(), text: "test live post 6", authorUsername: "epicShit",recipientUsername: "Dips", anonymous: false),
  LivePost(userID: "", authorID: "", selfID: "", createdAt: Date(), text: "test live post 1 gonna flood these with text to see the limits of the scroll view", authorUsername: "epicShit",recipientUsername: "madhansolo", anonymous: false),
  LivePost(userID: "", authorID: "", selfID: "", createdAt: Date(), text: "test live post 2 more flooding of text. Hmmm... What more could I write to make this longer? How about some more? Maybe even more?", authorUsername: "Ananya", recipientUsername: "madhansolo", anonymous: false),
  LivePost(userID: "", authorID: "", selfID: "", createdAt: Date(), text: "Test live post 3 just going to throw in some random shit", authorUsername: "Aniket", recipientUsername: "Dips", anonymous: false),
  LivePost(userID: "", authorID: "", selfID: "", createdAt: Date(), text: "Test live post 4. more random shit", authorUsername: "Dips", recipientUsername: "potatoHead", anonymous: true),
  LivePost(userID: "", authorID: "", selfID: "", createdAt: Date(), text: "Test live post 5. alittle more a little less. Just to test more", authorUsername: "Dips", recipientUsername: "madhansolo", anonymous: false),
  LivePost(userID: "", authorID: "", selfID: "", createdAt: Date(), text: "Test live post 6. Hommmm how about this? ", authorUsername: "epicShit", recipientUsername: "Dips", anonymous: false),
  LivePost(userID: "", authorID: "", selfID: "", createdAt: Date(), text: "test live post 1 gonna flood these with text to see the limits of the scroll view", authorUsername: "epicShit", recipientUsername: "madhansolo", anonymous: false),
  LivePost(userID: "", authorID: "", selfID: "", createdAt: Date(), text: "test live post 2 more flooding of text. Hmmm... What more could I write to make this longer? How about some more? Maybe even more?", authorUsername: "Ananya", recipientUsername: "driptendu", anonymous: false),
  LivePost(userID: "", authorID: "", selfID: "", createdAt: Date(), text: "test live post 3", authorUsername: "Aniket", recipientUsername: "potatoHead", anonymous: false),
  LivePost(userID: "", authorID: "", selfID: "", createdAt: Date(), text: "test live post 4", authorUsername: "Dips", recipientUsername: "madhansolo", anonymous: true),
  LivePost(userID: "", authorID: "", selfID: "", createdAt: Date(), text: "test live post 5", authorUsername: "Dips", recipientUsername: "driptendu", anonymous: false),
  LivePost(userID: "", authorID: "", selfID: "", createdAt: Date(), text: "test live post 6", authorUsername: "epicShit", recipientUsername: "madhansolo", anonymous: false)
]

let exampleChainPosts: [ChainPost] = [
  ChainPost(authorID: "", authorPostID: "", recipientID: "", recipientPostID: "", chain: [], mostRecentPostTime: Date())
]
