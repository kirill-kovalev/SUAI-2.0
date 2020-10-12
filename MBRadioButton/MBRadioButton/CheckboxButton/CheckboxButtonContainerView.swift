//
//  CheckboxButtonContainerView.swift
//  RadioCheckboxButton
//
//  Created by Manish Bhande on 14/01/18.
//  Copyright © 2018 Manish. All rights reserved.
//

import UIKit

/// View container that hold all CheckboxButton available as first immediate subview only
open class MBCheckboxButtonContainerView: UIView {
    private var _buttonContainer = MBCheckboxButtonContainer()
    
    /// Access button container for more features
    /// You can not change buttonContainer
    public var buttonContainer: MBCheckboxButtonContainer {
        return _buttonContainer
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Load all Checkbox button
        let buttons = subviews
        for case let button as MBCheckboxButtonContainer.Kind in buttons {
            addButton(button)
        }
    }
    
    /// Ading subview in button conatiner if it is CheckboxButton
    open override func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)
        guard let button = subview as? MBCheckboxButtonContainer.Kind else { return }
        addButton(button)
    }
    
    /// Removing CheckboxButton from container
    open override func willRemoveSubview(_ subview: UIView) {
        super.willRemoveSubview(subview)
        guard let button = subview as? MBCheckboxButtonContainer.Kind else { return }
        removeButton(button)
    }
    
    /// Add button in container even if it is not added as subview in container view
    ///
    /// - Parameter button: CheckboxButtonContainer
    public func addButton(_ button: MBCheckboxButtonContainer.Kind) {
        buttonContainer.addButton(button)
    }
    
    /// Remove button from container. It will not remove from view. User removefromSuperview method delete button from view.
    ///
    /// - Parameter button: CheckboxButtonContainer
    public func removeButton(_ button: MBCheckboxButtonContainer.Kind) {
        buttonContainer.removeButton(button)
    }
    
}
