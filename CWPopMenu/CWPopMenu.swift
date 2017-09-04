//
//  CWPopMenu.swift
//  CWPopMenu
//
//  Created by WANGCHAO on 08/02/2017.
//  Copyright © 2017 guokr. All rights reserved.
//

import UIKit

protocol cwPopupProtocal {
    func getSelectedIndex(index:NSInteger)
}

public class CWPopMenu: UIView {
    
    //可配置属性
    public var arrowHeight: CGFloat = 6//箭头高度
    public var arrowWidth: CGFloat = 5//箭头宽度
    public var menuCorerRadius: CGFloat = 3.0//菜单圆角大小
    
    var delegate:cwPopupProtocal?
    
    public var borderHOffset: CGFloat = 0//菜单水平偏移量
    public var borderVOffset: CGFloat = 0//菜单垂直偏移量
    public var borderColor: UIColor = UIColor.gray//边框颜色，阴影同色
    
    public weak var actionView: UIView? = nil//菜单指向view
    
    public var menuWidth: CGFloat = 92//菜单宽度
    public var menuBgColor: UIColor = UIColor.white//菜单背景色
    
    public var itemHeight: CGFloat = 45//菜单item高度
    public var itemSperatorColor: UIColor = UIColor.gray//菜单分割线颜色
    public var itemSperatorMargin: CGFloat = 10//菜单分割线左右边距
    public var itemSpeartorHeight: CGFloat = 0.5//菜单分割线高度
    public var itemTitleFont: UIFont = UIFont.systemFont(ofSize: 13)//菜单item文字字体
    public var itemTitleNormalColor: UIColor = UIColor.gray//菜单未选中状态字体颜色
    public var itemTitleSelectedColor: UIColor = UIColor.orange//菜单选中装填颜色
    
    public var selectedIndex: Int = -1//当前选中index
    public var selectHandler: ((Int) -> Void)? = nil//选中handler，参数为选中的index
    public var cancelHandler: ((Void) -> Void)? = nil//隐藏handler，选中也会隐藏
    
    
    
    public var titles: [String] = [] {//菜单文案
        didSet {
            tableView.reloadData()
            setNeedsLayout()
        }
    }
    
    fileprivate let bgView = UIView()
    fileprivate let bgBorderView = GKFilerBorderView()
    fileprivate let tableView = UITableView(frame: CGRect.zero, style: .plain)
    
    
    //MARK: - Init Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupDataAndUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Public Methods
    
    //调用之前，请配置好属性
    func show(_ sender: UIView?) {
        guard let _sender = sender else { return }
        guard let _window = UIApplication.shared.keyWindow else { return }
        
        self.actionView = _sender
        _window.addSubview(self)
        setNeedsLayout()
    }
    
    func cancel() {
        self.cancelHandler?()
        dismiss()
    }
    
    //MARK: - Private Methods
    
    private func setupDataAndUI() {
        
        addSubview(bgView)
        addSubview(bgBorderView)
        bgBorderView.addSubview(tableView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cancel))
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(cancel))
        bgView.addGestureRecognizer(tapGesture)
        bgView.addGestureRecognizer(panGesture)
        
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        
        tableView.register(CWPopFilterMenuCell.self, forCellReuseIdentifier: CWPopFilterMenuCell.cw_identifier())
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.clear
    }
    
    fileprivate func dismiss() {
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            
            self?.bgBorderView.alpha = 0
        }) { [weak self] (complete) in
            self?.removeFromSuperview()
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        guard let _window = UIApplication.shared.keyWindow else { return }
        guard let _actionView = actionView else { return }
        
        self.frame = _window.bounds
        bgView.frame = _window.bounds
        
        let actionViewInSuperviewRect = _actionView.convert(_actionView.bounds, to: _window)
        let borderViewHeight = arrowHeight + itemHeight * CGFloat(titles.count)
        
        let arrowIsTop: Bool
        let borderOriginY: CGFloat
        if actionViewInSuperviewRect.origin.y + actionViewInSuperviewRect.size.height + borderViewHeight + borderVOffset > _window.bounds.size.height {
            arrowIsTop = false
            borderOriginY = actionViewInSuperviewRect.origin.y - borderViewHeight - borderVOffset
        } else {
            arrowIsTop = true
            borderOriginY = actionViewInSuperviewRect.origin.y + actionViewInSuperviewRect.size.height + borderVOffset
        }
        
        let arrowHOffset: CGFloat
        let borderOriginX: CGFloat
        
        let actionViewCenterX = actionViewInSuperviewRect.origin.x + actionViewInSuperviewRect.size.width / 2.0
        if actionViewCenterX < (menuWidth / 2.0 + borderHOffset) {//箭头居中时，弹窗左侧出屏幕
            borderOriginX = 1 + borderHOffset
            arrowHOffset = actionViewCenterX - menuWidth / 2.0
        } else if actionViewCenterX > (_window.bounds.size.width - menuWidth / 2.0 - borderHOffset) {//箭头居中时，弹窗右侧出屏幕
            borderOriginX = _window.bounds.size.width - menuWidth - 1 + borderHOffset
            arrowHOffset = actionViewCenterX - (_window.bounds.size.width - menuWidth / 2.0)
        } else {//正常
            borderOriginX = actionViewCenterX - menuWidth / 2.0 + borderHOffset
            arrowHOffset = 0
        }
        
        bgBorderView.isTop = arrowIsTop
        bgBorderView.arrowHOffset = arrowHOffset
        bgBorderView.borderColor = borderColor
        bgBorderView.cornerRadius = menuCorerRadius
        bgBorderView.menuBgColor = menuBgColor
        
        bgBorderView.frame = CGRect(x: borderOriginX, y: borderOriginY, width: menuWidth, height: borderViewHeight)
        
        let tableViewOriginY: CGFloat = arrowIsTop ? arrowHeight : 0
        tableView.frame = CGRect(x: 0, y: tableViewOriginY, width: menuWidth, height: borderViewHeight - arrowHeight)
    }
}

