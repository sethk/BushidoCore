@implementation UIView (FirstResponder)

- (UIView *)firstResponder
{
	if ([self isFirstResponder])
		return self;
	else for (UIView *subview in [self subviews])
	{
		UIView *firstResponder = [subview firstResponder];
		if (firstResponder)
			return firstResponder;
	}
	return nil;
}

@end
