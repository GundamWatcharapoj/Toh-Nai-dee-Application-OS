import UIKit
import FirebaseFirestore
import FirebaseAuth

class StaffBookingDetailViewController: UIViewController {
    
    var selectedTableNumber: Int?
    var bookingDocumentID: String?
    @IBOutlet weak var nameLabel1: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var peopleLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadBookingData()
    }
    
    func loadBookingData() {
        
        guard let tableNumber = selectedTableNumber else { return }
        
        let db = Firestore.firestore()
        
        db.collection("bookings")
            .whereField("tableNumber", isEqualTo: tableNumber)
            .whereField("status", isEqualTo: "reserved")
            .getDocuments { snapshot, error in
                
                guard let document = snapshot?.documents.first else {
                    self.nameLabel.text = "ว่าง"
                    return
                }
                
                let data = document.data()
                
                self.bookingDocumentID = document.documentID
                
                self.nameLabel.text = "ชื่อ: \(data["name"] as? String ?? "")"
                self.peopleLabel.text = "จำนวนคน: \(data["people"] as? String ?? "")"
                self.noteLabel.text = "หมายเหตุ: \(data["note"] as? String ?? "")"
                
                if let timestamp = data["date"] as? Timestamp {
                    let date = timestamp.dateValue()
                    let formatter = DateFormatter()
                    formatter.dateStyle = .medium
                    formatter.timeStyle = .short
                    self.dateLabel.text = "วันเวลา: \(formatter.string(from: date))"
                }
            }
    }
    
    @IBAction func cancelBooking(_ sender: UIButton) {
        
        guard let docID = bookingDocumentID else { return }
        
        let db = Firestore.firestore()
        
        db.collection("bookings").document(docID).updateData([
            "status": "cancelled"
        ])
        
        dismiss(animated: true)
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
