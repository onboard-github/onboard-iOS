//
//  BottomSheetViewController.swift
//  onboard-iOS
//
//  Created by 혜리 on 2023/10/19.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

class BottomSheetViewController: KeyboardHandlingViewController, View {
    
    typealias Reactor = PlayerReactor
    
    // MARK: - Properties
    
    var disposeBag = DisposeBag()
    
    var didTapButton: (() -> Void)?
    
    // MARK: - Metric
    
    private enum Metric {
        static let iconSize: CGFloat = 24
        static let topMargin: CGFloat = 26
        static let leftRightMargin: CGFloat = 24
        static let labelTopSpacing: CGFloat = 5
        static let textFieldTopSpacing: CGFloat = 15
        static let textFieldHeight: CGFloat = 52
        static let buttonTopSpacing: CGFloat = 20
        static let buttonHeight: CGFloat = 52
    }
    
    // MARK: - UI
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray.withAlphaComponent(0.7)
        return view
    }()
    
    let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.Gray_15
        label.font = Font.Typography.title2
        label.numberOfLines = 0
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.Gray_9
        label.font = Font.Typography.body4_R
        label.numberOfLines = 0
        return label
    }()
    
    private let textFieldTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.Gray_13
        label.font = Font.Typography.body4_R
        return label
    }()
    
    private let textField: TextField = {
        let textField = TextField()
        let view = UIView(frame: CGRect(x: 0, y: 0, width: Metric.iconSize + 10, height: Metric.iconSize))
        let image = UIImageView(image: IconImage.emptyDice.image)
        image.frame = CGRect(x: 10, y: 0, width: Metric.iconSize, height: Metric.iconSize)
        view.addSubview(image)
        textField.leftView = view
        textField.leftViewMode = .always
        
        textField.textColor = Colors.Gray_15
        textField.font = Font.Typography.body2_M
        textField.becomeFirstResponder()
        return textField
    }()
    
    private let textFieldSubTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.Gray_8
        label.font = Font.Typography.body5_R
        return label
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.Gray_8
        label.font = Font.Typography.body5_R
        return label
    }()
    
    private let registerButton: BaseButton = {
        let button = BaseButton(status: .disabled, style: .normal)
        return button
    }()
    
    private lazy var textFieldStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [textFieldTitleLabel, textField, bottomStackView])
        view.spacing = 2
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .fill
        return view
    }()
    
    private lazy var bottomStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [textFieldSubTitleLabel, countLabel])
        view.spacing = 10
        view.axis = .horizontal
        view.distribution = .fill
        view.alignment = .fill
        return view
    }()
    
    // MARK: - Initialize
    
    init(reactor: PlayerReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
        
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Bind
    
    func bind(reactor: PlayerReactor) {
        self.bindAction(reactor: reactor)
        self.bindState(reactor: reactor)
    }
    
    func bindAction(reactor: PlayerReactor) {
        self.registerButton.addAction(UIAction(handler: { _ in
            self.didTapButton?()
        }), for: .touchUpInside)
    }
    
    func bindState(reactor: PlayerReactor) {
        reactor.state
            .compactMap { $0.nicknameResult?.reason }
            .map { reason -> TextFieldState in
                switch reason {
                case "DUPLICATED_NICKNAME":
                    return .overLap
                case "INVALID_NICKNAME":
                    return .invalid
                default:
                    return .normal
                }
            }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] state in
                DispatchQueue.main.async {
                    self?.updateTextFieldState(for: state)
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Configure
    
    private func configure() {
        self.makeConstraints()
        self.setupGestureRecognizer()
        self.setupTextField()
    }
    
    private func makeConstraints() {
        self.view.addSubview(self.backgroundView)
        self.view.addSubview(self.contentView)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.subTitleLabel)
        self.contentView.addSubview(self.textFieldStackView)
        self.view.addSubview(self.registerButton)
        
        self.backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.contentView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        self.titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(Metric.topMargin)
            $0.leading.trailing.equalToSuperview().inset(Metric.leftRightMargin)
        }
        
        self.subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(Metric.labelTopSpacing)
            $0.leading.trailing.equalToSuperview().inset(Metric.leftRightMargin)
        }
        
        self.textField.snp.makeConstraints {
            $0.height.equalTo(Metric.textFieldHeight)
        }
        
        self.textFieldStackView.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(Metric.textFieldTopSpacing)
            $0.leading.trailing.equalToSuperview().inset(Metric.leftRightMargin)
        }
        
        self.registerButton.snp.makeConstraints {
            $0.top.equalTo(textFieldStackView.snp.bottom).offset(Metric.buttonTopSpacing)
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(Metric.buttonHeight)
        }
    }
    
    private func setupGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(backgroundTapped)
        )
        self.backgroundView.addGestureRecognizer(tapGesture)
    }
    
    func setState(popupState: PopupState,
                  onClickLink: @escaping (() -> Void)) {
        
        self.titleLabel.text = popupState.titleLabel
        self.subTitleLabel.text = popupState.subTitleLabel
        self.textFieldTitleLabel.text = popupState.textFieldLabelState?.string ?? ""
        self.textFieldSubTitleLabel.text = popupState.textFieldSubTitleLabel
        self.countLabel.text = popupState.countLabel
        self.registerButton.setTitle(popupState.buttonLabel, for: .normal)
        
        self.textField.attributedPlaceholder = NSAttributedString(
            string: popupState.textFieldPlaceholder,
            attributes: [
                .font: Font.Typography.body3_R as Any,
                .foregroundColor: Colors.Gray_7
            ]
        )
    }
    
    @objc
    private func backgroundTapped() {
        self.dismiss(animated: false)
    }
    
    private func updateTextFieldState(for state: TextFieldState) {
        switch state {
        case .over:
            self.countLabel.textColor = Colors.Red
            self.registerButton.status = .disabled
            self.textFieldSubTitleLabel.text = nil
            
        case .overLap:
            self.textFieldSubTitleLabel.text = TextLabels.bottom_textField_already
            self.textFieldSubTitleLabel.textColor = Colors.Red
            self.registerButton.status = .disabled
            self.countLabel.textColor = Colors.Gray_8
            
        case .invalid:
            self.registerButton.status = .disabled
            
        case .normal:
            self.registerButton.status = .default
            self.textFieldSubTitleLabel.text = nil
            self.countLabel.textColor = Colors.Gray_8
            
            GameDataSingleton.shared.addGuestNickName(self.textField.text ?? "")
        }
    }
}

