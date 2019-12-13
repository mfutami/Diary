//
//  ViewController.swift
//  JBDatePicker
//
//  Created by Joost van Breukelen on 09-10-16.
//  Copyright © 2016 Joost van Breukelen. All rights reserved.
//

import UIKit

class DatePickerViewController: UIViewController, JBDatePickerViewDelegate {
    
    @IBOutlet weak var datePickerView: JBDatePickerView!
    
    var dateToSelect: Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        datePickerView.delegate = self
        
        //get presented month
        self.navigationItem.title = datePickerView.presentedMonthView?.monthDescription
        
        //remove hairline under navigationbar
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "GreenPixel"), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage(named: "TransparentPixel")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .default
    }
    
    
    // MARK: - JBDatePickerViewDelegate
    
    func didSelectDay(_ dayView: JBDatePickerDayView) {

        self.performSegue(withIdentifier: "unwindFromDatepicker", sender: self)
    }
    
    func didPresentOtherMonth(_ monthView: JBDatePickerMonthView) {
        self.navigationItem.title = datePickerView.presentedMonthView.monthDescription
        
    }
    
//    func shouldAllowSelectionOfDay(_ date: Date?) -> Bool {
//        
//        guard let date = date else {return true}
//        let comparison = NSCalendar.current.compare(date, to: Date().stripped()!, toGranularity: .day)
//        
//        if comparison == .orderedAscending {
//            return false
//        }
//        return true
// 
//    }

//    var colorForUnavaibleDay: UIColor {
//        return .blue
//    }
    
    var dateToShow: Date {
        
        if let date = dateToSelect {
            return date
        }
        else{
            return Date()
        }
    }
    
    var weekDaysViewHeightRatio: CGFloat {
        return 0.1
    }
    
    
    @IBAction func loadNextMonth(_ sender: UIBarButtonItem) {
        datePickerView.loadNextView()
    }
    
    @IBAction func loadPreviousMonth(_ sender: UIBarButtonItem) {
        datePickerView.loadPreviousView()
    }

    
    @IBAction func dismissDatePicker(_ sender: UIBarButtonItem) {
         self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        if let startVC = segue.destination as? StartViewController {
            if let selectedDate = datePickerView.selectedDateView.date {
                startVC.date = selectedDate
            }
        }
        
    }
    
}

