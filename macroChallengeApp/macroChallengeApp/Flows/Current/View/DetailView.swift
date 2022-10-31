//
//  DetailView.swift
//  macroChallengeApp
//
//  Created by Carolina Ortega on 25/10/22.
//

import Foundation
import UIKit
import SnapKit

class DetailView: UIView {
    let designSystem: DesignSystem = DefaultDesignSystem.shared
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var activityIcon: UIImageView = {
        let img = UIImageView()
        img.image = designSystem.imagesActivities.accomodationSelected
        img.contentMode = .scaleAspectFit
        img.clipsToBounds = true
        return img
    }()
    
    lazy var activityTitle: UILabel = {
        let title = UILabel()
        title.text = "Nome da atividade"
        title.numberOfLines = 0
        title.font = designSystem.text.infoTitle.font
        title.textAlignment = .center
        title.textColor = .textPrimary
        return title
    }()
    
    lazy var activityCategory: UILabel = {
        let title = UILabel()
        title.text = "Categoria: Praia"
        title.numberOfLines = 0
        title.font = designSystem.text.caption.font
        title.textAlignment = .center
        title.textColor = .caption
        return title
    }()
    
    lazy var activityInfo: UILabel = {
        let title = UILabel()
        title.text = "Início: 08h00    •    Valor: Grátis"
        title.numberOfLines = 0
        title.font = designSystem.text.body.font
        title.textAlignment = .center
        title.textColor = .textPrimary
        return title
    }()
   
    lazy var localTitle: UILabel = {
        let title = UILabel()
        title.text = "LOCATION".localized()
        title.stylize(with: designSystem.text.caption)
        return title
    }()
    
    lazy var local: UILabel = {
        let title = UILabel()
        title.text = "R. Domingos de Morais, 2564 - Vila Mariana, São Paulo - SP, 04036-100"
        title.stylize(with: designSystem.text.body)
        return title
    }()
    
    lazy var detailTitle: UILabel = {
        let title = UILabel()
        title.text = "DETAILS".localized()
        title.stylize(with: designSystem.text.caption)
        return title
    }()
    
    lazy var details: UILabel = {
        let title = UILabel()
        title.text = "Detalhes"
        title.stylize(with: designSystem.text.body)
        return title
    }()
    
    lazy var linkTitle: UILabel = {
        let title = UILabel()
        title.text = "CONTACT".localized()
        title.stylize(with: designSystem.text.caption)
        return title
    }()
    
    lazy var linkButton: UIButton = {
        let btn = UIButton()
        btn.contentHorizontalAlignment = .left
        btn.setTitleColor(.accent, for: .normal)
        return btn
    }()

    func setup() {
        self.backgroundColor = .backgroundPrimary
        self.addSubview(activityIcon)
        self.addSubview(activityTitle)
        self.addSubview(activityCategory)
        self.addSubview(activityInfo)
        self.addSubview(localTitle)
        self.addSubview(local)
        self.addSubview(detailTitle)
        self.addSubview(details)
        self.addSubview(linkTitle)
        self.addSubview(linkButton)
        setupConstraints()
        
    }

    func setupConstraints() {
        activityIcon.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.width.equalTo(80)
            make.topMargin.equalToSuperview().inset(designSystem.spacing.xLargePositive)
        }
        activityTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(activityIcon.snp.bottom).inset(designSystem.spacing.xxLargeNegative)
            make.leading.trailing.equalToSuperview()
        }
        activityCategory.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(activityTitle.snp.bottom).inset(designSystem.spacing.mediumNegative)
            make.leading.trailing.equalToSuperview()
        }
        activityInfo.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(activityCategory.snp.bottom).inset(-32)
            make.leading.trailing.equalToSuperview()
        }
        localTitle.snp.makeConstraints { make in
            make.topMargin.equalTo(activityInfo.snp.bottom).inset(-32)
            make.leading.trailing.equalToSuperview()
        }
        local.snp.makeConstraints { make in
            make.topMargin.equalTo(localTitle.snp.bottom).inset(designSystem.spacing.mediumNegative)
            make.leading.trailing.equalToSuperview()
        }
        linkTitle.snp.makeConstraints { make in
            make.topMargin.equalTo(local.snp.bottom).inset(-42)
            make.leading.trailing.equalToSuperview()
        }
        linkButton.snp.makeConstraints { make in
            make.topMargin.equalTo(linkTitle.snp.bottom).inset(designSystem.spacing.mediumNegative)
            make.leading.trailing.equalToSuperview()
        }
        detailTitle.snp.makeConstraints { make in
            make.topMargin.equalTo(linkButton.snp.bottom).inset(-42)
            make.leading.trailing.equalToSuperview()
        }
        details.snp.makeConstraints { make in
            make.topMargin.equalTo(detailTitle.snp.bottom).inset(designSystem.spacing.mediumNegative)
            make.leading.trailing.equalToSuperview()
        }
    }
}
