//
//  HexView.m
//  BushidoCore
//
//  Created by Seth Kingsley on 10/15/06.
//  Copyright © 2006 Bushido Coding. All rights reserved.
//

#import "BCHexView.h"

#define	kBytesPerLine	    030
static NSString		*kLinePrefixFormat = @"%06o:";
#define kLinePrefixLength   7u
static NSString		*kHexCharFormat = @" %02x";
static NSString		*kHexCharSpacer = @"   ";
#define kHexCharWidth	    3u
static NSString		*kBytesPrefix = @"  |";
#define kBytesPrefixLength  3u
static NSString		*kLineSuffix = @"|\n";
#define kLineSuffixLength   2u
static const unsigned	kCharsPerLine = kLinePrefixLength +
	kBytesPerLine * kHexCharWidth +
	kBytesPrefixLength + kBytesPerLine + kLineSuffixLength;

@interface BCHexView (PrivateAPI)

- (NSString *)hexDumpOfData:(NSData *)data;
- (NSArray *)characterRangesFromByteRange:(NSRange)range;
- (unsigned)byteIndexFromCharacterIndex:(unsigned)charIndex;

@end

@implementation BCHexView (PrivateAPI)

- (NSString *)hexDumpOfData:(NSData *)data
{
    NSMutableString *hexDump = [NSMutableString string];
    const u_char *bytes = [data bytes];

    unsigned offset, length = [data length];

    for (offset = 0; offset < length; offset+= kBytesPerLine)
    {
	unsigned i, numLineBytes = MIN(length - offset, kBytesPerLine);
	const u_char *lineBytes = bytes + offset;

	[hexDump appendFormat:kLinePrefixFormat, offset];
	for (i = 0; i < kBytesPerLine; ++i)
	    if (i < numLineBytes)
		[hexDump appendFormat:kHexCharFormat, lineBytes[i]];
	    else
		[hexDump appendString:kHexCharSpacer];

	[hexDump appendString:kBytesPrefix];
	for (i = 0; i < kBytesPerLine; ++i)
	    if (i < numLineBytes)
		[hexDump appendFormat:@"%c",
		    (isprint(lineBytes[i]) && !isspace(lineBytes[i])) ?
			lineBytes[i] : '.'];
	    else
		[hexDump appendString:@" "];
	[hexDump appendString:kLineSuffix];
    }

    return hexDump;
}

- (NSArray *)characterRangesFromByteRange:(NSRange)range
{
    NSMutableArray *ranges = [NSMutableArray array];
    unsigned line, offset, length, lineBytes;

    line = range.location / kBytesPerLine;
    offset = range.location % kBytesPerLine;
    for (length = range.length; length; length-= lineBytes, ++line)
    {
	NSRange range;
	unsigned lineOffset = line * kCharsPerLine + kLinePrefixLength;

	lineBytes = MIN(length, kBytesPerLine - offset);
	range.location = lineOffset + 1 + offset * kHexCharWidth;
	range.length = lineBytes * kHexCharWidth - 1;
	[ranges addObject:[NSValue valueWithRange:range]];

	range.location = lineOffset + kBytesPerLine * kHexCharWidth +
		kBytesPrefixLength + offset;
	range.length = lineBytes;
	[ranges addObject:[NSValue valueWithRange:range]];

	offset = 0;
    }

    return ranges;
}

- (unsigned)byteIndexFromCharacterIndex:(unsigned)charIndex
{
    unsigned line = charIndex / kCharsPerLine,
	     lineOffset = charIndex % kCharsPerLine;

    if (lineOffset >= kLinePrefixLength &&
	    lineOffset < kLinePrefixLength + kBytesPerLine * kHexCharWidth)
	return line * kBytesPerLine +
		(lineOffset - kLinePrefixLength) / kHexCharWidth;
    else if (lineOffset >= kLinePrefixLength + kBytesPerLine * kHexCharWidth +
	    kBytesPrefixLength &&
	    lineOffset < kCharsPerLine - kLineSuffixLength)
	return line * kBytesPerLine +
		(lineOffset - (kLinePrefixLength + kBytesPerLine *
			       kHexCharWidth + kBytesPrefixLength));
    else
	return NSNotFound;
}

@end

@implementation BCHexView

- (void)dealloc
{
    DESTROY(_contentObjectKeyPath);
    DESTROY(_selectionIndexPathsKeyPath);

    SUPER_DEALLOC();
}

