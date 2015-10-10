//
//  SDPhotoTopBar.m
//  SDResuePhotoBroswer
//
//  Created by ssdd on 15/10/10.
//  Copyright © 2015年 ssdd. All rights reserved.
//

#import "SDPhotoTopBar.h"
#import "Masonry.h"
@interface SDPhotoTopBar()
@property (nonatomic,strong) UIImageView *imageView;/**< 勾选状态*/
@end

@implementation SDPhotoTopBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    [self addSubview:self.imageView];
    
    [self layoutPageSubview];
    
    return self;
}
- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    [self updateImageView];
}
- (void)modifySelectedStatus:(UITapGestureRecognizer *)tap {
    _isSelected = !_isSelected;
    [self updateImageView];
    if ([self.delegate respondsToSelector:@selector(selectStatusClick)]) {
        [self.delegate selectStatusClick];
    }
}
- (void)updateImageView {
    if (_isSelected) {
        [self.imageView setImage:[UIImage imageNamed:@"input_cheaked"]];
        [UIView animateWithDuration:0.1 animations:^{
            self.imageView.transform = CGAffineTransformMakeScale(1.2, 1.2);

        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.05 animations:^{
                self.imageView.transform = CGAffineTransformIdentity;
            }];
            
        }];
        

    }
    else {
        [self.imageView setImage:[UIImage imageNamed:@"input_nocheaked"]];

    }
}
- (void)layoutPageSubview {
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY).offset(5);
        make.right.equalTo(self.mas_right).offset(-10);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
}
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(modifySelectedStatus:)];
        tap.numberOfTapsRequired = 1;
        [_imageView addGestureRecognizer:tap];
    }
    return _imageView;
}
@end
