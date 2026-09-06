//
//  RegisterViewController.swift
//  Test1
//
//  Created by MII-MAC-03 on 4/3/2569 BE.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class RegisterViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var telTextField: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var roleSegmentedControl: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func registerPressed(_ sender: UIButton) {
        
        guard let name = nameTextField.text,
                 let email = emailTextField.text,
                 let password = passwordTextField.text,
                 let tel = telTextField.text else { return }

           let selectedRole = roleSegmentedControl.selectedSegmentIndex == 0 ? "customer" : "staff"

           Auth.auth().createUser(withEmail: email, password: password) { result, error in
               
               if let error = error {
                   self.showAlert(message: error.localizedDescription)
                   return
               }
               
               let db = Firestore.firestore()
               
               db.collection("users").document(result!.user.uid).setData([
                   "name": name,
                   "email": email,
                   "tel": tel,
                   "role": selectedRole
               ])
               
               self.showAlert(message: "Register Success!")
               self.dismiss(animated: true)
           }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Info",
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alert, animated: true)
        nameLabel.layer.cornerRadius = 10
        nameLabel.layer.masksToBounds = true
    }

}
