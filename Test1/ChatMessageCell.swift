import UIKit

class ChatMessageCell: UITableViewCell {

    let bubble = UIView()
    let messageLabel = UILabel()
    let profileImage = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        profileImage.frame = CGRect(x: 10, y: 5, width: 40, height: 40)
        profileImage.layer.cornerRadius = 20
        profileImage.clipsToBounds = true
        contentView.addSubview(profileImage)

        bubble.layer.cornerRadius = 15
        contentView.addSubview(bubble)

        messageLabel.numberOfLines = 0
        messageLabel.textColor = .white
        bubble.addSubview(messageLabel)
    }

    required init?(coder: NSCoder) { fatalError() }

    func configure(message:String, isSender:Bool, profileURL:String){

        messageLabel.text = message
        let screenWidth = UIScreen.main.bounds.width
        let bubbleWidth: CGFloat = 220

        if let url = URL(string: profileURL) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        self.profileImage.image = UIImage(data: data)
                    }
                }
            }
        }

        if isSender {

            bubble.backgroundColor = .systemBlue
                    profileImage.isHidden = true

                    bubble.frame = CGRect(
                        x: screenWidth - bubbleWidth - 20,
                        y: 5,
                        width: bubbleWidth,
                        height: 40
                    )


        } else {

            bubble.backgroundColor = .darkGray
                    profileImage.isHidden = false

                    bubble.frame = CGRect(
                        x: 60,
                        y: 5,
                        width: bubbleWidth,
                        height: 40
                    )
        }

        messageLabel.frame = CGRect(x: 10, y: 5, width: 200, height: 30)
    }
}
