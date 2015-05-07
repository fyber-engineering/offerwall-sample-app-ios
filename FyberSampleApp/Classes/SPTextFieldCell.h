//
//
// Copyright (c) 2015 Fyber. All rights reserved.
//
//

#import "SPBaseCell.h"

@interface SPTextFieldCell : SPBaseCell

///--------------------------------------------------
/// @name Subclass of `SPBaseCell` with `UITextField`
///--------------------------------------------------

/**
 Outlet to `UITextField` element.

 @see `SPTextFieldCell.xib`
 */
@property (nonatomic, weak) IBOutlet UITextField *textField;

@end
