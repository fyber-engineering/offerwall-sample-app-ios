//
//  SPUserSettingsModel.h
//  SponsorPayTestApp
//
//  Created by Piotr  on 21/07/14.
//  Copyright (c) 2014 SponsorPay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SPBaseCell.h"

#define IS_iOS7 (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1)

@class SPSwitchCell;

@protocol SPUserSettingsModelDelegate;

/**
 `SPUserSettingsModel` is a model class for `SPUserSettingsViewController`.
 Object of this class is initilised in SPUserSettingsViewController.xib file. The purpose of this class is to seperate the table modeling methods out of the table view controller. The instance of this class feeds the data to the table view and conforms to table delegate protocol. It provides all functionality in order to assure correct implementation of the table view.
 
 @discussion The structure of the user data is split into 2 section - `Basic` and `Extra`. `Basic` request the personal information, `Extra` are the information related to the device and the suystem.
 */

@interface SPUserSettingsModel : NSObject



///------------------------------------------
/// @name Model class for user settings table
///------------------------------------------

/**
 Delegate object of `SPUserSettingsModel`
 */
@property (nonatomic, weak) id<SPUserSettingsModelDelegate> delegate;

/**
 Reference to table view
 */
@property (nonatomic, weak) IBOutlet UITableView *tableView;

/**
 Provides type of cell associated to index path
 
 @param indexPath Index path of the cell
 @return `SPCellType` enum type of the cell
 */
-(SPCellType) cellTypeForIndexPath:(NSIndexPath *)indexPath;

@end

@protocol SPUserSettingsModelDelegate <NSObject>

///--------------------------------------
/// SPUserSettingsModel delegate protocol
///--------------------------------------

/**
 Shows picker view for selected cell
 
 @param indexPath Index path of cell that requests picker view to be shown
 */

- (void) showPickerViewForIndexPath:(NSIndexPath *)indexPath;

/**
 Informs delegate object that switch has changed in one of the cell and expecting update of the user

 @param cell Cell the switch belongs to
 */
- (void) switchHasChanged:(SPSwitchCell *)cell;

/**
 Request associated index path for displayed picker view
 
 @return Index path of cell which requested picker view
 */
- (NSIndexPath *) pickerIndexPath;

- (void) reloadLocationForCellAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface UIView (SuperView)

///-------------------------
///Category of UIView
///-------------------------

/**
 Searches for super view of subview
 
 @param superViewClass Kind of class it is expected to find as superview
 @return `UIView` type of object if found otherwise nil
 
 @code
 
 UITableViewCell *cell = (UITableViewCell *)[textField findSuperViewWithClass:[UITableViewCell class]];

 @endcode

 */

- (UIView *)findSuperViewWithClass:(Class)superViewClass;

@end
