//
//  ProfileHeaderView.swift
//  Novigation
//
//  Created by Александр Хмыров on 03.06.2022.
//

import UIKit
import SnapKit

final class ProfileHeaderView: UITableViewHeaderFooterView {

    private var delegate: ProfileViewControllerDelegate?

    private var currentUser: ProfileCoreData?

    private lazy var startAvatarPosition: CGPoint = {
        var startAvatarPosition = CGPoint()
        return startAvatarPosition
    }()


    private lazy var avatarImageView: UIImageView = {
        var avatarImageView = UIImageView()
        avatarImageView.backgroundColor = .systemGray4
        avatarImageView.layer.borderColor = UIColor.white.cgColor
        avatarImageView.layer.masksToBounds = true
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.layer.borderWidth = 1
        avatarImageView.isUserInteractionEnabled = true
        return avatarImageView
    }()



    private lazy var fullNameLabel: UILabel = {
        var titleLabel: UILabel = UILabel()
        titleLabel.textColor = UIColor.createColorForTheme(lightTheme: .black, darkTheme: .white)
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return titleLabel
    }()


    private lazy var textFieldStatus: UITextField = {

        var statusTextField = UITextField()
        statusTextField.textColor = .systemGray
        statusTextField.delegate = self
        return statusTextField

    }()


    private lazy var buttonDetailedInformations: UIButton = {

        let action = UIAction() { _ in
            self.delegate?.showDetailedInformationsViewController()
        }

        let buttonDetailedInformations = UIButton(frame: CGRect(), primaryAction: action)
        buttonDetailedInformations.translatesAutoresizingMaskIntoConstraints = false
        buttonDetailedInformations.setTitle("buttonDetailedInformations".allLocalizable, for: .normal)
        buttonDetailedInformations.setTitleColor(.systemGray, for: .normal)

        let image = UIImage(systemName: "exclamationmark.circle")?.withRenderingMode(.alwaysTemplate)

        buttonDetailedInformations.setImage(image, for: .normal)
        buttonDetailedInformations.tintColor = .systemGray
        return buttonDetailedInformations
    }()



    private lazy var buttonEditingProfile: CustomButton = {
        var editingProfileButton = CustomButton(title: NSLocalizedString("EditingProfileButton", tableName: "ProfileViewControllerLocalizable", comment: ""))
        {
            self.delegate?.showSettingViewController()
        }
        return editingProfileButton
    }()



    private lazy var buttonAddPost: UIButton = {

        var action = UIAction { _ in
            self.delegate?.addNewPost()
        }
        var buttonAddPost = UIButton(frame: CGRect(), primaryAction: action)
        buttonAddPost.setBackgroundImage(UIImage(systemName: "plus.circle"), for: .normal)
        buttonAddPost.translatesAutoresizingMaskIntoConstraints = false
        buttonAddPost.frame.size = CGSize(width: 50.0, height: 50.0)
        buttonAddPost.sizeToFit()
        return buttonAddPost
    }()



    private var viewForAnimation: UIView = {
        var viewForAnimation = UIView()
        viewForAnimation.translatesAutoresizingMaskIntoConstraints = false
        viewForAnimation.isHidden = true
        viewForAnimation.layer.opacity = 0.5
        return viewForAnimation
    }()

    private lazy var buttonOffAnimation: UIButton = {
        var buttonOffAnimation = UIButton()
        buttonOffAnimation.translatesAutoresizingMaskIntoConstraints = false
        buttonOffAnimation.isHidden = true
        buttonOffAnimation.setImage(UIImage(named: "k"), for: .normal)
        buttonOffAnimation.layer.cornerRadius = 20
        buttonOffAnimation.layer.opacity = 0.5
        buttonOffAnimation.layer.masksToBounds = true
        buttonOffAnimation.addTarget( self, action: #selector(buttonOffAnimationTarget), for: .touchUpInside)
        return buttonOffAnimation
    }()


    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.setupView()
        self.setupConstraints()
        self.setupGesture()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        avatarImageView.layer.cornerRadius = self.avatarImageView.frame.height / 2
            }



