//
//  ResultsViewController.swift
//  testownik
//
//  Created by Sławek K on 03/12/2023.
//  Copyright © 2023 Slawomir Kurczewski. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {
        override func viewDidLoad() {
            super.viewDidLoad()
         }
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(true)
            
            self.title = Setup.placeHolderRatings
//            let x = testownik.testToDo?.currentPosition ?? 0
//            let y = testownik.testToDo?.count ?? 10000
//            let percent = Int((100*x)/y)
//            label.text = "\(percent) % OK"
//            if percent < 40 {  label.textColor = .magenta   }
//            else {  label.textColor = percent > 70 ? .green : .orange    }
//            progressBar.progress = Float(x)/Float(y)
//            infoLabel.text = "Total: \(y)"
        }
        
<<<<<<< HEAD
        self.title = Setup.placeHolderRatings
//        let x = testownik.testManager?.currentPosition ?? 0
//        let y = testownik.testManager?.count ?? 10000
        let percent = 64
        label.text = "\(percent) % OK"
        if percent < 40 {  label.textColor = .magenta   }
        else {  label.textColor = percent > 70 ? .green : .orange    }
        //progressBar.progress = Float(x)/Float(y)
        //infoLabel.text = "Total: \(y)"
    }
    
    @IBOutlet weak var label: UILabel!    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var infoLabel: UILabel!
    /*
    // MARK: - Navigation
=======
        @IBOutlet weak var label: UILabel!
        @IBOutlet weak var progressBar: UIProgressView!
        @IBOutlet weak var infoLabel: UILabel!
        /*
        // MARK: - Navigation
>>>>>>> b810f7a101de53b95996cac0fe8e28927d8d31ed

        // In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            // Get the new view controller using segue.destination.
            // Pass the selected object to the new view controller.
        }
        */
    }

