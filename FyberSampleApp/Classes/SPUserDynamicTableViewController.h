//
//  SPUserDynamicTableViewController.h
//  SponsorPayTestApp
//
//  Created by Piotr  on 28/07/14.
//  Copyright (c) 2014 SponsorPay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPUserDynamicTableViewController : UITableViewController

///-----------------------------
/// @name Table view controller
///-----------------------------

/**
 This table view controller supports adding multiple entries to user. The key feature of this class is that it supports adding unlimited amount of arguments for both array and dictionary
 */

/**
 Initialisation method 
 
 @param style Table view style
 @param indexPath Index path of parent table view. By providing index path the table can be configured to either display functionality to add values to array or to dictionary.
 @return instance of `SPUserDynamicTableViewController`
 */

- (id)initWithStyle:(UITableViewStyle)style cellStructure:(NSIndexPath *)indexPath;

@end