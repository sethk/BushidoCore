//
//  BCInstantStoryboardSegue.m
//  BushidoCore
//
//  Created by Seth Kingsley on 4/11/12.
//  Copyright © 2012 Bushido Coding. All rights reserved.
//

#import "BCInstantStoryboardSegue.h"

@implementation BCInstantStoryboardSegue

- (void)perform
{
	[[self sourceViewController] presentViewController:[self destinationViewController] animated:NO completion:nil];
}

@end
