//
//  PromotionsViewController.swift
//  DubiDabi
//
//  Created by Mac on 12/05/2023.
//

import UIKit

class PromotionsViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate  {
    
    //MARK: - VARS
    
    var selectedDate: String?
    var dateList = ["Last 7 days","Last 1 month","Last 2 month"]
    let pickerView = UIPickerView()
    
    var dataArr = ["Coins spent","Video Views","Link clicks","likes"]
    
    
    var isFirst = false
    
    //MARK: - OUTLET
    
    @IBOutlet weak var orderCollectionViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var promotionCollectionView: UICollectionView!
    
    @IBOutlet weak var whoopView: UIView!
    @IBOutlet weak var textfield: UITextField!
    
    
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var orderCollectionView: UICollectionView!
    
    
    //MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl()
        self.textfield.layer.borderColor = UIColor.systemGray5.cgColor
        self.textfield.layer.borderWidth = 1.5
        self.textfield.layer.cornerRadius = 5.0
        self.textfield.delegate = self
        textfield.text = "Last 7 days"
        if let dateRange = getDateRange(from: 7, unit: .day) {
            self.lblDate.text = dateRange
        }
        self.createPickerView()
        
        
        self.promotionCollectionView.delegate = self
        self.promotionCollectionView.dataSource = self
        self.promotionCollectionView.register(UINib(nibName: "PromotionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PromotionCollectionViewCell")
        
        self.orderCollectionView.delegate = self
        self.orderCollectionView.dataSource = self
        self.orderCollectionView.register(UINib(nibName: "OrderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "OrderCollectionViewCell")
        
        
        let height = self.orderCollectionView.collectionViewLayout.collectionViewContentSize.height
        self.orderCollectionViewHeight.constant = height
        print("height: ",height)
        
        self.orderCollectionView.reloadData()
        
    }
    
    
    
    //MARK: - FUNCTION
    
    
    func refreshControl(){
        let refreshControl = UIRefreshControl()
        scrollView.addSubview(refreshControl)
        refreshControl.tintColor = UIColor(named: "theme")
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    
    
    func createPickerView() {
        
        pickerView.delegate = self
        textfield.inputView = pickerView
       
    }
    func dismissPickerView() {
       let toolBar = UIToolbar()
       toolBar.sizeToFit()
       let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.action))
       toolBar.setItems([button], animated: true)
       toolBar.isUserInteractionEnabled = true
        textfield.inputAccessoryView = toolBar
    }
    @objc func action() {
          view.endEditing(true)
    }
    
    
    func getDateRange(from duration: Int, unit: Calendar.Component) -> String? {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd"
        
        // Calculate the start and end dates based on the specified duration and unit
        if let currentDate = calendar.date(byAdding: .day, value: 0, to: Date()),
           let startDate = calendar.date(byAdding: unit, value: -duration, to: currentDate) {
            
            let startDateString = dateFormatter.string(from: startDate)
            let endDateString = dateFormatter.string(from: currentDate)
            let formattedDateRange = "\(startDateString) - \(endDateString)"
            return formattedDateRange
        }
        
        return nil
    }
    
    //MARK: - PICKER VIEW ACTION
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dateList.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dateList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedDate = dateList[row] // selected item
        textfield.text = selectedDate
        
        if selectedDate == "Last 7 days"{
            if let dateRange = getDateRange(from: 7, unit: .day) {
                print(dateRange)
                self.lblDate.text = dateRange
                
            }
        }else if selectedDate == "Last 1 month"{
            if let dateRange = getDateRange(from: 1, unit: .month) {
                print(dateRange)
                self.lblDate.text = dateRange
            }
        }else{
            
            if let dateRange = getDateRange(from: 2, unit: .month) {
                print(dateRange)
                self.lblDate.text = dateRange
            }
            
        }
    }
    
    
    
  
    //MARK: - TEXTFIELD ACTION
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if isFirst == true {
            
        }else{
            
            if textField == textfield{
                self.pickerView.selectRow(0, inComponent: 0, animated: true)
                self.pickerView(pickerView, didSelectRow: 0, inComponent: 0)
            }
            isFirst = true
        }
       
    }
    //MARK: - BUTTON ACTION
    
    @objc private func refreshData(_ sender: UIRefreshControl) {
        // Perform data reloading or refreshing here
        print("test")
        //loadData()
        
        // End the refresh control's refreshing state
        sender.endRefreshing()
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
  
}

//MARK:- EXTENSION FOR COLLECTION VIEW

extension PromotionsViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == promotionCollectionView {
            return dataArr.count
        }else{
            return 3
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == promotionCollectionView {
            let cell = promotionCollectionView.dequeueReusableCell(withReuseIdentifier: "PromotionCollectionViewCell", for: indexPath)as! PromotionCollectionViewCell
            
            cell.lblMainHeading.text = dataArr[indexPath.row] as! String
            if indexPath.row == 0 {
                cell.stackView.isHidden = false
            }else{
                cell.stackView.isHidden = true
            }
            
            return cell
        }else{
            
            let cell = orderCollectionView.dequeueReusableCell(withReuseIdentifier: "OrderCollectionViewCell", for: indexPath)as! OrderCollectionViewCell
           
            
            return cell
        }
       
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == promotionCollectionView {
            return CGSize(width: promotionCollectionView.frame.size.width/2.0, height: promotionCollectionView.frame.size.height/2.0)
        }else{
            return CGSize(width: orderCollectionView.frame.width, height: 140)
        }
        
    }
    
    
}

