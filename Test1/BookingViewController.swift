import UIKit
import FirebaseAuth
import FirebaseFirestore

class BookingViewController: UIViewController {
    
    var selectedTableNumber: Int?
    
    @IBOutlet weak var nameLabel1: UILabel!
    @IBOutlet weak var peopleTextField: UITextField!
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func confirmBooking(_ sender: UIButton) {
        
        guard let user = Auth.auth().currentUser else { return }
        guard let tableNumber = selectedTableNumber else { return }
        guard let people = peopleTextField.text, !people.isEmpty else { return }
        
        let note = noteTextField.text ?? ""
        let selectedDate = datePicker.date
        
        let db = Firestore.firestore()
        
        db.collection("users").document(user.uid).getDocument { doc, error in
            
            let name = doc?.data()?["name"] as? String ?? "Unknown"
            
            db.collection("bookings").addDocument(data: [
                "tableNumber": tableNumber,
                "userId": user.uid,
                "name": name,
                "people": people,
                "note": note,
                "date": Timestamp(date: selectedDate),
                "status": "reserved"
            ])
            
            print("Booking saved")
            
            self.dismiss(animated: true)
        }
    }
    func loadUserName() {
        
        guard let user = Auth.auth().currentUser else { return }
        
        let db = Firestore.firestore()
        
        db.collection("users").document(user.uid).getDocument { document, error in
            
            if let data = document?.data() {
                let name = data["name"] as? String ?? "Unknown"
                
                DispatchQueue.main.async {
                    self.nameLabel1.text = "Name: \(name)"
                }
            }
        }
    }
}
