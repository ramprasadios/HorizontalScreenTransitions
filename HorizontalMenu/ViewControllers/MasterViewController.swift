//
//  MasterViewController.swift
//  HorizontalMenu
//
//  Created by Ramprasad A on 13/01/18.
//  Copyright © 2018 Ramprasad A. All rights reserved.
//

import UIKit

class MasterViewController: UIViewController {
    
    private weak var guestViewController: UIViewController!
    private var containerViewObjects = [String: UIViewController]()
    
    fileprivate var currentViewController : UIViewController {
        get {
            return self.guestViewController
        }
    }

    private var segueIdentifier: String!
    
    //View Life Cycle:
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if self.guestViewController != nil {
            self.guestViewController.view.removeFromSuperview()
            self.guestViewController = nil
        }
        
        if (self.containerViewObjects[self.segueIdentifier] == nil) {
            self.guestViewController = segue.destination
            self.containerViewObjects[self.segueIdentifier] = self.guestViewController
        } else {
            for (key, value) in self.containerViewObjects {
                if key == self.segueIdentifier {
                    self.guestViewController = value
                }
            }
        }
        
        self.addChildViewController(guestViewController)
        guestViewController.view.frame = CGRect(x: 0,y: 0, width: self.view.frame.width,height: self.view.frame.height)
        self.view.addSubview(guestViewController.view)
        guestViewController.didMove(toParentViewController: self)
    }
}

// MARK:- Helper Methods:
extension MasterViewController {
    func segueIdentifierReceivedFromParent(identifier: String) {
        self.segueIdentifier = identifier
        performSegue(withIdentifier: identifier, sender: nil)
    }
}
