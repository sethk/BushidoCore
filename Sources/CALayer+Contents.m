//
//  CALayer+Contents.m
//  MBTI
//
//  Created by Seth Kingsley on 11/13/12.
//  Copyright (c) 2012 Monkey Republic Design, LLC. All rights reserved.
//

#import "CALayer+Contents.h"

@implementation CALayer (Contents)

- (void)setContentsImage:(UIImage *)image
{
	[self setContents:(id)[image CGImage]];
	[self setContentsScale:[image scale]];
}

@end
