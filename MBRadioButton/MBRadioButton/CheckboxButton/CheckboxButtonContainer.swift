//
//  CheckboxButtonContainer.swift
//  RadioCheckboxButton
//
//  Created by Manish Bhande on 13/01/18.
//  Copyright © 2018 Manish. All rights reserved.
//

import Foundation

/// Hold all CheckboxButton button
public class MBCheckboxButtonContainer: MBRadioCheckboxBaseContainer<MBCheckboxButton> {
    /// Checkbox delegate will be assigned to all button added in container
    public weak var delegate: MBCheckboxButtonDelegate? {
        didSet {
            allButtons.forEach { $0.delegate = delegate }
        }
    }
    
    /// Overrideding for seeting delegate
    @discardableResult
    public override func addButton(_ button: Kind) -> Bool {
        button.delegate = delegate
        return super.addButton(button)
    }
    
    /// Set common color for all button added in container
    /// No guarantee for newly added buttons
    public var checkboxButtonColor: MBCheckBoxColor? {
        didSet {
            guard let color = checkboxButtonColor else { return }
            setEachCheckboxButtonColor { _ in return color}
        }
    }
    
    /// Set common radio circel style for all button added in container
    /// No guarantee for newly added buttons
    public var checkboxLineStyle: MBCheckboxLineStyle? {
        didSet {
            guard let style =  checkboxLineStyle else { return }
            setEachCheckboxButtonLineStyle { _ in return style }
        }
    }
    
    /// Set separate color style for each checkbox button added in conatainer
    ///
    /// - Parameter body: (CheckboxButton) -> CheckBoxColor
    public func setEachCheckboxButtonColor(_ body: (Kind) -> MBCheckBoxColor) {
        allButtons.forEach {
            $0.checkBoxColor = body($0)
        }
    }
    
    /// Apply separate CheckboxLine style for each style added in container
    ///
    /// - Parameter body: (CheckboxButton) -> CheckboxLineStyle
    public func setEachCheckboxButtonLineStyle(_ body: (Kind) -> MBCheckboxLineStyle) {
        allButtons.forEach {
            $0.checkboxLine = body($0)
        }
    }
    
}
