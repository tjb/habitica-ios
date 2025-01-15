//
//  ToastManager.Swift
//  Habitica
//
//  Created by Collin Ruffenach on 11/6/14.
//  Copyright (c) 2014 Notion. All rights reserved.
//

import UIKit
import SwiftUIX
import SwiftUI
import ConfettiSwiftUI

class ToastView: UIView {
        
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var priceContainer: UIView!
    @IBOutlet weak var priceIconLabel: IconLabel!
    @IBOutlet weak var statsDiffStackView: UIStackView!
    
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var bottomSpacing: NSLayoutConstraint!
    @IBOutlet weak var topSpacing: NSLayoutConstraint!
    @IBOutlet weak var leadingSpacing: NSLayoutConstraint!
    @IBOutlet weak var trailingSpacing: NSLayoutConstraint!
    
    @IBOutlet weak var leftImageWidth: NSLayoutConstraint!
    @IBOutlet weak var leftImageHeight: NSLayoutConstraint!
    @IBOutlet weak var priceContainerWidth: NSLayoutConstraint!
    @IBOutlet weak var priceTrailingPadding: NSLayoutConstraint!
    @IBOutlet weak var priceLeadingPadding: NSLayoutConstraint!
    @IBOutlet weak var priceIconLabelWidth: NSLayoutConstraint!
    
    var options: ToastOptions = ToastOptions()
    
    public convenience init(title: String, subtitle: String, background: ToastColor, duration: Double? = nil, delay: Double? = nil) {
        self.init(frame: CGRect.zero)
        options.title = title
        options.subtitle = subtitle
        options.backgroundColor = background
        if let duration = duration {
            options.displayDuration = duration
        }
        if let delay = delay {
            options.delayDuration = delay
        }
        loadOptions()
        accessibilityLabel = "\(title), \(subtitle)"
    }
    
    public convenience init(title: String, background: ToastColor, duration: Double? = nil, delay: Double? = nil) {
        self.init(frame: CGRect.zero)
        options.title = title
        options.backgroundColor = background
        if let duration = duration {
            options.displayDuration = duration
        }
        if let delay = delay {
            options.delayDuration = delay
        }
        loadOptions()
        accessibilityLabel = title
    }
    
    public convenience init(title: String, subtitle: String, icon: UIImage, background: ToastColor, duration: Double? = nil, delay: Double? = nil) {
        self.init(frame: CGRect.zero)
        options.title = title
        options.subtitle = subtitle
        options.leftImage = icon
        options.backgroundColor = background
        if let duration = duration {
            options.displayDuration = duration
        }
        if let delay = delay {
            options.delayDuration = delay
        }
        loadOptions()
        accessibilityLabel = "\(title), \(subtitle)"
    }
    
    public convenience init(title: String, icon: UIImage, background: ToastColor, duration: Double? = nil, delay: Double? = nil) {
        self.init(frame: CGRect.zero)
        options.title = title
        options.backgroundColor = background
        options.leftImage = icon
        if let duration = duration {
            options.displayDuration = duration
        }
        if let delay = delay {
            options.delayDuration = delay
        }
        loadOptions()
        accessibilityLabel = title
    }
    
    public convenience init(title: String, rightIcon: UIImage, rightText: String, rightTextColor: UIColor, background: ToastColor, duration: Double? = nil, delay: Double? = nil) {
        self.init(frame: CGRect.zero)
        options.title = title
        options.backgroundColor = background
        options.rightIcon = rightIcon
        options.rightText = rightText
        options.rightTextColor = rightTextColor
        if let duration = duration {
            options.displayDuration = duration
        }
        if let delay = delay {
            options.delayDuration = delay
        }
        loadOptions()
        accessibilityLabel = title
    }
    
    public convenience init(healthDiff: Float, magicDiff: Float, expDiff: Float, goldDiff: Float, questDamage: Float, background: ToastColor, duration: Double? = nil, delay: Double? = nil) {
        self.init(frame: CGRect.zero)
        accessibilityLabel = "You received "
        addStatsView(HabiticaIcons.imageOfHeartDarkBg, diff: healthDiff, label: "Health")
        addStatsView(HabiticaIcons.imageOfExperience, diff: expDiff, label: "Experience")
        addStatsView(HabiticaIcons.imageOfMagic, diff: magicDiff, label: "Mana")
        addStatsView(HabiticaIcons.imageOfGold, diff: goldDiff, label: "Gold")
        addStatsView(HabiticaIcons.imageOfDamage, diff: questDamage, label: "Damage")
        options.backgroundColor = background
        loadOptions()
    }
    
    public convenience init(goldDiff: Float, background: ToastColor, duration: Double? = nil, delay: Double? = nil) {
        self.init(frame: CGRect.zero)
        accessibilityLabel = "You received "
        addStatsView(HabiticaIcons.imageOfGold, diff: goldDiff, label: L10n.gold)
        options.backgroundColor = background
        loadOptions()
    }
    
    private func addStatsView(_ icon: UIImage, diff: Float, label: String) {
        if diff != 0 {
            let iconLabel = IconLabel()
            iconLabel.icon = icon
            iconLabel.text = diff > 0 ? String(format: "+%.2f", diff) : String(format: "%.2f", diff)
            iconLabel.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
            statsDiffStackView.addArrangedSubview(iconLabel)
            accessibilityLabel = (accessibilityLabel ?? "") + "\(Int(diff)) \(label), "
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureViews()
    }
    
    private func configureViews() {
        self.backgroundColor = .clear
        if let view = viewFromNibForClass() {
            translatesAutoresizingMaskIntoConstraints = false
            
            view.frame = bounds
            addSubview(view)
            
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view": view]))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view": view]))
            
