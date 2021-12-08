//
//  PhotosCollectionViewController.swift
//  ServiceDesign
//
//  Created by Kamil on 01.12.2021.
//

import UIKit

class PhotosCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    fileprivate let cellId = "id1234"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PhotoManager.shared.getPhotoCount() 
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: view.frame.width * 0.8, height: 4/3*view.frame.width)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? PhotoCell
        else {
            fatalError()
        }
        
        cell.backgroundColor = .red
        let photoName = PhotoManager.shared.getPhoto(for: indexPath.item)
        let path = PhotoManager.shared.getDocumentsDirectory().appendingPathComponent(photoName)
        
        if let image = UIImage(contentsOfFile: path.path) {
            cell.imageView.image = image
        }
        
        return cell
    }
}


