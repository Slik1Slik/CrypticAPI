//
//  HomeTableViewCell.swift
//  Cryptic API
//
//  Created by Slik on 04.10.2022.
//

import UIKit

final class HomeTableViewCell : UITableViewCell {
    
    static let reuseId = "HomeTableViewCell"

    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        return label
    }()
    
    let detailsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        arrangeInStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String,
                   subtitle: String,
                   details: String) {

        titleLabel.text = title
        subtitleLabel.text = subtitle
        detailsLabel.text = details
    }
    
    private func titleAndSubtitleStackView() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.axis = .vertical
        stackView.spacing = LayoutGuideConstants.objectContentInset
        return stackView
    }

    private func arrangeInStackView() {
        
        let stackView = UIStackView(arrangedSubviews: [titleAndSubtitleStackView(),
                                                       UISpacer(axis: .horizontal),
                                                       detailsLabel])
        stackView.axis = .horizontal

        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.pin(to: self, axis: .all(LayoutGuideConstants.groupedContentInset))
    }
}
