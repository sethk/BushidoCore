#import <UIKit/UIView.h>

@interface UIView (AncestorView)

- (UIView *)ancestorViewOfKindClass:(Class)class;

@end
