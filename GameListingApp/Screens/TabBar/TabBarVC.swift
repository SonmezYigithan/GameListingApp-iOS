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
        let profileVC = UINavigationController(rootViewController: ProfileVC())
        
        homeVC.tabBarItem.selectedImage = UIImage(systemName: "gamecontroller.fill")
        homeVC.tabBarItem.image = UIImage(systemName: "gamecontroller")
        searchVC.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        profileVC.tabBarItem.selectedImage = UIImage(systemName: "heart.fill")
        profileVC.tabBarItem.image = UIImage(systemName: "heart")
        
        homeVC.title = "Games"
        searchVC.title = "Search"
        profileVC.title = "Favorites"
        
        tabBar.tintColor = .label
        
        setViewControllers([homeVC, searchVC, profileVC], animated: true)
    }


}

