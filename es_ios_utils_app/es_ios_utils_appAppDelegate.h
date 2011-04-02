//
//  es_ios_utils_appAppDelegate.h
//  es_ios_utils_app
//
//  Created by Peter DeWeese on 4/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class es_ios_utils_appViewController;

@interface es_ios_utils_appAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet es_ios_utils_appViewController *viewController;

@end
