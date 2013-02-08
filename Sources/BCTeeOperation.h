//
//  BCTeeOperation.h
//  BushidoCore
//
//  Created by Seth Kingsley on 5/28/12.
//  Copyright © 2012 Bushido Coding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BCTeeOperation : NSOperation
{
@protected
	NSFileHandle *_fileHandle;
	NSPipe *_firstPipe;
	NSPipe *_secondPipe;
}

- initWithFileHandle:(NSFileHandle *)fileHandle;
@property (retain, readonly, nonatomic) NSFileHandle *firstHandle, *secondHandle;

@end
