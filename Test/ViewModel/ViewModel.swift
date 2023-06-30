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
        
        return OptionViewModel(options_id: opt.id, options_name: opt.name, options_img_url: opt.icon, isRadioButtonSelected: isRadioButtonSelected)
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> CellViewModel {
        return cellViewModels[indexPath.section]
    }
    
    func getOptionViewModel(at indexPath: IndexPath) -> OptionViewModel{
        
        let optionViewModel = cellViewModels[indexPath.section].optionViewModel
        return optionViewModel[indexPath.row]
    }
    
    
    func updateDataArray(parentViewTag:Int,childViewTag:Int,updatedCellViewModel:[CellViewModel]){
        
        let selectedObj = self.cellViewModels[parentViewTag]
        let selectedChildObj = selectedObj.optionViewModel[childViewTag]

//        var updatedCellViewModelData = [CellViewModel]()
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
    }
}
