//
//  HexView.h
//  BushidoCore
//
//  Created by Seth Kingsley on 10/15/06.
//  Copyright © 2006 Bushido Coding. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol BCHexContent

@property (copy, readonly, nonatomic) NSData *data;
- (NSIndexPath *)fieldIndexPathForOffset:(NSUInteger)byteIndex;
- (NSRange)rangeForFieldAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface BCHexView : NSTextView
{
@private
    id _contentObjectController;
    NSString *_contentObjectKeyPath;
    id<BCHexContent> _contentObject;
    id _selectionIndexPathsController;
    NSString *_selectionIndexPathsKeyPath;
}

- (void)setObjectValue:(NSObject *)object;
- (id<BCHexContent>)contentObject;
- (void)setContentObject:(id<BCHexContent>)newContentObject;

@end
