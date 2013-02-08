//
//  BCObjectModeling.h
//  BushidoCore
//
//  Created by Seth Kingsley on 2/6/13.
//  Copyright © 2013 Bushido Coding, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RKObjectMapping, RKObjectManager;

@protocol BCObjectModeling <NSObject>

+ (RKObjectMapping *)objectMapping;
+ (void)registerWithObjectManager:(RKObjectManager *)objectManager;

@end
