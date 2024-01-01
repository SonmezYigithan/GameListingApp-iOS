//
//  ViewController.swift
//  GameListingApp
//
//  Created by Yiğithan Sönmez on 31.12.2023.
//

import UIKit

class TabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemYellow
        
        let homeVC = UINavigationController(rootViewController: HomeVC())
        let searchVC = UINavigationController(rootViewController: SearchVC())
        let profileVC = UINavigationController(rootViewController: ProfileVC())
        
        homeVC.tabBarItem.image = UIImage(systemName: "house")
        searchVC.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        profileVC.tabBarItem.image = UIImage(systemName: "person.crop.circle")
        
        homeVC.title = "Home"
        searchVC.title = "Search"
        profileVC.title = "Profile"
        
        tabBar.tintColor = .label
        
        setViewControllers([homeVC, searchVC, profileVC], animated: true)
    }


}

