//
//  BCSettings.h
//  BushidoCore
//
//  Created by Seth Kingsley on 2/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BCSettings : NSObject

- initWithPListPrefix:(NSString *)plistPrefix;
- (BOOL)boolForKey:(NSString *)key;
- (double)doubleForKey:(NSString *)key;
- (NSInteger)integerForKey:(NSString *)key;
- (NSString *)stringForKey:(NSString *)key;

extern double PTDebugCoefficient;

@end

#if TARGET_OS_IPHONE
#import <UIKit/UIDevice.h>

@interface UIDevice (BCSettings)

- (NSString *)modelIdentifier;

@end
#endif // TARGET_OS_IPHONE
