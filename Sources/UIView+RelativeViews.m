#import "UIView+RelativeViews.h"

@implementation UIView (RelativeViews)

+ (void)replaceView:(UIView *)view withView:(UIView *)newView
{
	CGRect frame = [view frame];
	UIView *superview = [view superview];
	NSUInteger subviewIndex = [[superview subviews] indexOfObject:view];
	[view removeFromSuperview];
	[newView setFrame:frame];
	[superview insertSubview:newView atIndex:(signed)subviewIndex];
}

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
