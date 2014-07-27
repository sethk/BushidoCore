//
//  UIImage+Transparent.m
//  BushidoCore
//
//  Created by Seth Kingsley on 11/19/12.
//  Copyright © 2012 Bushido Coding. All rights reserved.
//

#import "UIImage+Transparent.h"

@implementation UIImage (Transparent)

struct transparentBytesContext {off_t offset;};

static size_t
_getTransparentBytes(void *info, void *buffer, size_t count)
{
	bzero(buffer, count);
	return count;
}

static off_t
_skipTransparentBytes(void *info, off_t count)
{
	((struct transparentBytesContext *)info)->offset+= count;
	return ((struct transparentBytesContext *)info)->offset;
}

static void
_rewindTransparentBytes(void *info)
{
	((struct transparentBytesContext *)info)->offset = 0;
}

static void
_releaseTransparentInfo(void *info)
{
	CFAllocatorDeallocate(kCFAllocatorDefault, info);
}

+ (UIImage *)transparentImageWithSize:(CGSize)size
{
	CGDataProviderSequentialCallbacks callbacks =
	{
		.version = 0,
		.getBytes = _getTransparentBytes,
		.skipForward = _skipTransparentBytes,
		.rewind = _rewindTransparentBytes,
		.releaseInfo = _releaseTransparentInfo
	};
	struct transparentBytesContext *info = CFAllocatorAllocate(kCFAllocatorDefault, sizeof(*info), 0);
	CGDataProviderRef dataProvider = CGDataProviderCreateSequential(info, &callbacks);
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGImageRef CGImage = CGImageCreate((size_t)size.width, (size_t)size.height,
									   8, 32, (size_t)size.width * 4,
									   colorSpace,
									   kCGImageAlphaFirst | kCGBitmapByteOrderDefault,
									   dataProvider,
									   NULL,
									   false,
									   kCGRenderingIntentDefault);
	CGColorSpaceRelease(colorSpace);
	CGDataProviderRelease(dataProvider);
	UIImage *image = [[UIImage alloc] initWithCGImage:CGImage];
	CGImageRelease(CGImage);
	return image;
}

@end