            backgroundView.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
            backgroundView.layer.borderWidth = 1
            
            isUserInteractionEnabled = false
            backgroundView.isUserInteractionEnabled = true
            
            isAccessibilityElement = false
        }
    }

    private struct ConfettiView: View {
        @State private var counter = 0
        
        var body: some View {
            EmptyView()
                .confettiCannon(trigger: $counter,
                            num: 5,
                            confettis: [.image(Asset.subscriberStar.name)],
                            colors: [Color(UIColor.yellow100)],
                                confettiSize: 22,
                            rainHeight: 500, fadesOut: false,
                            openingAngle: .degrees(30),
                            closingAngle: .degrees(150),
                                radius: 100,
                            repetitions: 5,
                            repetitionInterval: 0.2)
                .onAppear {
                    counter += 1
                }
        }
    }
    
    func loadOptions() {
        if options.backgroundColor == .subscriberPerk {
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [UIColor("#72CFFFFF").cgColor, UIColor("#77F4C7FF").cgColor]
            gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint   = CGPoint(x: 1, y: 0.5)
            backgroundView.layer.insertSublayer(gradientLayer, at: 0)
            backgroundView.backgroundColor = .clear
            backgroundView.layer.borderWidth = 3
            titleLabel.textColor = .green1
            subtitleLabel.textColor = .green1
            
            self.insertSubview(UIHostingView(rootView: ZStack(alignment: .bottom) {
                ConfettiView()
            }
                .padding(.bottom, 70)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)), at: 0)
        } else {
            backgroundView.backgroundColor = options.backgroundColor.getUIColor()
            backgroundView.layer.borderColor = options.backgroundColor.getUIColor().darker(by: 10).cgColor
            
            backgroundView.layer.shadowColor = options.backgroundColor.getUIColor().cgColor
            backgroundView.layer.shadowRadius = 15
            backgroundView.layer.shadowOpacity = 0.25
            backgroundView.layer.shadowOffset = .zero
            backgroundView.layer.masksToBounds = false
            backgroundView.clipsToBounds = false
        }
        
        topSpacing.constant = 6
        bottomSpacing.constant = 6
        leadingSpacing.constant = 8
        trailingSpacing.constant = 8
        
        configureTitle(options.title)
        configureSubtitle(options.subtitle)
        configureLeftImage(options.leftImage)
        configureRightView(icon: options.rightIcon, text: options.rightText, textColor: options.rightTextColor)
        
        priceContainerWidth.constant = 0
        
        setNeedsUpdateConstraints()
        updateConstraints()
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if options.backgroundColor == .subscriberPerk {
            let gradient = UIImage.gradientImage(bounds: backgroundView.bounds, colors: [UIColor("#77F4C7"), UIColor("#72CFFF")])
            backgroundView.layer.borderColor = UIColor(patternImage: gradient).cgColor
            backgroundView.layer.sublayers?.forEach({ layer in
                layer.frame = backgroundView.layer.bounds
            })
            if options.backgroundColor == .subscriberPerk {
                self.subviews[0].frame = UIScreen.main.bounds
            }
        }
    }
    
    private func configureTitle(_ title: String?) {
        if let title = title {
            titleLabel.isHidden = false
            titleLabel.text = title
            titleLabel.sizeToFit()
            titleLabel.numberOfLines = -1
            if options.backgroundColor == .subscriberPerk {
                titleLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
            } else {
                titleLabel.font = UIFont.systemFont(ofSize: 13)
            }
            titleLabel.textAlignment = .center
        } else {
            titleLabel.isHidden = true
            titleLabel.text = nil
        }
    }
    
    private func configureSubtitle(_ subtitle: String?) {
        if let subtitle = subtitle {
            subtitleLabel.isHidden = false
            subtitleLabel.text = subtitle
            subtitleLabel.sizeToFit()
            subtitleLabel.numberOfLines = -1
            titleLabel.font = UIFont.systemFont(ofSize: 16)
            titleLabel.textAlignment = .center
        } else {
            subtitleLabel.isHidden = true
            subtitleLabel.text = nil
        }
    }
    
    private func configureLeftImage(_ leftImage: UIImage?) {
        if let leftImage = leftImage {
            leftImageView.isHidden = false
            leftImageView.image = leftImage
            leadingSpacing.constant = 4
            leftImageWidth.constant = 46
            leftImageHeight.priority = UILayoutPriority(rawValue: 999)
        } else {
            leftImageView.isHidden = true
            leftImageWidth.constant = 0
            leftImageHeight.priority = UILayoutPriority(rawValue: 500)
        }
    }
    
    private func configureRightView(icon: UIImage?, text: String?, textColor: UIColor?) {
        if let icon = icon, let text = text, let textColor = textColor {
            priceContainer.isHidden = false
            priceIconLabel.icon = icon
            priceIconLabel.text = text
            priceIconLabel.textColor = textColor
            trailingSpacing.constant = 0
            backgroundView.layer.borderColor = options.backgroundColor.getUIColor().cgColor
        } else {
            priceContainer.isHidden = true
            priceIconLabel.removeFromSuperview()
        }
    }
    
}
