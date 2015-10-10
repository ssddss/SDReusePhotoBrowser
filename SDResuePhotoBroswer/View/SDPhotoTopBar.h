//
//  SDPhotoTopBar.h
//  SDResuePhotoBroswer
//
//  Created by ssdd on 15/10/10.
//  Copyright © 2015年 ssdd. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SDPhotoTopBarDelegate<NSObject>
- (void)selectStatusClick;
@end
@interface SDPhotoTopBar : UIView
@property (nonatomic,weak) id<SDPhotoTopBarDelegate> delegate;
@property (nonatomic,assign) BOOL isSelected;/**< 选中状态*/

@end
