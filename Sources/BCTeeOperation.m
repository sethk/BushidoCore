//
//  BCTeeOperation.m
//  BushidoCore
//
//  Created by Seth Kingsley on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BCTeeOperation.h"

@implementation BCTeeOperation

- initWithFileHandle:(NSFileHandle *)fileHandle
{
	if ((self = [super init]))
	{
		_fileHandle = RETAIN(fileHandle);
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

- (void)dealloc
{
	DESTROY(_fileHandle);
	DESTROY(_firstPipe);
	DESTROY(_secondPipe);

	SUPER_DEALLOC();
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
