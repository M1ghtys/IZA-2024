//
//  SystemThemeHelper.swift
//  ChoresApp
//
//  Created by Jakub Sychra on 22.05.2024.
//

import Foundation
import SwiftUI

// Function that determines the list highlights based on system theme for better readability
//  --  --  --  --  --

func userHighlightByMode(mode: ColorScheme)->Color{
    if(mode == .dark){
        return Color(red:0.106, green:0.416, blue:0.529)
    }else{
        return Color(red:0.843, green:0.988, blue:0.988)
    }
}

func houseHighlightByMode(mode: ColorScheme)->Color{
    if(mode == .dark){
        return Color(red:0.588, green:0.467, blue:0.247)
    }else{
        return Color(red:0.988, green:0.89, blue:0.792)
    }
}
