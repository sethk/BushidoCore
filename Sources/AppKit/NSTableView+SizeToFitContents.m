//
//  NSTableView+SizeToFitContents.m
//  BushidoCore
//
//  Created by Seth Kingsley on 12/9/11.
//  Copyright © 2011 Bushido Coding. All rights reserved.
//

#import "NSTableView+SizeToFitContents.h"

@implementation NSTableView (SizeToFitContents)

- (void)sizeToFitContents
{
	NSInteger numRows = [self numberOfRows];
	if (numRows)
	{
		NSArray *columns = [self tableColumns];
		NSUInteger numColumns = [columns count];
		CGFloat totalWidth = 0;
		for (NSUInteger columnIndex = 0; columnIndex < numColumns; ++columnIndex)
		{
			NSTableColumn *column = [columns objectAtIndex:columnIndex];
			CGFloat columnWidth = [column minWidth];
			for (NSInteger rowIndex = 0; rowIndex < numRows; ++rowIndex)
			{
				NSCell *cell = [self preparedCellAtColumn:columnIndex row:rowIndex];
				columnWidth = MAX(columnWidth, [cell cellSize].width);
			}
			if (columnIndex < numColumns - 1)
			{
				[column setWidth:columnWidth];
				totalWidth+= columnWidth;
			}
			else
			{
				[column setMinWidth:columnWidth];
				[column setWidth:MAX(columnWidth, [[self superview] bounds].size.width - totalWidth)];
			}
		}
	}
	else
		[self sizeToFit];
}

@end
