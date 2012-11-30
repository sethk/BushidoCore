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
	UIViewController *viewController = [self rootViewController];
	while (1)
	{
		UIViewController *presentedViewController = [viewController presentedViewController];
		if (presentedViewController &&
				[presentedViewController modalPresentationStyle] == UIModalPresentationFullScreen)
			viewController = presentedViewController;
		else
			return viewController;
	}
}

@end
