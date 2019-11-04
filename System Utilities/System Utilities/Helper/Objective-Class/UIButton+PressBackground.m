//
//  UIButton+PressBackground.m
//

#import "UIButton+PressBackground.h"

@implementation UIButton (PressBackground)

- (void)updateBackgroudWhenTouch
{
    UIColor * backgroudColor = self.backgroundColor;
 
    CGColorRef color = [backgroudColor CGColor];
    NSInteger numComponents = CGColorGetNumberOfComponents(color);
    if (numComponents == 4)
    {
        const CGFloat *components = CGColorGetComponents(color);
        CGFloat red = components[0];
        CGFloat green = components[1];
        CGFloat blue = components[2];
        
        UIImage * backgroudColor = [self imageWithColor:[UIColor colorWithRed:(red - 50/(float)255)
                                                                        green:(green - 50/(float)255)
                                                                         blue:(blue - 50/(float)255)
                                                                        alpha:components[3]]];
        [self setBackgroundImage:[backgroudColor stretchableImageWithLeftCapWidth:1 topCapHeight:1] forState:UIControlStateHighlighted];
        [self setBackgroundImage:[backgroudColor stretchableImageWithLeftCapWidth:1 topCapHeight:1] forState:UIControlStateSelected];
    }
    self.clipsToBounds = YES;
    
    self.layer.cornerRadius = 2;
    self.layer.masksToBounds = YES;
}

- (void)setDisableBackgroundColor:(UIColor*)color
{
    // Highlight state
    UIImage * backgroudColor = [self imageWithColor:color];
    [self setBackgroundImage:[backgroudColor stretchableImageWithLeftCapWidth:1 topCapHeight:1] forState:UIControlStateDisabled];
}

- (void)setSelectedBackgroundColor:(UIColor*)color
{
    UIImage * backgroudColor = [self imageWithColor:color];
    [self setBackgroundImage:[backgroudColor stretchableImageWithLeftCapWidth:1 topCapHeight:1] forState:UIControlStateSelected];
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
