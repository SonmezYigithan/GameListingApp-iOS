//
//  SeparatorView.swift
//  GameListingApp
//
//  Created by Yiğithan Sönmez on 31.01.2024.
//

import UIKit

final class SeparatorView: UIView {
    private let separatorView: UIView = {
        let separator = UIView()
        separator.backgroundColor = .secondarySystemFill
        return separator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareView() {
        addSubview(separatorView)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(equalTo: topAnchor),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}
