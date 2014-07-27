//
//  BCTeeOperation.m
//  BushidoCore
//
//  Created by Seth Kingsley on 5/28/12.
//  Copyright © 2012 Bushido Coding. All rights reserved.
//

#import "BCTeeOperation.h"

@implementation BCTeeOperation

- initWithFileHandle:(NSFileHandle *)fileHandle
{
	if ((self = [super init]))
	{
		_fileHandle = fileHandle;
		_firstPipe = [NSPipe new];
		_secondPipe = [NSPipe new];
	}

	return self;
}

- (void)main
{
	NSFileHandle *firstHandle = [_firstPipe fileHandleForWriting], *secondHandle = [_secondPipe fileHandleForWriting];
	NSData *data;
	@try
	{
		while (1)
		{
			data = [_fileHandle readDataOfLength:BUFSIZ];
			if ([data length])
			{
				[firstHandle writeData:data];
				[secondHandle writeData:data];
			}
			else
				break;
		}
	}
	@catch (NSException *exception)
	{
		NSLog(@"IO error in tee operation: %@", [exception reason]);
	}
	[_fileHandle closeFile];
	[firstHandle closeFile];
	[secondHandle closeFile];
}

- (NSFileHandle *)firstHandle
{
	return [_firstPipe fileHandleForReading];
}

- (NSFileHandle *)secondHandle
{
	return [_secondPipe fileHandleForReading];
}

@end
