//
//  BCSplitView.m
//  BushidoCore
//
//  Created by Seth Kingsley on 12/28/11.
//  Copyright © 2011 Bushido Coding. All rights reserved.
//

#import "BCSplitView.h"

@implementation BCSplitView

// Not tested with more than 2 views:
- (void)adjustSubviews
{
	[super adjustSubviews];

	id<NSSplitViewDelegate> delegate = [self delegate];
	if ([delegate respondsToSelector:@selector(splitView:constrainMaxCoordinate:ofSubviewAt:)] ||
			[delegate respondsToSelector:@selector(splitView:constrainMinCoordinate:ofSubviewAt:)])
	{
		BOOL isVertical = [self isVertical];
		NSRect bounds = [self bounds];
		CGFloat dividerThickness = [self dividerThickness];
		NSArray *subviews = [self subviews];
		NSUInteger numSubviews = [subviews count];
		CGFloat frameOrigin = 0;
		for (NSUInteger subviewIndex = 0; subviewIndex < numSubviews; ++subviewIndex)
		{
			NSView *subview = [subviews objectAtIndex:subviewIndex];
			NSRect subviewFrame = [subview frame];
			const NSRect originalSubviewFrame = subviewFrame;

			if (isVertical)
				subviewFrame.origin.x = frameOrigin;
			else
				subviewFrame.origin.y = frameOrigin;

			CGFloat length = (isVertical) ? bounds.size.width : bounds.size.height;
			if (subviewIndex < numSubviews - 1)
			{
				CGFloat minPosition = frameOrigin;
				if ([delegate respondsToSelector:@selector(splitView:constrainMinCoordinate:ofSubviewAt:)])
					minPosition = [delegate splitView:self constrainMinCoordinate:minPosition ofSubviewAt:subviewIndex];

				CGFloat maxPosition = length;
				if ([delegate respondsToSelector:@selector(splitView:constrainMaxCoordinate:ofSubviewAt:)])
					maxPosition = [delegate splitView:self constrainMaxCoordinate:maxPosition ofSubviewAt:subviewIndex];

				if (isVertical)
					frameOrigin = MIN(MAX(subviewFrame.origin.x + subviewFrame.size.width, minPosition), maxPosition);
				else
					frameOrigin = MIN(MAX(subviewFrame.origin.y + subviewFrame.size.height, minPosition), maxPosition);
			}
			else
				frameOrigin = length;

			if (isVertical)
				subviewFrame.size.width = frameOrigin - subviewFrame.origin.x;
			else
				subviewFrame.size.height = frameOrigin - subviewFrame.origin.y;

			if (!NSEqualRects(subviewFrame, originalSubviewFrame))
			{
				//TRACE(VIEWS, @"Would set frame for %@ to %@", subview, NSStringFromRect(subviewFrame));
				[subview setFrame:subviewFrame];
			}

			frameOrigin+= dividerThickness;
		}
	}
}

@end
