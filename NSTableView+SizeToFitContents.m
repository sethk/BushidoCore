//
//  NSTableView+SizeToFitContents.m
//  HTTPFlow
//
//  Created by Seth Kingsley on 12/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NSTableView+SizeToFitContents.h"

@implementation NSTableView (SizeToFitContents)

- (void)sizeToFitContents
{
	NSUInteger numRows = [self numberOfRows];
	if (numRows)
	{
		NSArray *columns = [self tableColumns];
		NSUInteger numColumns = [columns count];
		for (NSUInteger columnIndex = 0; columnIndex < numColumns; ++columnIndex)
		{
			NSTableColumn *column = [columns objectAtIndex:columnIndex];
			CGFloat columnWidth = [column minWidth];
			for (NSUInteger rowIndex = 0; rowIndex < numRows; ++rowIndex)
				columnWidth = MAX(columnWidth, [[self preparedCellAtColumn:columnIndex row:rowIndex] cellSize].width);
			[column setWidth:columnWidth];
		}
	}
	else
		[self sizeToFit];
}

@end
