//
//  CatOrArData.swift
//  MealBook
//
//  Created by Ivan on 18.10.2020.
//  Copyright © 2020 Ivan. All rights reserved.
//

import Foundation

struct CatOrArData: Decodable {
    let meals: [CatOrAr]
}

struct CatOrAr: Decodable {
    let strCategory: String?
    let strArea: String?
}
