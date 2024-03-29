//
//  OwnerManageTableViewCell.swift
//  onboard-iOS
//
//  Created by 혜리 on 1/10/24.
//

import UIKit

final class OwnerManageTableViewCell: UITableViewCell {
    
    // MARK: - Metric
    
    private enum Metric {
        static let leftMargin: CGFloat = 24
        static let meImageSize: CGFloat = 14
        static let stackViewLeading: CGFloat = 60
        static let buttonRightMargin: CGFloat = 24
    }
    
    // MARK: - UI
    
    private let titleImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let meImage: UIImageView = {
        let imageView = UIImageView()
        let image = IconImage.me.image
        imageView.image = image
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.Gray_14
        label.font = Font.Typography.body3_M
        return label
    }()
    
    private let selectButton: UIButton = {
        let button = UIButton()
        button.setImage(IconImage.selected.image, for: .normal)
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [meImage, titleLabel])
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.alignment = .center
        return stackView
    }()
    
    // MARK: - Properties
    
    var didTapSelectButton: (() -> Void)?
    
    var isButtonSelected: Bool = false {
        didSet {
            let image = isButtonSelected ? IconImage.select.image : IconImage.deselect.image
            self.selectButton.setImage(image, for: .normal)
        }
    }
    
    // MARK: - Initialize
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    
    private func configure() {
        self.selectionStyle = .none
        
        self.addConfigure()
        self.makeConstraints()
    }
    
    private func addConfigure() {
        self.selectButton.addAction(UIAction(handler: { [weak self] _ in
            self?.didTapSelectButton?()
//            self?.isButtonSelected.toggle()
        }), for: .touchUpInside)
    }
    
    private func makeConstraints() {
        self.contentView.addSubview(self.titleImage)
        self.contentView.addSubview(self.stackView)
        self.contentView.addSubview(self.selectButton)
        
        self.titleImage.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(Metric.leftMargin)
            $0.centerY.equalToSuperview()
        }
        
        self.meImage.snp.makeConstraints {
            $0.width.height.equalTo(Metric.meImageSize)
        }
        
        self.stackView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(Metric.stackViewLeading)
            $0.centerY.equalToSuperview()
        }
        
        self.selectButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(Metric.buttonRightMargin)
            $0.centerY.equalToSuperview()
        }
    }
    
    func configure(
        image: UIImage? = IconImage.dice.image,
        title: String,
        titleColor: UIColor? = nil,
        showMeImage: Bool = true
    ) {
        self.titleImage.image = image
        self.titleLabel.text = title
        self.titleLabel.textColor = titleColor
        self.meImage.isHidden = !showMeImage
    }
    
    func updateButtonState(isSelected: Bool) {
        let image = isSelected ? IconImage.select.image : IconImage.deselect.image
        self.selectButton.setImage(image, for: .normal)
    }
}
