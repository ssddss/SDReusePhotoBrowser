//
//  SDPhotoBottomBar.m
//  SDResuePhotoBroswer
//
//  Created by ssdd on 15/10/10.
//  Copyright © 2015年 ssdd. All rights reserved.
//

#import "SDPhotoBottomBar.h"
#import "Masonry.h"
@interface SDPhotoBottomBar()
@property (nonatomic,strong) UIButton *doneButton;/**< 完成按钮*/
@property (nonatomic,strong) UILabel *countLabel;/**< 已选图片数量*/
@end
@implementation SDPhotoBottomBar

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
    [self addSubview:self.doneButton];
    [self addSubview:self.countLabel];
    [self layoutPageSubview];
    return self;
}

- (void)layoutPageSubview {
    [self.doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-10);
    }];
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.doneButton.mas_left).offset(-4);
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.centerY.equalTo(self.mas_centerY);
    }];
}
- (void)updateSelectPhotoCount:(NSInteger)count {
    if (count == 0) {
        self.countLabel.hidden = YES;
        return;
    }
    self.countLabel.hidden = NO;
    self.countLabel.text = [NSString stringWithFormat:@"%d",count];
    self.countLabel.transform = CGAffineTransformMakeScale(0, 0);

    [UIView animateWithDuration:0.25 animations:^{
        self.countLabel.transform = CGAffineTransformMakeScale(1.2, 1.2);
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.05 animations:^{
            self.countLabel.transform = CGAffineTransformIdentity;
        }];
        
    }];}
- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel= [UILabel new];
        _countLabel.layer.masksToBounds = YES;
        _countLabel.layer.cornerRadius = 15;
        _countLabel.backgroundColor = [UIColor greenColor];
        _countLabel.textColor = [UIColor whiteColor];
        _countLabel.font = [UIFont boldSystemFontOfSize:15];
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.hidden = YES;
    }
    return _countLabel;
}
- (UIButton *)doneButton {
    if (!_doneButton) {
        _doneButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_doneButton setTitle:@"完成" forState:UIControlStateNormal];
        [_doneButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    }
    return _doneButton;
}
@end
