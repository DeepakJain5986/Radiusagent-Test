//
//  CellViewModel.swift
//  Test
//
//  Created by Deepak on 29/06/23.
//

import Foundation

struct CellViewModel{
    
    var facility_id:String
    var facility_name:String
    var optionViewModel = [OptionViewModel]()
}

struct OptionViewModel{
    
    var options_id:String
    var options_name:String
    var options_icon_name:String
    var isRadioButtonSelected:Bool
}

