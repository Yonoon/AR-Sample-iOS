//
//  PlusMenuViewModel.swift
//  ARFoodFinal
//
//  Created by 박용훈 on 23/09/2019.
//  Copyright © 2019 Koushan Korouei. All rights reserved.
//

import Foundation

class PlusMenuViewModel {
    let categoryList: [String] = ["TV"]
    let appliances: [Appliance] = [Appliance("TV", "QLED", "QN65Q7FN", "13년 연속 세계 판매 1위\n\n 49년 역사의 삼성 TV는 혁신을 거듭하여 13년 연속 세계 판매 1위를 지켜오고 있습니다.\n\n 더 크게! 더 선명하게! 더 똑똑하게! QLED가 새로워졌습니다."),
                                   Appliance("TV", "Seriff", "UN40LS001AF", "Serif Design by Bouroullec \n\n 알파벳 Ｉ를 닮은 The Serif의 아이코닉 디자인이 더욱 날렵하고 정교해졌습니다. \n 시간이 흘러도 변함없이 아름다운 TV로 당신의 공간에 감성을 채워보세요.")]

    init(){
        print("PlusMenuViewModel init")
    }

    func printVM () {
        print("Hi this is PlusMenuVM")
    }

}
