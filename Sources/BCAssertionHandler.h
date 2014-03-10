//
//  BCAssertionHandler.h
//  DealSteal
//
//  Created by Seth Kingsley on 2/4/14.
//
//

#import <Foundation/Foundation.h>

@interface BCAssertionHandler : NSAssertionHandler <NSCopying>

+ (void)install;

@end
