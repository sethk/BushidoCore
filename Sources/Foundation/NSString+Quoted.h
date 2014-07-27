//
//  NSString+Quoted.h
//  BushidoCore
//
//  Created by Seth Kingsley on 4/11/11.
//  Copyright © 2011 Bushido Coding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Quoted)

- (NSString *)stringByTrimmingWhitesapce;
- (NSString *)unquotedString;
- (NSArray *)componentsSeparatedByStringOutsideQuotes:(NSString *)separator;
- (NSString *)stringByTruncatingToLength:(NSUInteger)length;

@end

