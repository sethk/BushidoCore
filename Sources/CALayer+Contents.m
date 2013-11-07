//
//  CALayer+Contents.m
//  BushidoCore
//
//  Created by Seth Kingsley on 11/13/12.
//  Copyright © 2012 Bushido Coding. All rights reserved.
//

#import "CALayer+Contents.h"

@implementation CALayer (Contents)

- (void)setContentsImage:(UIImage *)image
{
	[self setContents:(id)[image CGImage]];
	[self setContentsScale:[image scale]];
}

@end
