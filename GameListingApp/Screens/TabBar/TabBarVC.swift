//
//  ViewController.swift
//  GameListingApp
//
//  Created by Yiğithan Sönmez on 31.12.2023.
//

import UIKit

final class TabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        let homeVC = UINavigationController(rootViewController: HomeVC())
        let searchVC = UINavigationController(rootViewController: SearchVC())
        let profileVC = UINavigationController(rootViewController: MyListsVC())
        
        homeVC.tabBarItem.selectedImage = UIImage(systemName: "gamecontroller.fill")
        homeVC.tabBarItem.image = UIImage(systemName: "gamecontroller")
        searchVC.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        profileVC.tabBarItem.selectedImage = UIImage(systemName: "list.bullet.rectangle.fill")
        profileVC.tabBarItem.image = UIImage(systemName: "list.bullet.rectangle")
        
        homeVC.title = "Games"
        searchVC.title = "Search"
        profileVC.title = "My Lists"
        
        tabBar.tintColor = .label
        
        setViewControllers([homeVC, searchVC, profileVC], animated: true)
    }


}

