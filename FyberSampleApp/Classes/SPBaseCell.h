//
//
// Copyright (c) 2015 Fyber. All rights reserved.
//
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SPCellType) {
    SPCellTypeBasic,
    SPCellTypeNumericField,
    SPCellTypeTextField,
    SPCellTypeSwitch,
    SPCellTypeDatePicker,
    SPCellTypeCustomPicker,
    SPCellTypeCustomPickerWithSwitch
};

@interface SPBaseCell : UITableViewCell

///------------------------------------
/// @name Subclass of `UITableViewCell`
///------------------------------------

/**
 `SPCellType` enum representing cell type
 */

@property (nonatomic, assign) SPCellType cellType;

@end
