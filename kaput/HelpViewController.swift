//
//  HelpViewController.swift
//  kaput
//
//  Created by Jeremy OUANOUNOU on 15/03/2017.
//  Copyright © 2017 OPE50. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController,UIWebViewDelegate {

    @IBOutlet var HelpWebView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

     HelpWebView.loadRequest(URLRequest(url: URL(string: "http://getkaput.com/faq-how-to")!))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
