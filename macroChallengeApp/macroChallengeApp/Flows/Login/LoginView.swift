//
//  LoginView.swift
//  macroChallengeApp
//
//  Created by Luca Hummel on 14/09/22.
//

import UIKit
import AuthenticationServices

class LoginView: UIView {
    let designSystem = DefaultDesignSystem.shared
    let signInWithAppleManager = SignInWithAppleManager.shared
    let isLogged = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
    
    lazy var imageLogin: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "login")
        img.contentMode = .scaleAspectFit
        img.clipsToBounds = true
        return img
    }()
    
    lazy var agreeText: UILabel = {
        let label = UILabel()
        label.text = "By clicking on the button above, you agree to our Privacy Policies".localized()
        label.textAlignment = .center
        label.stylize(with: designSystem.text.smallCaption)
        label.numberOfLines = 0
        label.textColor = .textPrimary
        return label
    }()
    
    lazy var signInText: UILabel = {
        let label = UILabel()
        label.text = "Sign in to be able to create, duplicate, like and travel together with a itinerary.".localized()
        label.stylize(with: designSystem.text.body)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .textPrimary
        return label
    }()
    
    lazy var buttonAppleSignIn: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton(authorizationButtonType: .default, authorizationButtonStyle: UITraitCollection.current.userInterfaceStyle == .dark ? .white : .black)
        button.cornerRadius = 108
        button.addTarget(self, action: #selector(actionButtonSignIn), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.backgroundColor = designSystem.palette.backgroundPrimary
        
        self.addSubview(imageLogin)
        self.addSubview(buttonAppleSignIn)
        self.addSubview(agreeText)
        self.addSubview(signInText)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        imageLogin.snp.makeConstraints { make in
            make.top.equalTo(self.snp.topMargin)
            make.height.equalTo(UIScreen.main.bounds.height / 2.3)
            make.centerX.equalTo(self.snp.centerX)

        }
        
        signInText.snp.makeConstraints { make in
            make.top.equalTo(imageLogin.snp.bottom).offset(designSystem.spacing.xxLargePositive)
            make.leading.equalToSuperview().offset(designSystem.spacing.xxLargePositive)
            make.trailing.equalToSuperview().inset(designSystem.spacing.xxLargePositive)
            
        }
        
        buttonAppleSignIn.snp.makeConstraints { make in
            make.top.equalTo(signInText.snp.bottom).offset(designSystem.spacing.xxLargePositive)
            make.leading.equalToSuperview().offset(50)
            make.trailing.equalToSuperview().offset(-50)
            make.height.equalTo(51)
        }
        
        agreeText.snp.makeConstraints { make in
            make.top.equalTo(buttonAppleSignIn.snp.bottom).offset(designSystem.spacing.mediumPositive)
            make.leading.equalToSuperview().offset(designSystem.spacing.xxLargePositive)
            make.trailing.equalToSuperview().inset(designSystem.spacing.xxLargePositive)
            
        }
    }
    
    @objc func actionButtonSignIn() {
        signInWithAppleManager.signIn()
    }
}
