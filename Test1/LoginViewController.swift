//
//  LoginViewController.swift
//  Test1
//
//  Created by MII-MAC-03 on 4/3/2569 BE.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class LoginViewController: UIViewController {

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func loginPressed(_ sender: UIButton) {
        guard let email = emailTextField.text,
                  let password = passwordTextField.text else { return }
            
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                
                if let error = error {
                    self.showAlert(message: error.localizedDescription)
                    return
                }
                
                self.checkUserRole(uid: result!.user.uid)
            }
    }
    
    func checkUserRole(uid: String) {
        
        let db = Firestore.firestore()
        
        db.collection("users").document(uid).getDocument { document, error in
            
            if let document = document, document.exists {
                
                let role = document.data()?["role"] as? String
                
                if role == "customer" {
                    self.performSegue(withIdentifier: "goToCustomer", sender: self)
                } else if role == "staff" {
                    self.performSegue(withIdentifier: "goToStaff", sender: self)
                }
            }
        }
    }
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error",
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alert, animated: true)
    }

}
