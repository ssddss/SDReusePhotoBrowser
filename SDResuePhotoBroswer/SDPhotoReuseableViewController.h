//
//  SDPhotoReuseableViewController.h
//  SDResuePhotoBroswer
//
//  Created by ssdd on 15/10/10.
//  Copyright © 2015年 ssdd. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SDPhotoReuseableViewControllerDelegate<NSObject>
- (void)singleTap;
@end
@interface SDPhotoReuseableViewController : UIViewController
@property (nonatomic,weak) id<SDPhotoReuseableViewControllerDelegate> delegate;
@property (assign, nonatomic) NSInteger numberOfInstance;
@property (assign, nonatomic) NSNumber *page;
@end
