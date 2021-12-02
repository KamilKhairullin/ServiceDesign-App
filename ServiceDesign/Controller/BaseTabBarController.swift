//
//  BaseTabBarController.swift
//
//  Created by Kamil on 19.11.2021.
//

import UIKit

class BaseTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [
            createViewController(viewController: TakePhotoViewController(), title: "Take photo", imageName: "search"),
            createViewController(viewController: PhotosCollectionViewController(), title: "Edit photo", imageName: "today_icon"),
            createViewController(viewController: ResultSenderViewController(), title: "Send photos", imageName: "today_icon")
        ]
    }
    
    fileprivate func createViewController(viewController: UIViewController, title: String, imageName: String) -> UIViewController {
        viewController.navigationItem.title = title
        viewController.view.backgroundColor = .white
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = UIImage(named: imageName)
        navController.tabBarItem.title = title
        navController.navigationBar.prefersLargeTitles = true
        
        return navController
    }
}
