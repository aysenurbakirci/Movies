//
//  Service.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 11.10.2021.
//

import Foundation

let 🔑 = "96c151da77643172f784ee17f262df9a"
let baseURL = "https://api.themoviedb.org/3/"

enum CategoryType: String {
    case movie = "movie"
    case person = "person"
}

enum MovieDetailType: String {
    case credits = "credits"
    case videos = "videos"
}

enum Language: String {
    case US = "en-US"
}
