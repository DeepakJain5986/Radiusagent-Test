//
//  ViewController.swift
//  Test
//
//  Created by Deepak on 29/06/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tblView: UITableView!
    
    var viewModel = ViewModel()

    
//    lazy var viewModel = {
//        ViewModel()
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        initView()
        
        InternetManager.isUnreachable { _ in
            self.showAlert(title: "Alert", message: "Please check your internet connection and try again.")
            return
        }
        
        initViewModel()
    }

    func initView() {
        
        //self.tblView.delegate = self
        //self.tblView.dataSource = self
        self.tblView.separatorColor = .black
        self.tblView.separatorStyle = .singleLine
        self.tblView.estimatedRowHeight = UITableView.automaticDimension
        self.tblView.rowHeight = UITableView.automaticDimension

    }
    
    func initViewModel() {
        
        viewModel.getFacilityWithOptions()
        viewModel.reloadTableView = { [weak self] in
            
            DispatchQueue.main.async{
                self?.tblView.reloadData()
            }
        }
    }
}

// MARK: - UITableViewDelegate

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*
        let currentCell = self.tableView.cellForRow(at: indexPath) as? ProductCell
        
        if ((currentCell?.checkBoxBtn.isSelected) != nil && (currentCell?.checkBoxBtn.isSelected)!){
            self.showAlert(title: "Test", message: viewModel.getCellViewModel(at: indexPath).desc)
        }else{
            self.showAlert(title: "Alert", message: "Please select checkbox")
        }*/
    }
}

// MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.cellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var numberOfRowInSection = 0
        
        if viewModel.cellViewModels.count > 0{
            numberOfRowInSection = viewModel.cellViewModels[section].optionViewModel.count
        }
        return numberOfRowInSection
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 40))
        
        let label = UILabel()
        label.frame = CGRect.init(x: 15, y: 5, width: headerView.frame.width-30, height: headerView.frame.height-10)
        let indexPath = IndexPath(row: 0, section: section)
        let cellVM = viewModel.getCellViewModel(at: indexPath)
        label.text = cellVM.facility_name
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        headerView.addSubview(label)
        headerView.backgroundColor = .white
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OptionTVCell.identifier, for: indexPath) as? OptionTVCell else { fatalError("cell does not exists") }
        let cellVM = viewModel.getOptionViewModel(at: indexPath)
        cell.lbl.text = cellVM.options_name
        cell.btn.isSelected = cellVM.isRadioButtonSelected
        cell.btn.tag = indexPath.row
        cell.contentView.tag = indexPath.section
        cell.btn.addTarget(self, action: #selector(radioButtonSelected(btn:)), for: .touchUpInside)
        return cell
    }
    
    @objc func radioButtonSelected(btn:UIButton){
        
        let contentView = btn.superview
        print(contentView?.tag)
        print(btn.tag)
        
        let indexPath = IndexPath(row: btn.tag, section: contentView!.tag)
        let currentCell = self.tblView.cellForRow(at: indexPath) as? OptionTVCell
        if ((currentCell?.btn.isSelected) != nil && !(currentCell?.btn.isSelected)!){
            currentCell?.btn.isSelected = true
        }else{
            currentCell?.btn.isSelected = false
        }
        
        viewModel.updateDataArray(parentViewTag: indexPath.section, childViewTag: indexPath.row, updatedCellViewModel: viewModel.cellViewModels)
//        
//        let selectedObj = viewModel.cellViewModels[indexPath.section]
//        let selectedChildObj = selectedObj.optionViewModel[indexPath.row]
    }
    
    /*@objc func checkBoxButtonPressed(btn:UIButton){
        
        let indexPath = IndexPath(row: btn.tag, section: 0)
        let currentCell = self.tableView.cellForRow(at: indexPath) as? ProductCell
        if ((currentCell?.checkBoxBtn.isSelected) != nil && !(currentCell?.checkBoxBtn.isSelected)!){
            currentCell?.checkBoxBtn.isSelected = true
        }else{
            currentCell?.checkBoxBtn.isSelected = false
        }
        
        let updatedProductCellViewModel = viewModel.productCellViewModels.map({ (productCellViewModel) -> ProductCellViewModel in
            if productCellViewModel.id == viewModel.getCellViewModel(at: indexPath).id{
                
                var proCellViewModel = productCellViewModel
                
                if proCellViewModel.isCheckBoxSelected{
                    proCellViewModel.isCheckBoxSelected = false
                }else{
                    proCellViewModel.isCheckBoxSelected = true
                }
                return proCellViewModel
            }
            return productCellViewModel
        })
        viewModel.productCellViewModels = updatedProductCellViewModel
    }*/
}
