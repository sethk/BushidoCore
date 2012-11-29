//
//  UIViewController+RelativeControllers.m
//  BushidoCore
//
//  Created by Seth Kingsley on 8/6/12.
//  Copyright (c) 2012 Bushido Coding. All rights reserved.
//

#import "UIViewController+RelativeControllers.h"

@implementation UIViewController (RelativeControllers)

- (UIViewController *)viewControllerForCurrentContext
{
	UIViewController *contextViewController = self;
	while (contextViewController && ![contextViewController definesPresentationContext])
		contextViewController = [contextViewController parentViewController];
	while (1)
	{
		UIViewController *modalViewController = [contextViewController presentedViewController];
		if (modalViewController && [modalViewController modalPresentationStyle] == UIModalPresentationCurrentContext)
			contextViewController = modalViewController;
		else
			break;
	}
	return contextViewController;
}

@end
