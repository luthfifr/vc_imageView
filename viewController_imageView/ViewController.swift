//
//  ViewController.swift
//  viewController_imageView
//
//  Created by Luthfi Fathur Rahman on 5/25/17.
//  Copyright © 2017 Luthfi Fathur Rahman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var gambar_internal: UIImageView!
    @IBOutlet weak var gambar_URL: UIImageView!
    @IBOutlet weak var text_URL: UITextField!
    @IBOutlet weak var btn_download: UIButton!
    @IBOutlet weak var btn_hapus: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        btn_download.layer.cornerRadius = 5
        btn_hapus.layer.cornerRadius = 5
        
        gambar_internal.image = UIImage(named: "furious8")
        gambar_internal.contentMode = UIView.ContentMode.scaleAspectFit
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btn_download(_ sender: UIButton) {
        if !(text_URL.text?.isEmpty)! {
            gambar_URL.downloadedFrom(link: text_URL.text!)
        } else {
            noImageAlert()
        }
        text_URL.endEditing(true)
    }
    
    @IBAction func btn_hapus(_ sender: UIButton) {
        let imageCG = gambar_URL.image?.cgImage
        let imageCI = gambar_URL.image?.ciImage
        
        if imageCG == nil && imageCI == nil {
            noImageAlert()
        } else {
            gambar_URL.image = nil
        }
    }
    
    func noImageAlert() {
        let alertStatus = UIAlertController (title: "Message", message: "No Image in UIImageView. Please insert a URL to download an image.", preferredStyle: UIAlertController.Style.alert)
        alertStatus.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler:  nil))
        self.present(alertStatus, animated: true, completion: nil)
    }
    

}

extension UIImageView {
    func downloadedFrom(link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
    
    func downloadedFrom(url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
            }
            }.resume()
    }
}

