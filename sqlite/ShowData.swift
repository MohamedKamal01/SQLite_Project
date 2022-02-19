//
//  ShowData.swift
//  sqlite
//
//  Created by Mohamed Kamal on 13/02/2022.
//

import UIKit

class ShowData: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var phone: UITextField!
    var imageViewFriend: UIImage?
    var nameFriend: String?
    var ageFriend: String?
    var phoneFriend: String?
    let db = DBManger.sharedObject
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = imageViewFriend!
        name.text = nameFriend!
        age.text = ageFriend!
        phone.text = phoneFriend!
        
    }

    @IBAction func update(_ sender: Any) {
        db.updateQuery(name: name.text!, phone: phone.text!, age: age.text!, oldPhone: phoneFriend!)
        self.navigationController?.popViewController(animated: true)
    }
}
