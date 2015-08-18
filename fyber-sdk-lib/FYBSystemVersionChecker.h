//
//
// Copyright (c) 2015 Fyber. All rights reserved.
//
//

#import <Foundation/Foundation.h>

@interface FYBSystemVersionChecker : NSObject

+ (BOOL)runningOniOS5OrNewer;
+ (BOOL)runningOniOS6OrNewer;
+ (BOOL)runningOniOS7OrNewer;
+ (BOOL)checkForiOSVersion:(NSString *)versionString;

@end
