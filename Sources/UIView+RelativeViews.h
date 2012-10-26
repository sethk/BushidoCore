#import <UIKit/UIView.h>

@interface UIView (RelativeViews)

+ (void)replaceView:(UIView *)view withView:(UIView *)newView;
- (UIView *)ancestorViewOfKindClass:(Class)class;
- (NSArray *)descendantViewsOfKindClass:(Class)class;

@end
