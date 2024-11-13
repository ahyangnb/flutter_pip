import UIKit
import SnapKit

class FloatRealContentView: UIView {
    
    public lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Hi welcome use flutter_pip plugin"
        label.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = UIColor.colorWithHexString("#FF0000")
        label.adjustsFontSizeToFitWidth = true
        label.baselineAdjustment = .alignCenters
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.backgroundColor = UIColor.colorWithHexString("#00FFFF")
        self.frame.size = CGSize(width: 213.0, height: 114.0)
        
        addSubview(nameLabel)
        
        nameLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()    // center to super view.
        }
        
    }
    
}
