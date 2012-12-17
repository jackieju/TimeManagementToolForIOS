//
//  AppDelegate.h
//  TimeManagerForIOS4
//
//  Created by juweihua on 3/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InAppPurchaseManager.h"
@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    InAppPurchaseManager* iapm;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@end
