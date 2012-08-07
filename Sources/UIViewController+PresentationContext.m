//
//  UIViewController+PresentationContext.m
//  BushidoCore
//
//  Created by Seth Kingsley on 8/6/12.
//  Copyright (c) 2012 Bushido Coding. All rights reserved.
//

#import "UIViewController+PresentationContext.h"

@implementation UIViewController (PresentationContext)

- (UIView *)viewForCurrentContext
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
	return [contextViewController view];
}

@end
