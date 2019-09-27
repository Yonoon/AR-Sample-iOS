//
//  Appliance.swift
//  SamsungAR
//
//  Created by yonghoon park on 24/09/2019.
//  Copyright © 2019 samsung. All rights reserved.
//

struct Appliance {
    let category: String //TV
    let type: String //QLED
    let model: String // QN65Q7FN

    let description: String

    init(_ category: String, _ type: String, _ model: String, _ description: String) {
        self.category = category
        self.type = type
        self.model = model
        self.description = description
    }
}

