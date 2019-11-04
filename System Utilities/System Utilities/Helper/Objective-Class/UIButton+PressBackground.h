//
//  UIButton+PressBackground.h
//  SSS
//

#import <UIKit/UIKit.h>

@interface UIButton (PressBackground)

- (void)setDisableBackgroundColor:(UIColor*)color;
- (void)setSelectedBackgroundColor:(UIColor*)color;
- (void)updateBackgroudWhenTouch;

@end