extension BottomSheetViewController {
    
    private func setupTextField() {
        self.textField.rx.text.orEmpty
            .distinctUntilChanged()
            .map(inputText(_:))
            .subscribe(onNext: { [weak self] result in
                self?.updateTextFieldState(for: result)
            })
            .disposed(by: disposeBag)
        
        self.textField.rx.controlEvent(.editingChanged)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.updateCountLabel(self.textField.text?.count ?? 0, 10)
            })
            .disposed(by: disposeBag)
        
        self.textField.rx.text.orEmpty
            .distinctUntilChanged()
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] text in
                guard let nickname = GameDataSingleton.shared.guestNickNameData else { return }
                let groupId = GameDataSingleton.shared.getGroupId() ?? 0
                self?.reactor?.action.onNext(.validateNickname(groupId: groupId, 
                                                               nickname: nickname))
            })
            .disposed(by: disposeBag)
    }
    
    private func inputText(_ text: String) -> TextFieldState {
        if text.count >= 10 {
            let index = text.index(text.startIndex, offsetBy: 10)
            self.textField.text = String(text[..<index])
            return .over
        }
        
        return .normal
    }
    
    private func updateCountLabel(_ currentCount: Int, _ totalCount: Int) {
        self.countLabel.text = String(format: "%02d/%d", currentCount, totalCount)
    }
}
