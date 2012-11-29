//
//  UIWindow+RelativeControllers.m
//  MBTI
//
//  Created by Seth Kingsley on 11/28/12.
//  Copyright (c) 2012 Monkey Republic Design, LLC. All rights reserved.
//

#import "UIWindow+RelativeControllers.h"

@implementation UIWindow (RelativeControllers)

- (UIViewController *)highestVisibleViewController
{
	UIViewController *rootViewController = [self rootViewController];
	if ([rootViewController isKindOfClass:[UINavigationController class]])
		return [(UINavigationController *)rootViewController visibleViewController];
	else
		return rootViewController;
}

@end
