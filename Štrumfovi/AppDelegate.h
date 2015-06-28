//
//  AppDelegate.h
//  Štrumfovi
//
//  Created by Mladjan Antic on 6/21/15.
//  Copyright (c) 2015 BLGRDCreative. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationTracker.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property LocationTracker * locationTracker;
@property (nonatomic) NSTimer* locationUpdateTimer;

@end

