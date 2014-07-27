//
//  NSError+Generic.h
//  BushidoCore
//
//  Created by Seth Kingsley on 1/25/12.
//  Copyright © 2012 Bushido Coding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (Generic)

+ genericErrorWithTitle:(NSString *)title format:(NSString *)format, ...;

@end