    func setupHeader(_ currentUser: ProfileCoreData, delegate: ProfileViewControllerDelegate) {
        self.currentUser = currentUser

        self.avatarImageView.image = UIImage(named: currentUser.avatar ?? "")
        self.textFieldStatus.text = currentUser.status
        self.fullNameLabel.text = (currentUser.name ?? "") + " " + (currentUser.surname ?? "")
        self.delegate = delegate
    }


    private func setupGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.addTarget(self, action: #selector(handleTapGestureRecognizer(_:)))
        self.avatarImageView.addGestureRecognizer(tapGestureRecognizer) }



    private func setupView() {



        [fullNameLabel, textFieldStatus, buttonAddPost, buttonDetailedInformations, buttonEditingProfile,viewForAnimation, buttonOffAnimation, avatarImageView].forEach({ addSubview($0) })
    }


    private func setupConstraints() {

        contentView.backgroundColor = UIColor.createColorForTheme(lightTheme: .white, darkTheme: .black)

        let profileViewController = ProfileViewController()

        avatarImageView.snp.makeConstraints { make in
            make.top.equalTo(snp.top).offset(16)
            make.leading.equalTo(snp.leading).offset(16)
            make.width.height.equalTo(100)
        }


        fullNameLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp_topMargin)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(16)
        }

        textFieldStatus.snp.makeConstraints { make in
            make.top.equalTo(fullNameLabel.snp_bottomMargin).offset(15)
            make.leading.equalTo(fullNameLabel.snp.leading).offset(5)
        }


        buttonDetailedInformations.snp.makeConstraints { make -> Void in
            make.bottom.equalTo(avatarImageView.snp.bottom)
            make.leading.equalTo(fullNameLabel.snp.leading)
            make.height.equalTo(20)
        }

        buttonEditingProfile.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(22)
            make.leading.equalTo(snp.leading).offset(16)
            make.trailing.equalTo(snp.trailing).offset(-16)
            make.height.equalTo(50)
        }

        viewForAnimation.snp.makeConstraints { make in
            make.width.equalTo(profileViewController.view.frame.width)
            make.height.equalTo(profileViewController.view.frame.height)
        }

        buttonOffAnimation.snp.makeConstraints { make in
            make.top.equalTo(viewForAnimation.snp.top).offset(14)
            make.trailing.equalTo(viewForAnimation.snp.trailing).offset(-14)
            make.height.width.equalTo(40)
        }

        buttonAddPost.snp.makeConstraints { make in
            make.top.equalTo(buttonEditingProfile.snp.bottom).offset(14)
            make.bottom.equalTo(snp.bottom).offset(-20)
            make.centerX.equalTo(snp.centerX)
            make.height.width.equalTo(35)
        }
    }

    private func basicAnimation() {
        print(avatarImageView.frame)
        startAvatarPosition = avatarImageView.center
        let screenMain = UIScreen.main.bounds
        let scale = UIScreen.main.bounds.width / avatarImageView.frame.width
        avatarImageView.layer.masksToBounds = false
        avatarImageView.layer.borderWidth = 0
        viewForAnimation.isHidden = false
        buttonOffAnimation.isHidden = false
        print(scale)

        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: .curveEaseInOut) {
            self.avatarImageView.layer.cornerRadius = 0
            self.avatarImageView.center = CGPoint(x: screenMain.width / 2.0, y: screenMain.height / 2.0)
            self.avatarImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
            self.viewForAnimation.backgroundColor = .black

        }
    }

   
    @objc private func handleTapGestureRecognizer(_ gesture: UITapGestureRecognizer) {
        basicAnimation()
    }



    @objc private func buttonOffAnimationTarget() {
        print(#function)

        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: .curveEaseInOut) {
            self.avatarImageView.center = self.startAvatarPosition
            self.avatarImageView.layer.cornerRadius =  50
            self.avatarImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.viewForAnimation.backgroundColor = nil

        }
        completion: { _ in
            self.avatarImageView.layer.borderWidth = 1
            self.avatarImageView.layer.cornerRadius = 50
            self.avatarImageView.layer.masksToBounds = true
            self.viewForAnimation.isHidden = true
            self.buttonOffAnimation.isHidden = true
        }
    }
}

extension ProfileHeaderView: UITextFieldDelegate {

    func textFieldDidEndEditing(_ textField: UITextField) {

        currentUser?.status = textFieldStatus.text
    }
}


