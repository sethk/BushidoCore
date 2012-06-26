#import <UIKit/UIView.h>

@interface UIView (RelativeViews)

- (UIView *)ancestorViewOfKindClass:(Class)class;
- (NSArray *)descendantViewsOfKindClass:(Class)class;

@end
