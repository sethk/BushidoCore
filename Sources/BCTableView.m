//
//  BCTableView.m
//  BushidoCore
//
//  Created by Seth Kingsley on 12/11/11.
//  Copyright © 2011 Bushido Coding. All rights reserved.
//

#import "BCTableView.h"

@implementation BCTableView

- (void)keyDown:(NSEvent *)theEvent
{
	BOOL eventHandled = NO;
	NSString *characters = [theEvent characters];
	if ([characters length] == 1)
	{
		switch ([characters characterAtIndex:0])
		{
			case NSBackspaceCharacter:
			case NSDeleteCharacter:
			{
				id<NSTableViewDelegate> delegate = [self delegate];
				if ([delegate respondsToSelector:@selector(remove:)])
				{
					[(id)delegate remove:self];
					eventHandled = YES;
				}
				break;
			}

			case NSCarriageReturnCharacter:
			case NSEnterCharacter:
			{
				id<NSTableViewDelegate> delegate = [self delegate];
				if ([delegate respondsToSelector:@selector(add:)])
				{
					[(id)delegate add:self];
					eventHandled = YES;
				}
				break;
			}
		}
	}

	if (!eventHandled)
		[super keyDown:theEvent];
}

@end
