//
//  TakePhotoViewController.swift
//  ServiceDesign
//
//  Created by Kamil on 30.11.2021.
//


import UIKit


class TakePhotoViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var lastPressedButtonTag: Int!
    var allButtons: [UIButton]!
    
    var firstPhotoButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.tag = 0
        let image = UIImage(named: "empty")!
        btn.setBackgroundImage(image, for: .normal)
        btn.addTarget(self, action: #selector(takePhoto), for: .touchUpInside)
        btn.widthAnchor.constraint(equalTo: btn.heightAnchor, multiplier: 3/4).isActive = true
        return btn
    }()
    
    var secondPhotoButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.tag = 1
        let image = UIImage(named: "empty")!
        btn.setBackgroundImage(image, for: .normal)
        btn.addTarget(self, action: #selector(takePhoto), for: .touchUpInside)
        btn.widthAnchor.constraint(equalTo: btn.heightAnchor, multiplier: 3/4).isActive = true
        return btn
    }()
    
    var submitButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.addTarget(self, action: #selector(submit), for: .touchUpInside)
        
        btn.customIsEnabled = true
        btn.setTitle("Submit", for: .normal)
        btn.layer.cornerRadius = 20
        btn.layer.masksToBounds = true
        btn.heightAnchor.constraint(equalToConstant: 42).isActive = true
        btn.widthAnchor.constraint(equalTo: btn.heightAnchor, multiplier: 5).isActive = true
        return btn
    }()
    
    
    override func loadView() {
        view = UIView()
        allButtons = [firstPhotoButton, secondPhotoButton]
        
        let stackView = UIStackView(arrangedSubviews: [
            firstPhotoButton,
            secondPhotoButton
        ])
        
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 15
        stackView.distribution = .fillEqually
        
        let overallStackView = UIStackView(arrangedSubviews: [
            stackView,
            submitButton
        ])
        
        overallStackView.spacing = 15
        overallStackView.axis = .vertical
        overallStackView.alignment = .center
        
        view.addSubview(overallStackView)
        
        overallStackView.translatesAutoresizingMaskIntoConstraints = false
        overallStackView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        overallStackView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20).isActive = true
        overallStackView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        overallStackView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard
            let image = info[.originalImage] as? UIImage
        else {
            print("No image found")
            return
        }
        
        allButtons.forEach { button in
            if button.tag == lastPressedButtonTag {
                print(button.tag)
                button.setBackgroundImage(image, for: .normal)
            }
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.savePhoto(image, tag: self.lastPressedButtonTag)
        }
        
        dismiss(animated: true)
    }
    
    func savePhoto(_ image: UIImage, tag: Int) {
        guard
            let unfilteredImage = CIImage(image: image)?.transformed(by: CGAffineTransform(scaleX: 0.3, y: 0.3))
        else {
            print("Image is not valid. Failed to save image.")
            return
        }
        let imageName = UUID().uuidString
        PhotoManager.shared.addPhoto(name: imageName, tag: tag)
        DispatchQueue.main.async {
            if PhotoManager.shared.getPhotoCount() == PhotoManager.shared.getPhotoLimitation() {
                self.submitButton.customIsEnabled = true
            }
        }
        let imagePath = PhotoManager.shared.getDocumentsDirectory().appendingPathComponent(imageName)
        let filterManager = FilterManager()
        let filteredImage = filterManager.removeGreenScreen(foregroundCIImage: unfilteredImage)
        let filteredUIImage = UIImage(ciImage: filteredImage.oriented(.right))
        if let jpegData = filteredUIImage.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
    }
    
    @objc func takePhoto(_ sender: UIButton) {
        lastPressedButtonTag = sender.tag
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        //vc.allowsEditing = true
        //vc.delegate = self
        present(vc, animated: true)
    }
    
    @objc func submit(_ sender: UIButton) {
        let vc = SendPhotosViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


extension UIImage {
  public static func pixel(ofColor color: UIColor) -> UIImage {
    let pixel = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)

    UIGraphicsBeginImageContext(pixel.size)
    defer { UIGraphicsEndImageContext() }

    guard let context = UIGraphicsGetCurrentContext() else { return UIImage() }

    context.setFillColor(color.cgColor)
    context.fill(pixel)

    return UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
  }
}

extension UIButton {
    public var customIsEnabled: Bool {
        get {
            return isEnabled
        }
        set {
            isEnabled = newValue
            if newValue == true {
                setBackgroundImage(.pixel(ofColor: .systemBlue), for: .normal)
                setTitleColor(.white, for: .normal)
            } else {
                let color = UIColor(red: 0.7725, green: 0.7725, blue: 0.7725, alpha: 1)
                setBackgroundImage(.pixel(ofColor: color), for: .normal)
                setTitleColor(.darkGray, for: .normal)
            }
        }
    }
}
