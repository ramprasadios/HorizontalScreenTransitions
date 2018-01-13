
//  MenuViewController.swift
//  HorizontalMenu
//
//  Created by Ramprasad A on 13/01/18.
//  Copyright © 2018 Ramprasad A. All rights reserved.
//

import UIKit

struct MenuInfo {
    var menuTitle: String
    var isSelected: Bool
    
    init(withTitle title: String, isSelected selected: Bool) {
        self.menuTitle = title
        self.isSelected = selected
    }
}

class MenuViewController: UIViewController {
    
    
    @IBOutlet weak var menuCollectionView: UICollectionView!
    
    var menuList = ["NEWS", "TECHNOLOGY", "POLYTICS", "SCIENCE", "SPORTS"]
    var segueIdentifiers = ["First", "Second", "Third", "Fourth", "Fifth"]
    var menuDataSource: [MenuInfo] = []
    var masterVc: MasterViewController?
    var currentIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupDataSrource()
        self.initialSetup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "container" {
            self.masterVc = segue.destination as? MasterViewController
        }
    }
    
    @IBAction func handleRightSwipe(_ sender: UISwipeGestureRecognizer) {
        if currentIndex > 0 {
            self.currentIndex = self.currentIndex - 1
            let indexPath = IndexPath(row: currentIndex, section: 0)
            self.menuCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
            
            self.updateMenuObjects()
            self.masterVc?.segueIdentifierReceivedFromParent(identifier: self.segueIdentifiers[self.currentIndex])
        }
    }
    
    @IBAction func handleLeftSwipe(_ sender: Any) {
        if currentIndex < self.segueIdentifiers.count - 1 {
            self.currentIndex = self.currentIndex + 1
            let indexPath = IndexPath(row: currentIndex, section: 0)
            
            self.menuCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
            self.updateMenuObjects()
            self.masterVc?.segueIdentifierReceivedFromParent(identifier: self.segueIdentifiers[self.currentIndex])
        }
    }    
}

extension MenuViewController {
    
    func setupDataSrource() {
        for (index, menuItem) in self.menuList.enumerated() {
            if index == 0 {
                let menuObject = MenuInfo(withTitle: menuItem, isSelected: true)
                self.menuDataSource.append(menuObject)
            } else {
                let menuObject = MenuInfo(withTitle: menuItem, isSelected: false)
                self.menuDataSource.append(menuObject)
            }
        }
    }
    
    func initialSetup() {
        masterVc?.segueIdentifierReceivedFromParent(identifier: self.segueIdentifiers[0])
    }
    
    func updateMenuObjects() {
        let indexPath = IndexPath(row: currentIndex, section: 0)
        for (index, _) in self.menuDataSource.enumerated() {
            if index == indexPath.row {
                self.menuDataSource[index].isSelected = true
            } else {
                self.menuDataSource[index].isSelected = false
            }
        }
        self.menuCollectionView.reloadData()
    }
}

//
extension MenuViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.menuDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCell", for: indexPath) as? CustomMenuCell
        let menuObject = self.menuDataSource[indexPath.row]
        cell?.menuTitleLabel.text = menuObject.menuTitle
        if menuObject.isSelected {
            cell?.menuTitleView.backgroundColor = UIColor.red
            cell?.menuTitleLabel.textColor = UIColor.blue
        } else {
            cell?.menuTitleView.backgroundColor = UIColor.white
            cell?.menuTitleLabel.textColor = UIColor.black
            cell?.menuTitleLabel.backgroundColor = UIColor.white
        }
        
        return cell!
    }
}

extension MenuViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.currentIndex = indexPath.row
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        for (index, _) in self.menuDataSource.enumerated() {
            if index == indexPath.row {
                self.menuDataSource[index].isSelected = true
            } else {
                self.menuDataSource[index].isSelected = false
            }
        }
        collectionView.reloadData()
        masterVc?.segueIdentifierReceivedFromParent(identifier: self.segueIdentifiers[indexPath.row])
    }
}

extension MenuViewController: UICollectionViewDelegateFlowLayout {

}
