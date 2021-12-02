//
//  PhotoCell.swift
//  ServiceDesign
//
//  Created by Kamil on 01.12.2021.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: frame.width).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: frame.width * 4 / 3).isActive = true
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

