//
//  ResultsViewController.swift
//  
//
//  Created by Sławek K on 24/08/2023.
//

import UIKit

class ResultsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Setup.placeHolderRatings

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var label: UILabel!    
    @IBOutlet weak var progressBar: UIProgressView!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
