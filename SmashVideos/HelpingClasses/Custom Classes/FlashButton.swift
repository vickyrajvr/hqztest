//
//  FlashButton.swift
//  ParkSpace
//
//  Created by Zubair Ahmed on 01/04/2022.
//

import Foundation
import UIKit
final class FlashButton: UIButton {
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        settings()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        settings()
    }

    // MARK: - Properties
    override var isSelected: Bool {
        didSet {
            let color: UIColor = isSelected ? .gray : .lightGray
            //backgroundColor = color.withAlphaComponent(0.7)
        }
    }
}

// MARK: - Private
private extension FlashButton {
    func settings() {
        setTitleColor(.darkGray, for: .normal)
        setTitleColor(.white, for: .selected)
        setTitle("OFF", for: .normal)
        setTitle("ON", for: .selected)
        tintColor = .clear
        titleLabel?.font = .boldSystemFont(ofSize: 16)
        layer.cornerRadius = frame.size.width / 2
        isSelected = false
    }
}

