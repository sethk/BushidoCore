//
//  BCRectUtilities.h
//  BushidoCore
//
//  Created by Seth Kingsley on 9/12/12.
//  Copyright © 2012 Bushido Coding. All rights reserved.
//

#import "BCMacros.h"

static inline __attribute__((const)) CGRect
BCRectAspectFit(CGRect containerRect, CGSize contentSize)
{
	if (contentSize.width == 0)
		contentSize.width = 1;
	CGFloat contentAspect = contentSize.height / contentSize.width;
	if (CGRectGetWidth(containerRect) == 0)
		containerRect.size.width = 1;
	CGFloat containerAspect = CGRectGetHeight(containerRect) / CGRectGetWidth(containerRect);
	CGRect scaledRect;
	if (containerAspect < contentAspect)
	{
		CGFloat scaledWidth = roundf(CGRectGetHeight(containerRect) / contentAspect);
		CGFloat xOffset = roundf((CGRectGetWidth(containerRect) - scaledWidth) / 2);
		scaledRect = CGRectMake(CGRectGetMinX(containerRect) + xOffset, CGRectGetMinY(containerRect),
								scaledWidth, CGRectGetHeight(containerRect));
	}
	else
	{
		CGFloat scaledHeight = roundf(CGRectGetWidth(containerRect) * contentAspect);
		CGFloat yOffset = roundf((CGRectGetHeight(containerRect) - scaledHeight) / 2);
		scaledRect = CGRectMake(CGRectGetMinX(containerRect), CGRectGetMinY(containerRect) + yOffset,
								CGRectGetWidth(containerRect), scaledHeight);
	}
	POSTCONDITION_C(CGRectContainsRect(containerRect, scaledRect));
	POSTCONDITION_C(CGRectEqualToRect(scaledRect, CGRectIntegral(scaledRect)));
	return scaledRect;
}

