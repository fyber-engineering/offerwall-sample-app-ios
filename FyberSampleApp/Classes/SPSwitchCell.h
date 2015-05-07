//
//
// Copyright (c) 2015 Fyber. All rights reserved.
//
//

#import "SPBaseCell.h"

@protocol SPSwitchCellDelegate;

@interface SPSwitchCell : SPBaseCell

///-------------------------------------------------------
/// @name Subclass of `SPBaseCell` with `UISwitch` control
///-------------------------------------------------------

/**
 Outlet to `UISwitch` element.
 
 @see `SPSwitchCell.xib`
 */
@property (nonatomic, weak) IBOutlet UISwitch *switchControl;

/**
 Delegate object
 */
@property (nonatomic, weak) id<SPSwitchCellDelegate> delegate;

@end


@protocol SPSwitchCellDelegate <NSObject>

/**
 Methods to be implemented by delegate object
 */

/**
 Delegate method to be called when switch view has changed

 @param cell Cell in which the switch view has changed
 */
- (void) didChangeSwitchView:(SPSwitchCell *)cell;

@end