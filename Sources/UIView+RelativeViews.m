#import "UIView+RelativeViews.h"

@implementation UIView (RelativeViews)

- (UIView *)ancestorViewOfKindClass:(Class)class
{
	UIView *superview = [self superview];
	while (superview)
	{
		if ([superview isKindOfClass:class])
			break;
		else
			superview = [superview superview];
	}
	return superview;
}

- (NSArray *)descendantViewsOfKindClass:(Class)class
{
	NSMutableArray *views = [NSMutableArray array];
	for (UIView *subview in [self subviews])
	{
		if ([subview isKindOfClass:class])
			[views addObject:subview];
		[views addObjectsFromArray:[subview descendantViewsOfKindClass:class]];
	}
	return views;
}

@end
