//
//  ViewModel.swift
//  Test
//
//  Created by Deepak on 29/06/23.
//

import Foundation

class ViewModel:NSObject{
    
    var reloadTableView: (() -> Void)?
    var facilities = [Facility]()
    var exclusions = [[Exclusion]]()
    
    var cellViewModels = [CellViewModel]() {
        didSet {
            reloadTableView?()
        }
    }

    func getFacilityWithOptions() {
        
        ApiService().getData(completion: { success,model,error in
            
            if success, let responseData = model{
                self.exclusions = responseData.exclusions
                self.fetchData(facilities: responseData.facilities)
            }else{
                print(error!)
            }
        })
    }

    func fetchData(facilities:[Facility]){
        
        var cvm = [CellViewModel]()
        
        for obj in facilities{
            
            var optionViewModel = [OptionViewModel]()
            
            for oVm in obj.options{
                optionViewModel.append(self.createCellModel(opt: oVm, isRadioButtonSelected: false))
            }
            cvm.append(CellViewModel(facility_id: obj.facilityID, facility_name: obj.name, optionViewModel: optionViewModel))
        }
        
        if cellViewModels.count > 0{
            for cellViewModel in cvm{
                cellViewModels.append(cellViewModel)
            }
        }else{
            cellViewModels = cvm
         }
    }
    
    func createCellModel(opt: Option,isRadioButtonSelected:Bool) -> OptionViewModel {
        
        return OptionViewModel(options_id: opt.id, options_name: opt.name, options_icon_name: opt.icon, isRadioButtonSelected: isRadioButtonSelected)
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> CellViewModel {
        return cellViewModels[indexPath.section]
    }
    
    func getOptionViewModel(at indexPath: IndexPath) -> OptionViewModel{
        
        let optionViewModel = cellViewModels[indexPath.section].optionViewModel
        return optionViewModel[indexPath.row]
    }
    
    
    func updateDataArray(parentViewTag:Int,childViewTag:Int,updatedCellViewModel:[CellViewModel]) -> Bool{
        
        let selectedObj = self.cellViewModels[parentViewTag]
        let selectedChildObj = selectedObj.optionViewModel[childViewTag]

        var is_first_exclusions_combinations_exist = false
        var is_second_exclusions_combinations_exist = false
        
        for exclusionArrayObj in self.exclusions{
            
            is_first_exclusions_combinations_exist = false
            is_second_exclusions_combinations_exist = false
            
            for exclusionObj in exclusionArrayObj{
                
                for facilityObj in updatedCellViewModel{
                    
                    for optionObj in facilityObj.optionViewModel{
                        
                        if optionObj.isRadioButtonSelected{
                            
                            if ((facilityObj.facility_id == exclusionObj.facilityID) && (optionObj.options_id == exclusionObj.optionsID)){
                                is_first_exclusions_combinations_exist = true
                            }
                        }else if ((selectedObj.facility_id == exclusionObj.facilityID) && (selectedChildObj.options_id == exclusionObj.optionsID)){
                            is_second_exclusions_combinations_exist = true
                        }
                        if is_first_exclusions_combinations_exist && is_second_exclusions_combinations_exist{
                            break
                        }
                    }
                    if is_first_exclusions_combinations_exist && is_second_exclusions_combinations_exist{
                        break
                    }
                }
                if is_first_exclusions_combinations_exist && is_second_exclusions_combinations_exist{
                    break
                }
            }
            if is_first_exclusions_combinations_exist && is_second_exclusions_combinations_exist{
                break
            }
        }
        
        if is_first_exclusions_combinations_exist && is_second_exclusions_combinations_exist{
            return true
        }else{
            var updatedCellViewModelData = updatedCellViewModel
            
            for obj in self.cellViewModels{
                
                if obj.facility_id == selectedObj.facility_id{
                    
                    var optionViewModel = [OptionViewModel]()
                    
                    for oVm in obj.optionViewModel{
                        
                        var optionViewModelObj = oVm
                        
                        if oVm.options_id == selectedChildObj.options_id{
                            optionViewModelObj.isRadioButtonSelected = true
                        }else{
                            optionViewModelObj.isRadioButtonSelected = false
                        }
                        optionViewModel.append(optionViewModelObj)
                    }
                    updatedCellViewModelData.remove(at: parentViewTag)
                    updatedCellViewModelData.insert(CellViewModel(facility_id: obj.facility_id, facility_name: obj.facility_name, optionViewModel: optionViewModel), at: parentViewTag)
                 }
             }
            self.cellViewModels = updatedCellViewModelData
            return false
        }
    }
}
