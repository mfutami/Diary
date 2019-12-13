//
//  StartViewController.swift
//  JBDatePicker
//
//  Created by J.J.A.P. van Breukelen on 25-10-16.
//  Copyright © 2016 Joost van Breukelen. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    var date: Date!
    lazy var dateFormatter: DateFormatter = {
    
        var formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .medium
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //set dateLabel text
        dateLabel.text = dateFormatter.string(from: Date())
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToFlowerTableVC(_ segue: UIStoryboardSegue) {
    
        //set dateLabel text
        guard let returnedDate = date else {return}
        dateLabel.text = dateFormatter.string(from: returnedDate)
    }
    


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destinationNavController = (segue.destination as? UINavigationController){
            if let datePickerVC = destinationNavController.viewControllers.first as? DatePickerViewController{
                datePickerVC.dateToSelect = date
            }
        }
    }

}
