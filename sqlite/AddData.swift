//
//  AddData.swift
//  sqlite
//
//  Created by Mohamed Kamal on 13/02/2022.
//

import UIKit

class AddData: UIViewController {
    var p : MyProtocol?
    @IBOutlet weak var friendName: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var friendAge: UITextField!
    @IBOutlet weak var friendPhone: UITextField!
    var imagePath: String?
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }

    @IBAction func add(_ sender: Any) {
        p?.add()
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func uploadImage(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
}
extension AddData : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imgUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL{
            let imgName = imgUrl.lastPathComponent
            let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
            let localPath = documentDirectory?.appending(imgName)
            imagePath = localPath!
            print(imagePath!)
            
            let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            let data = image.pngData()! as NSData
            data.write(toFile: localPath!, atomically: true)
            
            let imageData = NSData(contentsOfFile: localPath!)!
            imageView.image = UIImage(data: imageData as Data)
            }
        picker.dismiss(animated: true, completion: nil)
        
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
