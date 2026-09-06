import UIKit
import FirebaseDatabase
import FirebaseFirestore

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let tableView = UITableView()
    let messageField = UITextField()
    let sendButton = UIButton()
    var currentUserRole = "staff"
    
    let db = Firestore.firestore()
    var messages:[ChatMessage] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Chat"
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(
                image: UIImage(systemName: "chevron.left"),
                style: .plain,
                target: self,
                action: #selector(goBack)
            )

        setupUI()

        loadMessages()
    }

    func setupUI(){
        let backButton = UIButton()
        backButton.frame = CGRect(x: 20, y: 60, width: 80, height: 40)

        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(.systemBlue, for: .normal)

        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)

        view.addSubview(backButton)

        tableView.frame = CGRect(x: 0,
                                 y: 100,
                                 width: view.frame.width,
                                 height: view.frame.height - 180)

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ChatMessageCell.self, forCellReuseIdentifier: "cell")

        view.addSubview(tableView)

        messageField.frame = CGRect(x: 20,
                                    y: view.frame.height - 70,
                                    width: view.frame.width - 120,
                                    height: 40)

        messageField.borderStyle = .roundedRect
        messageField.placeholder = "พิมพ์ข้อความ..."

        view.addSubview(messageField)

        sendButton.frame = CGRect(x: view.frame.width - 80,
                                  y: view.frame.height - 70,
                                  width: 60,
                                  height: 40)

        sendButton.setTitle("Send", for: .normal)
        sendButton.backgroundColor = .systemBlue
        sendButton.layer.cornerRadius = 10

        sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)

        view.addSubview(sendButton)
    }

    @objc func sendMessage(){

        guard let text = messageField.text, !text.isEmpty else { return }
        let senderID = currentUserRole

        let profileURL = senderID == "staff"
            ? "https://i.pravatar.cc/150?img=5"
            : "https://i.pravatar.cc/150?img=3"
        
        let data:[String:Any] = [

            "text": text,
            "senderID": "senderID",
            "senderName": "senderID",
            "profileURL": profileURL,
            "timestamp": Timestamp()
        ]

        db.collection("messages").addDocument(data: data)

        messageField.text = ""
    }
    
    @objc func goBack(){
        dismiss(animated: true)
    }
    

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {

        return messages.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ChatMessageCell

        let message = messages[indexPath.row]

        let isSender = message.senderID == currentUserRole

        cell.configure(
            message: message.text,
            isSender: isSender,
            profileURL: message.profileURL
        )

        return cell
    }
    func loadMessages(){

        db.collection("messages")
            .order(by: "timestamp")
            .addSnapshotListener { snapshot, error in

                guard let documents = snapshot?.documents else { return }

                self.messages.removeAll()

                for doc in documents {

                    let data = doc.data()

                    let text = data["text"] as? String ?? ""
                    let senderID = data["senderID"] as? String ?? ""
                    let senderName = data["senderName"] as? String ?? ""
                    let profileURL = data["profileURL"] as? String ?? ""
                    let message = ChatMessage(
                        id: doc.documentID,
                        text: text,
                        senderID: senderID,
                        senderName: senderName,
                        profileURL: profileURL,
                        timestamp: Date()
                    )

                    self.messages.append(message)
                }

                self.tableView.reloadData()
            }
    }
}
