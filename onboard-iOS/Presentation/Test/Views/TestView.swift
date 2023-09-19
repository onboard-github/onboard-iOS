//
//  SingUpView.swift
//  onboard-iOS
//
//  Created by Daye on 2023/09/17.
//

import UIKit

import SnapKit

final class TestView: UIView {

    // MARK: - Metric

    private enum Metric {
        static let labelBottomMargin: CGFloat = 100
    }

    // MARK: - UI

    private let label = UILabel()
    let button = UIButton()

    // MARK: - Initialize

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Bind

    func bind(text: String) {
        self.label.text = "Hi!! \(text)"
    }

    // MARK: - Configure

    private func configure() {
        self.backgroundColor = .white
        
        self.button.setTitle("Login", for: .normal)
        self.button.setTitleColor(.black, for: .normal)
        
        self.makeConstraints()
    }

    private func makeConstraints() {
        self.addSubview(self.label)
        self.addSubview(self.button)

        self.label.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(self.snp.centerY).offset(-Metric.labelBottomMargin)
        }
        
        self.button.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
}
