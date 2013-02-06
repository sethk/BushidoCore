//
//  BCObjectModeling.h
//  ClearCostMobile
//
//  Created by Seth Kingsley on 2/6/13.
//  Copyright (c) 2013 Monkey Republic Design, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RKObjectMapping, RKObjectManager;

@protocol BCObjectModeling <NSObject>

+ (RKObjectMapping *)objectMapping;
+ (void)registerWithObjectManager:(RKObjectManager *)objectManager;

@end
