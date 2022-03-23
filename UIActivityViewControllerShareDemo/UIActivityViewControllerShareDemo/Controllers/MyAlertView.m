//
//  MyAlertView.m
//  UIActivityViewControllerShareDemo
//
//  Created by Flow on 3/23/22.
//

#import "MyAlertView.h"
#import <Masonry/Masonry.h>
#define kRedSize CGSizeMake(300, 300)

@interface MyAlertView()

@property(nonatomic, weak) MASConstraint *centerYConstraint;
@end

@implementation MyAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)]];
        [self addSubview:self.redView];
        [self.redView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(kRedSize);
            make.centerX.mas_equalTo(self.mas_centerX);
            self.centerYConstraint = make.centerY.mas_equalTo(self.mas_centerY);
        }];
    }
    return self;
}

- (void)dismiss {
    [self removeFromSuperview];
}

- (UIView *)redView {
    if (_redView == nil) {
        _redView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kRedSize.width, kRedSize.height)];
        _redView.backgroundColor = UIColor.redColor;
    }
    return _redView;
}

- (void)setOffsetY:(CGFloat)offsetY {
    NSLayoutConstraint *layoutConstraint = [self.centerYConstraint valueForKey:@"layoutConstraint"];
    layoutConstraint.constant = offsetY;
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    }];
}
@end