fileprivate class GKFilerBorderView: UIView {
    
    fileprivate var isTop: Bool = true
    fileprivate var arrowWidth: CGFloat = 10
    fileprivate var arrowHeight: CGFloat = 6
    fileprivate var cornerRadius: CGFloat = 3.0
    fileprivate var arrowHOffset: CGFloat = 0
    fileprivate var borderColor: UIColor = UIColor.gray
    fileprivate var menuBgColor: UIColor = UIColor.white
    
    private let borderLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private Methods
    
    fileprivate override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if rect.size.width < (arrowWidth + 2 * cornerRadius) || rect.size.height < (arrowHeight + 2 * cornerRadius) {
            return
        }
        
        let viewWidth: CGFloat = rect.size.width
        let viewHeight: CGFloat = rect.size.height
        var arrowOriginX: CGFloat = (rect.size.width - arrowWidth) / 2.0 + arrowHOffset
        arrowOriginX = max(5, arrowOriginX)
        arrowOriginX = min(viewWidth - arrowWidth - 5, arrowOriginX)
        
        let pathLine = UIBezierPath()
        pathLine.lineWidth = 1
        pathLine.lineJoinStyle = .round
        
        if isTop {//箭头在上
            
            let leftTopCornerPoint = CGPoint(x: 0, y: arrowHeight)
            let leftBottomCornerPoint = CGPoint(x: 0, y: viewHeight)
            let rightTopCornerPoint = CGPoint(x: viewWidth, y: arrowHeight)
            let rightBottomCornerPoint = CGPoint(x: viewWidth, y: viewHeight)
            
            let point01 = CGPoint(x: cornerRadius, y: arrowHeight)
            let point02 = CGPoint(x: 0, y: arrowHeight + cornerRadius)
            let point03 = CGPoint(x: 0, y: viewHeight - cornerRadius)
            let point04 = CGPoint(x: cornerRadius, y: viewHeight)
            let point05 = CGPoint(x: viewWidth - cornerRadius, y: viewHeight)
            let point06 = CGPoint(x: viewWidth, y: viewHeight - cornerRadius)
            let point07 = CGPoint(x: viewWidth, y: arrowHeight + cornerRadius)
            let point08 = CGPoint(x: viewWidth - cornerRadius, y: arrowHeight)
            let point09 = CGPoint(x: arrowOriginX + arrowWidth, y: arrowHeight)
            let point10 = CGPoint(x: arrowOriginX + arrowWidth / 2.0, y: 0)
            let point11 = CGPoint(x: arrowOriginX, y: arrowHeight)
            
            pathLine.move(to: point01)
            pathLine.addQuadCurve(to: point02, controlPoint: leftTopCornerPoint)
            pathLine.addLine(to: point03)
            pathLine.addQuadCurve(to: point04, controlPoint: leftBottomCornerPoint)
            pathLine.addLine(to: point05)
            pathLine.addQuadCurve(to: point06, controlPoint: rightBottomCornerPoint)
            pathLine.addLine(to: point07)
            pathLine.addQuadCurve(to: point08, controlPoint: rightTopCornerPoint)
            pathLine.addLine(to: point09)
            pathLine.addLine(to: point10)
            pathLine.addLine(to: point11)
            
        } else {//箭头在下
            
            let leftTopCornerPoint = CGPoint(x: 0, y: 0)
            let leftBottomCornerPoint = CGPoint(x: 0, y: viewHeight - arrowHeight)
            let rightTopCornerPoint = CGPoint(x: viewWidth, y: 0)
            let rightBottomCornerPoint = CGPoint(x: viewWidth, y: viewHeight - arrowHeight)
            
            let point01 = CGPoint(x: cornerRadius, y: 0)
            let point02 = CGPoint(x: 0, y: cornerRadius)
            let point03 = CGPoint(x: 0, y: viewHeight - cornerRadius - arrowHeight)
            let point04 = CGPoint(x: cornerRadius, y: viewHeight - arrowHeight)
            let point05 = CGPoint(x: arrowOriginX, y: viewHeight - arrowHeight)
            let point06 = CGPoint(x: arrowOriginX + arrowWidth / 2.0, y: viewHeight)
            let point07 = CGPoint(x: arrowOriginX + arrowWidth, y: viewHeight - arrowHeight)
            let point08 = CGPoint(x: viewWidth - cornerRadius, y: viewHeight - arrowHeight)
            let point09 = CGPoint(x: viewWidth, y: viewHeight - arrowHeight - cornerRadius)
            let point10 = CGPoint(x: viewWidth, y: cornerRadius)
            let point11 = CGPoint(x: viewWidth - cornerRadius, y: 0)
            
            pathLine.move(to: point01)
            pathLine.addQuadCurve(to: point02, controlPoint: leftTopCornerPoint)
            pathLine.addLine(to: point03)
            pathLine.addQuadCurve(to: point04, controlPoint: leftBottomCornerPoint)
            pathLine.addLine(to: point05)
            pathLine.addLine(to: point06)
            pathLine.addLine(to: point07)
            pathLine.addLine(to: point08)
            pathLine.addQuadCurve(to: point09, controlPoint: rightBottomCornerPoint)
            pathLine.addLine(to: point10)
            pathLine.addQuadCurve(to: point11, controlPoint: rightTopCornerPoint)
        }
        
        pathLine.close()
        
        layer.insertSublayer(borderLayer, at: 0)
        
        borderLayer.path = pathLine.cgPath
        borderLayer.strokeColor = UIColor.clear.cgColor
        borderLayer.shadowColor = borderColor.cgColor
        borderLayer.shadowRadius = 2.0
        borderLayer.shadowOpacity = 0.5
        borderLayer.shadowOffset = CGSize(width: 0, height: 0)
        borderLayer.fillColor = menuBgColor.cgColor
    }
    
}

