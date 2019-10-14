//
//  PlusMenuViewModel.swift
//  ARFoodFinal
//
//  Created by 박용훈 on 23/09/2019.
//  Copyright © 2019 Koushan Korouei. All rights reserved.
//

import Foundation

class PlusMenuViewModel {
    let categoryList: [String] = ["TV", "Laptop" ,"Microwave"]
    let appliances: [Appliance] = [
                                    Appliance("TV", "QLED", "QN65Q7FN", "13년 연속 세계 판매 1위\n\n 49년 역사의 삼성 TV는 혁신을 거듭하여 13년 연속 세계 판매 1위를 지켜오고 있습니다.\n\n 더 크게! 더 선명하게! 더 똑똑하게! QLED가 새로워졌습니다."),
                                   Appliance("TV", "Seriff", "UN40LS001AF", "Serif Design by Bouroullec \n\n 알파벳 Ｉ를 닮은 The Serif의 아이코닉 디자인이 더욱 날렵하고 정교해졌습니다. \n 시간이 흘러도 변함없이 아름다운 TV로 당신의 공간에 감성을 채워보세요."),
                                   Appliance("Microwave", "Microwave", "PS50GAZUA", "시크하고 감각적인 디자인 \n\n 양쪽 끝을 라운딩 처리한 디자인으로 더욱 깔끔하고 고급스럽습니다.\n\n\n 쾌속해동 Plus로 더 빠르고 편리하게 \n\n 기존 전자레인지 대비 냉동식품을 30 % 더 빠르게 해동시켜주는 쾌속해동 Plus로 음식 준비 시간을 단축시켜줍니다."),
                                   Appliance("Laptop", "Laptop", "PI100GAZUA", "최적의 노트북 사용을 위해 새롭게 탄생한 솔리디티 디자인 \n\n 견고한 메탈 바디, 세련된 다이아컷.\n\n\n 견고하고 강한 알루미늄 소재를 사용하여 솔리디티 디자인을 완성하였습니다. 또한 측면의 다이아 컷으로 메탈의 엣지를 살렸습니다.")]
    
    init(){
        print("PlusMenuViewModel init")
    }
    
    func printVM () {
        print("Hi this is PlusMenuVM")
    }
    
}

