//
//  ViewController.m
//  OPassbookSimpleAnimation
//
//  Created by WangZhipeng on 15/12/4.
//  Copyright © 2015年 WangZhipeng. All rights reserved.
//

#import "ViewController.h"
// Pods
#import "Masonry.h"

#define kMaxHeight      [UIScreen mainScreen].bounds.size.height
#define kViewHeight     60

@interface ViewController ()

@property (nonatomic, strong) UIView *view1;
@property (nonatomic, strong) UIView *view2;
@property (nonatomic, strong) UIView *view3;
@property (nonatomic, strong) UIView *view4;
@property (nonatomic, strong) UIView *view5;

@property (nonatomic, strong) NSMutableArray *imageViewList;
@property (nonatomic, strong) NSArray *animationConstraints;

@property (nonatomic, assign) BOOL willAnimate;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _view5 = [UIView new];
    _view4 = [UIView new];
    _view3 = [UIView new];
    _view2 = [UIView new];
    _view1 = [UIView new];
    
    _imageViewList = [NSMutableArray arrayWithCapacity:5];
    [_imageViewList addObject:_view1];
    [_imageViewList addObject:_view2];
    [_imageViewList addObject:_view3];
    [_imageViewList addObject:_view4];
    [_imageViewList addObject:_view5];
    
    for (int i = 0; i < _imageViewList.count; i++) {
        UIView *viewTemp = _imageViewList[i];
        viewTemp.tag = i;
        viewTemp.backgroundColor = [UIColor colorWithRed:233 / 255.0
                                                   green:(35 + 30 * i) / 255.0
                                                    blue:29 / 255.0
                                                   alpha:1];
        [self.view addSubview:viewTemp];
        [viewTemp mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.view);
            make.height.equalTo(@(kViewHeight));
            make.centerX.equalTo(self.view);
            make.bottom.equalTo(i == 0 ? self.view : ((UIView *)_imageViewList[i - 1]).mas_top);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(Tap:)];
        [_imageViewList[i] addGestureRecognizer:tap];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(Pan:)];
        [_imageViewList[i] addGestureRecognizer:pan];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITapGestureRecognizer Action
-(void)Tap:(UITapGestureRecognizer *)gesture {
    NSInteger animationIndex = [gesture view].tag;
    [self animate:animationIndex];
}

#pragma mark - UIPanGestureRecognizer Action
-(void)Pan:(UIPanGestureRecognizer *)gesture{
    
    NSInteger animationIndex = [gesture view].tag;
    // 距离手指刚按下去时的那个起始点的偏移量
    CGPoint point = [gesture translationInView:[gesture view]];
    
    //向上拖动
    if(point.y < 0){
        
        UIView *viewTemp = _imageViewList[animationIndex];
        [viewTemp mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(kViewHeight - point.y));
        }];
        
    }
    
    //向下拖动
    if ( point.y > 0 ) {
        
        UIView *viewTemp = _imageViewList[animationIndex];
        [viewTemp mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(kMaxHeight - point.y));
        }];
        
    }
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        
        if (point.y <= -40) {
            [self animate:animationIndex];
        }
        
        if (point.y >= 40) {
            [self animate:animationIndex];
        }
        
    }
    
}

#pragma mark - Private
- (void)animate:(NSInteger)animationIndex{
    
    if (!_willAnimate) {
        
        _willAnimate = YES;
        
        if (animationIndex != 0) {
            UIView *viewTemp = [_imageViewList firstObject];
            [viewTemp mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.view).offset(kViewHeight * animationIndex);
            }];
        }
        
        UIView *viewTemp = _imageViewList[animationIndex];
        [viewTemp mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(kMaxHeight));
        }];
        
        [UIView animateWithDuration:0.3f animations:^{
            [self.view layoutIfNeeded];
        }];
        
    }
    else {
        
        if (animationIndex != 0) {
            UIView *viewTemp = [_imageViewList firstObject];
            [viewTemp mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.view);
            }];
        }
        
        UIView *viewTemp = _imageViewList[animationIndex];
        [viewTemp mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(kViewHeight));
        }];
        
        [UIView animateWithDuration:0.3f animations:^{
            [self.view layoutIfNeeded];
        }];
        
        _willAnimate = NO;
    }
    
}

@end
