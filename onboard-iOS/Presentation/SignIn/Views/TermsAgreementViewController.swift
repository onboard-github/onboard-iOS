//
//  TermsAgreementView.swift
//  onboard-iOS
//
//  Created by Daye on 2023/10/10.
//

import UIKit

import SnapKit

final class TermsAgreementViewController: UIViewController {

    // MARK: - Metric

    private enum Metric {
        static let modalTop: CGFloat = 338
        static let screenHeight: CGFloat = UIDevice.current.heightOfSafeArea(includeBottomInset: true)
    }

    // MARK: - UI

    private let dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        return view
    }()

    private let modalView = TermsAgreementModalView()

    // MARK: - Properties

    private var modalHeight = Metric.screenHeight - Metric.modalTop

    // MARK: - Life Cycle

    override func viewDidLoad() {
        self.configure()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.showBottomSheet()
    }

    // MARK: - Configure

    private func configure() {
        self.view.backgroundColor = .clear
        self.dimmedView.alpha = 0.0

        self.modalView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.modalView.layer.cornerRadius = 16
        self.modalView.clipsToBounds = true

        self.makeConstraints()
        self.setupGestureRecognizer()
    }

    private func makeConstraints() {
        self.view.addSubview(self.dimmedView)
        self.view.addSubview(self.modalView)

        self.dimmedView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        self.modalView.snp.makeConstraints {
            $0.height.equalTo(self.modalHeight)
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(self.view.snp.bottom)
        }
    }

    private func showBottomSheet() {
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: .curveEaseIn,
            animations: {
                self.dimmedView.alpha = 0.6
                self.modalView.transform = CGAffineTransform(translationX: 0, y: -self.modalHeight)
                self.view.layoutIfNeeded()
            }, completion: nil
        )
    }

    private func hideBottomSheet() {
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: .curveEaseIn,
            animations: {
                self.dimmedView.alpha = 0.0
                self.modalView.transform = CGAffineTransform(translationX: 0, y: 0)
                self.view.layoutIfNeeded()
            }) { _ in
                if self.presentingViewController != nil {
                    self.dismiss(animated: false, completion: nil)
                }
            }
    }

    // MARK: - Gesture

    private func setupGestureRecognizer() {
        let dimmedTap = UITapGestureRecognizer(
            target: self,
            action: #selector(dimmedViewTapped(_:))
        )
        self.dimmedView.addGestureRecognizer(dimmedTap)
        self.dimmedView.isUserInteractionEnabled = true
    }

    @objc
    private func dimmedViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
        self.hideBottomSheet()
    }
}