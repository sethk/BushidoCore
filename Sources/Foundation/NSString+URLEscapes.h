//
//  NSString+URLEscapes.h
//  BushidoCore
//
//  Created by Seth Kingsley on 7/16/11.
//  Copyright © 2011 Bushido Coding, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URLEscapes)

- (NSString *)stringByAddingURLEscapes;
- (NSString *)stringByReplacingURLEscapes;

@end
