//
//
// Copyright (c) 2015 Fyber. All rights reserved.
//
//

#import "SPBaseCell.h"

@interface SPDoubleTextFieldCell : SPBaseCell

///--------------------------------------------------
/// @name Subclass of `SPBaseCell` with 2 `UITextField`
///--------------------------------------------------

/**
 Outlet to `UITextField` element representing key.

 @see `SPDoubleTextFieldCell.xib`
 */
@property (nonatomic, weak) IBOutlet UITextField *keyTextField;

/**
 Outlet to `UITextField` element representing value.

 @see `SPDoubleTextFieldCell.xib`
 */
@property (nonatomic, weak) IBOutlet UITextField *valueTextField;

@end
