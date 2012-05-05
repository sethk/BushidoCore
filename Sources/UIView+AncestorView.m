@implementation UIView (AncestorView)

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

@end
