//
//  NSError+CFStreamError.h
//  BushidoCore
//
//  Created by Seth Kingsley on 3/26/12.
//  Copyright © 2012 Bushido Coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreFoundation/CFStream.h>

@interface NSError (CFStreamError)

// This code taken from public domain code at http://code.google.com/p/cocoaasyncsocket/
+ errorWithCFStreamError:(CFStreamError)streamError;

@end