- (void)bind:(NSString *)binding
    toObject:(id)observableController
 withKeyPath:(NSString *)keyPath
     options:(NSDictionary *)options
{
#if 0
    NSLog(@"[%@ bind:%@ toObject:%@ withKeyPath:%@ ...]",
	    self, binding, observableController, keyPath);
#endif // 0

    if ([binding isEqualToString:@"contentObject"])
    {
	[observableController addObserver:self
			       forKeyPath:keyPath
				  options:0
				  context:NULL];
	_contentObjectController = observableController;
	_contentObjectKeyPath = [keyPath copy];
    }
    else if ([binding isEqualToString:@"selectedIndexPaths"])
    {
	[observableController addObserver:self
			       forKeyPath:keyPath
				  options:0
				  context:NULL];
	_selectionIndexPathsController = observableController;
	_selectionIndexPathsKeyPath = [keyPath copy];
    }
    else
	return [super bind:binding
		  toObject:observableController
	       withKeyPath:keyPath
		   options:options];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
		      ofObject:(id)object
			change:(NSDictionary *)change
		       context:(void *)context
{
#if 0
    NSLog(@"[%@ observeValueForKeyPath:%@ ...]", self, keyPath);
#endif // 0

    if (object == _contentObjectController && [keyPath isEqualToString:_contentObjectKeyPath])
    {
	NSArray *contentObjects = [_contentObjectController valueForKeyPath:_contentObjectKeyPath];

	[self setContentObject:([contentObjects count]) ? [contentObjects objectAtIndex:0] : nil];
    }
    else if (object == _selectionIndexPathsController && [keyPath isEqualToString:_selectionIndexPathsKeyPath])
    {
	NSArray *selectionIndexPaths = [_selectionIndexPathsController valueForKeyPath:_selectionIndexPathsKeyPath];
	NSArray *selectedRanges;
	NSUInteger numIndexPaths = [selectionIndexPaths count];
	if (numIndexPaths)
	{
	    NSMutableArray *charRanges = [NSMutableArray arrayWithCapacity:numIndexPaths];
	    for (NSIndexPath *indexPath in selectionIndexPaths)
	    {
		NSRange dataRange = [_contentObject rangeForFieldAtIndexPath:indexPath];
		NSArray *charRangesForDataRange = [self characterRangesFromByteRange:dataRange];
		[charRanges addObjectsFromArray:charRangesForDataRange];
	    }
	    selectedRanges = charRanges;
	}
	else
	    selectedRanges = nil;

	[self setSelectedRanges:selectedRanges];
    }
    else
	return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

- (void)keyDown:(NSEvent *)theEvent
{
}

- (void)mouseDown:(NSEvent *)theEvent
{
    NSWindow *window = [self window];
    NSPoint hitPoint = [self convertPoint:[theEvent locationInWindow]
				 fromView:nil];
    unsigned charIndex = [[self layoutManager] glyphIndexForPoint:hitPoint
						  inTextContainer:[self textContainer]],
	    byteIndex = [self byteIndexFromCharacterIndex:charIndex];
    id<BCHexContent> contentObject = [self contentObject];

    if ([window firstResponder] != self)
	[window makeFirstResponder:self];

#if 1
    NSLog(@"charIndex = %u, byteIndex = %u", charIndex, byteIndex);
#endif // 0

    if (byteIndex != NSNotFound)
    {
	// TODO: modifier flags
	NSArray *selectionIndexPaths = [NSArray arrayWithObject:[contentObject fieldIndexPathForOffset:byteIndex]];
	[_selectionIndexPathsController setValue:selectionIndexPaths forKey:_selectionIndexPathsKeyPath];
    }
}

- (void)setObjectValue:(NSObject *)object
{
    if ([object conformsToProtocol:@protocol(BCHexContent)])
	[self setContentObject:(id<BCHexContent>)object];
    else if ([object isKindOfClass:[NSData class]])
	[self setString:[self hexDumpOfData:(NSData *)object]];
    else if ([object isKindOfClass:[NSString class]])
	[self setString:(NSString *)object];
    else
	[self setString:[object description]];
}

- (id<BCHexContent>)contentObject
{
    return _contentObject;
}

- (void)setContentObject:(id<BCHexContent>)newContentObject
{
    if (_contentObject != newContentObject)
    {
	_contentObject = newContentObject;
	[self setString:[self hexDumpOfData:[_contentObject data]]];
    }
}

@end
