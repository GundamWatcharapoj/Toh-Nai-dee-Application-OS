import UIKit
import FirebaseFirestore
import FirebaseAuth

class StaffFloorViewController: UIViewController {

    var listener: ListenerRegistration?
    @IBOutlet weak var nameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        listenForBookings()
        loadUserName()
    }

    // กดโต๊ะ
    @IBAction func tableTapped(_ sender: UIButton) {
        let tableNumber = sender.tag
        performSegue(withIdentifier: "goToStaffDetail", sender: tableNumber)
    }

    // ส่งเลขโต๊ะไปหน้า Detail
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToStaffDetail" {
            let vc = segue.destination as! StaffBookingDetailViewController
            vc.selectedTableNumber = sender as? Int
        }
    }

    // ฟังสถานะโต๊ะแบบ Real-time
    func listenForBookings() {

        let db = Firestore.firestore()

        listener = db.collection("bookings")
            .whereField("status", isEqualTo: "reserved")
            .addSnapshotListener { snapshot, error in

                guard let documents = snapshot?.documents else { return }

                // รีเซ็ตทุกโต๊ะเป็นสีเขียวก่อน
                for view in self.view.subviews {
                    if let button = view as? UIButton {
                        button.backgroundColor = .systemGreen
                    }
                }

                // ถ้ามีจอง → เปลี่ยนสีแดง
                for document in documents {
                    let tableNumber = document.data()["tableNumber"] as? Int ?? 0

                    if let button = self.view.viewWithTag(tableNumber) as? UIButton {
                        button.backgroundColor = .systemRed
                    }
                }
            }
    }
    
    @IBAction func logoutTapped(_ sender: UIButton) {
        
        do {
            try Auth.auth().signOut()
            
            // กลับไปหน้า Login
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
                
                sceneDelegate.window?.rootViewController = loginVC
                sceneDelegate.window?.makeKeyAndVisible()
            }
            
        } catch {
            print("Logout error: \(error.localizedDescription)")
        }
    }

    @IBAction func chatButton(_ sender: UIButton) {

        let vc = ChatViewController()
        vc.currentUserRole = "staff"
        navigationController?.pushViewController(vc, animated: true)


    }
    
    func loadUserName() {
        
        guard let user = Auth.auth().currentUser else { return }
        
        let db = Firestore.firestore()
        
        db.collection("users").document(user.uid).getDocument { document, error in
            
            if let data = document?.data() {
                let name = data["name"] as? String ?? "Unknown"
                
                DispatchQueue.main.async {
                    self.nameLabel.text = "Name: \(name)"
                }
            }
        }
    }
    @IBAction func showAbout(_ sender: Any) {
        let alert = UIAlertController(
                title: "About",
                message: "Restaurant Order App\nVersion 1.0\nDeveloped by APIWAT",
                preferredStyle: .alert
            )

            alert.addAction(UIAlertAction(
                title: "OK",
                style: .default,
                handler: nil
            ))
    }
}
