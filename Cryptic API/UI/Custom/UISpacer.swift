//
//  UISpacer.swift
//  Cryptic API
//
//  Created by Slik on 04.10.2022.
//

import UIKit

class UISpacer: UIView {
    
    init(axis: UIAxis) {
        super.init(frame: .zero)
        
        setUpFor(axis)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpFor(_ axis: UIAxis) {
        var constraint: NSLayoutConstraint = .init()
        switch axis {
        case .horizontal:
            constraint = self.widthAnchor.constraint(equalToConstant: 1000)
        case .vertical:
            constraint = self.heightAnchor.constraint(equalToConstant: 1000)
        default: break
        }
        constraint.priority = .defaultLow
        constraint.isActive = true
    }
}
