//
//  UIView+Snapshot.m
//  BushidoCore
//
//  Created by Seth Kingsley on 7/24/12.
//  Copyright © 2012 Bushido Coding. All rights reserved.
//

#import "UIView+Snapshot.h"
#import "BCMacros.h"
#import <QuartzCore/CALayer.h>

@implementation UIView (Snapshot)

- (UIImageView *)imageViewWithSnapshot
{
	CGRect frame = [self frame];
	UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
	BOOL isOpaque = [self isOpaque];
	[imageView setOpaque:isOpaque];
	UIScreen *screen = [[self window] screen];
	if (!screen)
	{
		NSLog(@"Warning: Making snapshot of view that isn't on screen, defaulting to main screen's scale");
		screen = [UIScreen mainScreen];
	}
	UIGraphicsBeginImageContextWithOptions(frame.size, isOpaque, [screen scale]);
	[[self layer] renderInContext:UIGraphicsGetCurrentContext()];
	[imageView setImage:UIGraphicsGetImageFromCurrentImageContext()];
	UIGraphicsEndImageContext();
	return imageView;
}

@end
