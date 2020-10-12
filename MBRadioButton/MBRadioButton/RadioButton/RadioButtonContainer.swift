//
//  RadioButtonGroupContainer.swift
//  RadioCheckboxButton
//
//  Created by Manish Bhande on 13/01/18.
//  Copyright © 2018 Manish. All rights reserved.
//

import Foundation

/// Hold all Radio Buttons
public class MBRadioButtonContainer: MBRadioCheckboxBaseContainer<MBRadioButton> {
    /// Radio button delegate will be assigned to all button added in container
    public weak var delegate: MBRadioButtonDelegate? {
        didSet {
            allButtons.forEach { $0.delegate = delegate }
        }
    }
    
    /// Select any radio button available in container. It will automatically deselect all other buttons
    public var selectedButton: Kind? {
        get { return selectedButtons.first }
        set {
            guard let button = newValue else {
                deselectAll()
                return
            }
            selectedButtons = [button]
        }
    }
    
    /// Making sure new button must have delegate assigned
    @discardableResult
    public override func addButton(_ button: Kind) -> Bool {
        button.delegate = delegate
        return super.addButton(button)
    }
    
    /// Deselecting previous selected button
    override func selectionChangeObserver(_ button: MBRadioButton, _ change: NSKeyValueObservedChange<Bool>) {
        super.selectionChangeObserver(button, change)
        if button.isOn {
            // Deselect on selected button excepting current selected button
            allButtons.forEach {
                if $0.isOn, button != $0 {
                    $0.isOn = false
                }
            }
        }
    }
    
    /// Set common color for all button added in container
    /// No guarantee for newly added buttons
    public var radioButtonColor: MBRadioButtonColor? {
        didSet {
            guard let color = radioButtonColor else { return }
            setEachRadioButtonColor { _ in return color }
        }
    }
    
    /// Set common radio circel style for all button added in container
    /// No guarantee for newly added buttons
    public var radioCircleStyle: MBRadioButtonCircleStyle? {
        didSet {
            guard let style =  radioCircleStyle else { return }
            setEachRadioButtonCircleStyle { _ in return style }
        }
    }
    
    /// Set separate radio button color for each button
    ///
    /// - Parameter body: (RadioButton) -> RadioButtonColor
    public func setEachRadioButtonColor(_ body: (Kind) -> MBRadioButtonColor) {
        allButtons.forEach {
                $0.radioButtonColor = body($0)
        }
    }
    
    /// Set separate radio button circle style for each button
    ///
    /// - Parameter body: (RadioButton) -> RadioButtonCircleStyle
    public func setEachRadioButtonCircleStyle(_ body: (Kind) -> MBRadioButtonCircleStyle) {
        allButtons.forEach {
                $0.radioCircle = body($0)
        }
    }
}