extension CWPopMenu: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CWPopFilterMenuCell.cw_identifier(), for: indexPath) as! CWPopFilterMenuCell
        cell.configureCell(withTitle: titles[(indexPath as NSIndexPath).row],
                           selected: (indexPath as NSIndexPath).row == selectedIndex,
                           isLast: (indexPath as NSIndexPath).row == titles.count - 1,
                           itemSperatorColor: itemSperatorColor,
                           itemSperatorMargin: itemSperatorMargin,
                           itemSpeartorHeight: itemSpeartorHeight,
                           itemTitleFont: itemTitleFont,
                           itemTitleNormalColor: itemTitleNormalColor,
                           itemTitleSelectedColor: itemTitleSelectedColor)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return itemHeight
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectHandler?(indexPath.row)
        delegate?.getSelectedIndex(index: indexPath.row)
        dismiss()
    }
}

fileprivate class CWPopFilterMenuCell: UITableViewCell {
    
    //MARK: - Property
    fileprivate let titleLabel = UILabel()
    fileprivate let bottomLine = UIView()
    
    private var itemSperatorMargin: CGFloat = 10//菜单分割线左右边距
    private var itemSpeartorHeight: CGFloat = 0.5//菜单分割线高度
    
    //MARK: - Public Methods
    
    func configureCell(withTitle title: String, selected: Bool, isLast: Bool, itemSperatorColor: UIColor, itemSperatorMargin: CGFloat, itemSpeartorHeight: CGFloat, itemTitleFont: UIFont, itemTitleNormalColor: UIColor, itemTitleSelectedColor: UIColor) {
        titleLabel.text = title
        titleLabel.font = itemTitleFont
        titleLabel.textColor = selected ? itemTitleSelectedColor : itemTitleNormalColor
        
        bottomLine.isHidden = isLast
        bottomLine.backgroundColor = itemSperatorColor
        
        self.itemSperatorMargin = itemSperatorMargin
        self.itemSpeartorHeight = itemSpeartorHeight
        
        setNeedsLayout()
    }
    
    //MARK: - Init Methods
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupDataAndUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private Methods
    
    fileprivate func setupDataAndUI() {
        selectionStyle = .none
        contentView.backgroundColor = UIColor.clear
        backgroundColor = UIColor.clear
        
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textAlignment = .center
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(bottomLine)
    }
    
    fileprivate override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.frame = bounds
        bottomLine.frame = CGRect(x: itemSperatorMargin, y: bounds.size.height - itemSpeartorHeight, width: bounds.size.width - 2 * itemSperatorMargin, height: itemSpeartorHeight)
    }
}

fileprivate extension UIView {
    class func cw_identifier() -> String {
        return "\(NSStringFromClass(self))"
    }
}

