//
//  SendPhotosViewController.swift
//  ServiceDesign
//
//  Created by Kamil on 03.12.2021.
//

import UIKit

class SendPhotosViewController: UIViewController {
    let scrollView = UIScrollView()
    
    private func getUIImageView(tag: Int) -> UIImageView {
        let photoName = PhotoManager.shared.getPhoto(for: tag)
        let path = PhotoManager.shared.getDocumentsDirectory().appendingPathComponent(photoName)
        if let image = UIImage(contentsOfFile: path.path) {
            let result = UIImageView(image: image)
            result.heightAnchor.constraint(equalTo: result.widthAnchor, multiplier: 4/3).isActive = true
            return result
        }
        return UIImageView(image: UIImage(named: "empty"))
    }
    
    private func getAllImages() -> [UIImageView] {
        let imageCount = PhotoManager.shared.getPhotoCount()
        var allImages: [UIImageView] = [UIImageView]()
        for tag in 0..<imageCount {
            allImages.append(getUIImageView(tag: tag))
        }
        return allImages
    }
    
    var nameField: UITextField = {
        let tf = UITextField()
        tf.textAlignment = .center
        tf.placeholder = "Enter text here"
        //tf.backgroundColor = .red
        tf.font = UIFont.systemFont(ofSize: 24)
        tf.borderStyle = UITextField.BorderStyle.roundedRect
        tf.autocorrectionType = UITextAutocorrectionType.no
        tf.keyboardType = UIKeyboardType.default
        tf.returnKeyType = UIReturnKeyType.done
        tf.clearButtonMode = UITextField.ViewMode.whileEditing
        tf.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        tf.heightAnchor.constraint(equalToConstant: 60).isActive = true
        //tf.delegate = tf.self.delegate
        return tf
    }()
    
    var serviceNameFiled: UITextField = {
        let tf = UITextField()
        tf.textAlignment = .center
        tf.placeholder = "Enter text here"
        //tf.backgroundColor = .red
        tf.font = UIFont.systemFont(ofSize: 24)
        tf.borderStyle = UITextField.BorderStyle.roundedRect
        tf.autocorrectionType = UITextAutocorrectionType.no
        tf.keyboardType = UIKeyboardType.default
        tf.returnKeyType = UIReturnKeyType.done
        tf.clearButtonMode = UITextField.ViewMode.whileEditing
        tf.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        tf.heightAnchor.constraint(equalToConstant: 60).isActive = true
        //tf.delegate = tf.self.delegate
        return tf
    }()
    
    var sendButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.addTarget(self, action: #selector(sendData), for: .touchUpInside)
        
        btn.customIsEnabled = true
        btn.setTitle("Send data", for: .normal)
        btn.layer.cornerRadius = 20
        btn.layer.masksToBounds = true
        btn.heightAnchor.constraint(equalToConstant: 42).isActive = true
        btn.widthAnchor.constraint(equalTo: btn.heightAnchor, multiplier: 5).isActive = true
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        view.addSubview(sendButton)
        let subViews: [UIView] = getAllImages()
        let stackView = UIStackView(arrangedSubviews: subViews)
        scrollView.addSubview(stackView)
        scrollView.addSubview(nameField)
        scrollView.addSubview(serviceNameFiled)
        stackView.axis = .vertical
        stackView.spacing = 10;
        
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        nameField.translatesAutoresizingMaskIntoConstraints = false
        serviceNameFiled.translatesAutoresizingMaskIntoConstraints = false
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true;
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true;
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true;
        scrollView.bottomAnchor.constraint(equalTo: sendButton.topAnchor, constant: -20).isActive = true;

        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20).isActive = true;
        stackView.topAnchor.constraint(equalTo: serviceNameFiled.bottomAnchor, constant: 40).isActive = true;
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 20).isActive = true;
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true;
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40).isActive = true;
        
        nameField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20).isActive = true;
        nameField.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 40).isActive = true;
        nameField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20).isActive = true;
        nameField.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40).isActive = true;
        
        serviceNameFiled.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20).isActive = true;
        serviceNameFiled.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 40).isActive = true;
        serviceNameFiled.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20).isActive = true;
        serviceNameFiled.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40).isActive = true;
        
        sendButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true;
        sendButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @objc func sendData() {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let boundary = UUID().uuidString
        var urlRequest = URLRequest(url: URL(string: "http://ec2-18-224-37-124.us-east-2.compute.amazonaws.com:5000/generate_qr")!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let pm = PhotoManager.shared
        let firstPhotoName = pm.getPhoto(for: 0)
        let secondPhotoName = pm.getPhoto(for: 1)
        guard
            let data = self.generateDataTemplate(firstImageName: firstPhotoName, secondImageName:secondPhotoName, boundary: boundary)
        else {
            print("Failed to send data.")
            return
        }
            
        session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
            
            if(error != nil){
                print("\(error!.localizedDescription)")
            }
            
            guard let responseData = responseData else {
                print("no response data")
                return
            }
            
            if let responseString = String(data: responseData, encoding: .utf8) {
                print("uploaded to: \(responseString)")
            }
            
            let url = URL(string: "http://ec2-18-224-37-124.us-east-2.compute.amazonaws.com:5000/image.png")!
            let image = self.downloadImage(from: url)
            let vc = UIViewController()
            vc.view = UIImageView(image: image)
            self.present(vc, animated: true)
            
        }).resume()
        
    }
    
    func generateDataTemplate(firstImageName: String, secondImageName: String, boundary: String) -> Data? {
        let firstImagePath = PhotoManager.shared.getDocumentsDirectory().appendingPathComponent(firstImageName)
        let secondImagePath = PhotoManager.shared.getDocumentsDirectory().appendingPathComponent(secondImageName)
        guard
            let firstImage = UIImage(contentsOfFile: firstImagePath.path),
            let secondImage = UIImage(contentsOfFile: secondImagePath.path)
        else {
            print("Unable to find image")
            return nil
        }
        
        var data = Data()
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"fileToUpload\"; filename=\"\(firstImageName)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        data.append("\(firstImageName)\n".data(using: .utf8)!)
        data.append(firstImage.pngData()!)
        data.append("Content-Disposition: form-data; name=\"fileToUpload\"; filename=\"\(secondImageName)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        data.append("\(secondImageName)\n".data(using: .utf8)!)
        data.append(secondImage.pngData()!)
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        return data
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) -> UIImage {
        print("Download Started")
        var image: UIImage!
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            image = UIImage(data: data)
            // always update the UI from the main thread
        }
        return image
    }
    
    
}
