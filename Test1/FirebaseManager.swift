import FirebaseDatabase

class FirebaseManager {

    static let shared = FirebaseManager()

    let db = Database.database().reference()

}
