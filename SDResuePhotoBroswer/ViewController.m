//
//  ViewController.m
//  SDResuePhotoBroswer
//
//  Created by ssdd on 15/10/10.
//  Copyright © 2015年 ssdd. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "SDPhotoTopBar.h"
#import "SDPhotoBottomBar.h"
#import "SDPhotoReuseableViewController.h"

#define TOTAL_PAGES     5

@interface ViewController ()<UIScrollViewDelegate,SDPhotoReuseableViewControllerDelegate,SDPhotoTopBarDelegate>
@property (nonatomic,strong) UIScrollView *scrollView;/**< 内容容器*/
@property (nonatomic,strong) SDPhotoTopBar *topBar;/**< 头部*/
@property (nonatomic,strong) SDPhotoBottomBar *bottomBar;/**< 底部*/

@property (strong, nonatomic) NSNumber *currentPage;/**< 当前页*/

@property (strong, nonatomic) NSMutableArray *reusableViewControllers;/**< 重用队列*/
@property (strong, nonatomic) NSMutableArray *visibleViewControllers;/**< 当前队列*/
@end

@implementation ViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.topBar];
    [self.view addSubview:self.bottomBar];
    
    [self layoutPageSubviews];
    
    [self setupPages];
    
    self.scrollView.contentOffset = CGPointMake([UIScreen mainScreen].bounds.size.width * (TOTAL_PAGES - 1), 0);
    [self loadPage:TOTAL_PAGES - 1];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - delegates
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
        NSInteger page = roundf(scrollView.contentOffset.x / scrollView.frame.size.width);
        page = MAX(page, 0);
        page = MIN(page, TOTAL_PAGES - 1);
        [self loadPage:page];
    
}
#pragma mark - SDPhotoReuseableViewControllerDelegate
/**
 *  单击隐藏底栏
 */
- (void)singleTap {
    BOOL hiddenStatus = self.topBar.hidden;
    self.topBar.hidden = !hiddenStatus;
    self.bottomBar.hidden = !hiddenStatus;
}
#pragma mark - SDPhotoTopBarDelegate
- (void)selectStatusClick {
    static int i = 0;
    if (i%2==1) {
        [self.bottomBar updateSelectPhotoCount:i];
    }
    else {
        [self.bottomBar updateSelectPhotoCount:0];

    }
    i++;
}
#pragma mark - notifications

#pragma mark - event response

#pragma mark - public methods

#pragma mark - private methods
- (void)layoutPageSubviews {

    
    [self.topBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@64);
    }];
    
    [self.bottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@44);
        make.left.right.bottom.equalTo(self.view);
    }];
}
- (void)setupPages
{
    self.scrollView.contentSize = CGSizeMake(TOTAL_PAGES * [UIScreen mainScreen].bounds.size.width, 0);
}

- (void)setCurrentPage:(NSNumber *)currentPage
{
    if (_currentPage != currentPage) {
        _currentPage = currentPage;
    }
}

- (void)loadPage:(NSInteger)page
{
    if (self.currentPage && page == [self.currentPage integerValue]) {
        return;
    }
    self.currentPage = @(page);
    NSMutableArray *pagesToLoad = [@[@(page), @(page - 1), @(page + 1)] mutableCopy];
    NSMutableArray *vcsToEnqueue = [NSMutableArray array];
    for (SDPhotoReuseableViewController *vc in self.visibleViewControllers) {
        if (!vc.page || ![pagesToLoad containsObject:vc.page]) {
            [vcsToEnqueue addObject:vc];
        } else if (vc.page) {
            [pagesToLoad removeObject:vc.page];
        }
    }
    for (SDPhotoReuseableViewController *vc in vcsToEnqueue) {
        [vc.view removeFromSuperview];
        [self.visibleViewControllers removeObject:vc];
        [self enqueueReusableViewController:vc];
    }
    for (NSNumber *page in pagesToLoad) {
        [self addViewControllerForPage:[page integerValue]];
    }
}

- (void)enqueueReusableViewController:(SDPhotoReuseableViewController *)viewController
{
    [self.reusableViewControllers addObject:viewController];
}

- (SDPhotoReuseableViewController *)dequeueReusableViewController
{
    static int numberOfInstance = 0;
    SDPhotoReuseableViewController *vc = [self.reusableViewControllers firstObject];
    if (vc) {
        [self.reusableViewControllers removeObject:vc];
    } else {
        vc = [[SDPhotoReuseableViewController alloc]init];
        vc.numberOfInstance = numberOfInstance;
        numberOfInstance++;
        vc.delegate = self;
        [vc willMoveToParentViewController:self];
        [self addChildViewController:vc];
        [vc didMoveToParentViewController:self];
    }
    return vc;
}

- (void)addViewControllerForPage:(NSInteger)page
{
    if (page < 0 || page >= TOTAL_PAGES) {
        return;
    }
    SDPhotoReuseableViewController *vc = [self dequeueReusableViewController];
    vc.page = @(page);
    vc.view.frame = CGRectMake(self.scrollView.frame.size.width * page, 0.0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    [self.scrollView addSubview:vc.view];
    [self.visibleViewControllers addObject:vc];
}

#pragma mark - getters and setters

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.backgroundColor = [UIColor blackColor];
        _scrollView.delegate = self;
        _scrollView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    }
    return _scrollView;
}
- (SDPhotoTopBar *)topBar {
    if (!_topBar) {
        _topBar = [[SDPhotoTopBar alloc]init];
        _topBar.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.9];
        _topBar.isSelected = YES;
        _topBar.delegate = self;
    }
    return _topBar;
}
- (SDPhotoBottomBar *)bottomBar {
    if (!_bottomBar) {
        _bottomBar = [[SDPhotoBottomBar alloc]init];
        _bottomBar.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.9];

    }
    return _bottomBar;
}
- (NSMutableArray *)reusableViewControllers
{
    if (!_reusableViewControllers) {
        _reusableViewControllers = [NSMutableArray array];
    }
    return _reusableViewControllers;
}

- (NSMutableArray *)visibleViewControllers
{
    if (!_visibleViewControllers) {
        _visibleViewControllers = [NSMutableArray array];
    }
    return _visibleViewControllers;
}

@end
