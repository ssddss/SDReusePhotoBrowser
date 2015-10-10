//
//  SDPhotoReuseableViewController.m
//  SDResuePhotoBroswer
//
//  Created by ssdd on 15/10/10.
//  Copyright © 2015年 ssdd. All rights reserved.
//

#import "SDPhotoReuseableViewController.h"
#import "HZPhotoBrowserView.h"
#import "HZPhotoBrowserConfig.h"
@interface SDPhotoReuseableViewController ()
@property (strong, nonatomic) HZPhotoBrowserView *photoView;

@end

@implementation SDPhotoReuseableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.photoView];
    [self SDPhoto_reloadData];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setPage:(NSNumber *)page
{
    if (_page != page) {
        _page = page;
        [self SDPhoto_reloadData];
    }
    NSLog(@"instance: %d",self.numberOfInstance);
}
- (void)SDPhoto_reloadData {
    if ([self.page integerValue] %2 == 0) {
        [self.photoView setimageWithLocalImage:[UIImage imageNamed:@"input_cheaked"]];
    }
    else if([self.page integerValue] == 1)
    {
        [self.photoView setimageWithLocalImage:[UIImage imageNamed:@"mine"]];
    }
    else {
        [self.photoView setimageWithLocalImage:[UIImage imageNamed:@"mine_select"]];
        
    }
}
- (HZPhotoBrowserView *)photoView {
    if (!_photoView) {
        _photoView = [[HZPhotoBrowserView alloc] init];
        _photoView.frame = CGRectMake(0, 0, kAPPWidth, kAppHeight);
        __weak __typeof(self)weakSelf = self;
        _photoView.singleTapBlock = ^(UITapGestureRecognizer *recognizer){
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if ([strongSelf.delegate respondsToSelector:@selector(singleTap)]) {
                [strongSelf.delegate singleTap];
            }
        };
    }
    return _photoView;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
