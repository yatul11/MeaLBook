//
//  MealModel.swift
//  MealBook
//
//  Created by Ivan on 12.10.2020.
//  Copyright © 2020 Ivan. All rights reserved.
//

import Foundation

struct MealModel {
    let name: String
    let id: String
    let category: String
    let area: String
    let instructions: String
    let tags: String?
    let youtube: String
    var ingridients: [String?]
    var measures: [String?]
    let imageLink: String
}
