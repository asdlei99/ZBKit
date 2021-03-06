//
//  ZBTabBarItem.m
//  ZBKit
//
//  Created by NQ UEC on 2017/4/21.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "ZBTabBarItem.h"
#import "ZBMacros.h"
#import "UIView+ZBKit.h"

#import "ZBDateFormatter.h"
#import "ZBLocalized.h"
#import "UIView+ZBAnimation.h"
#import "YYWeakProxy.h"

#define ZBTabBarItemTag 1999
#define ZBTabBarItemImageHeight 71
#define ZBTabBarItemImageHeight 71
#define ZBTabBarItemTitleHeight 20
#define ZBTabBarItemVerticalPadding 10
#define ZBTabBarItemHorizontalMargin 20
#define ZBTabBarItemRriseAnimationID @"CHTumblrMenuViewRriseAnimationID"
#define ZBTabBarItemDismissAnimationID @"CHTumblrMenuViewDismissAnimationID"
#define ZBTabBarItemAnimationTime 0.36
#define ZBTabBarItemAnimationInterval (ZBTabBarItemAnimationTime / 5)

@interface ZBTabBarItemButton()
- (id)initWithTitle:(NSString*)title andIcon:(UIImage*)icon andSelectedBlock:(ZBTabBarItemSelectedBlock)block;
@property(nonatomic,copy)ZBTabBarItemSelectedBlock selectedBlock;

@end

@implementation ZBTabBarItemButton

- (id)initWithTitle:(NSString*)title andIcon:(UIImage*)icon andSelectedBlock:(ZBTabBarItemSelectedBlock)block
{
    self = [super init];
    if (self) {
        
        
        self.iconView = [UIImageView new];
        self.iconView.image = icon;
        self.titleLabel = [UILabel new];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.text = title;
        self.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        _selectedBlock = block;
        [self addSubview:self.iconView];
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.iconView.frame = CGRectMake(0, 0, ZBTabBarItemImageHeight, ZBTabBarItemImageHeight);
    self.titleLabel.frame = CGRectMake(0, ZBTabBarItemImageHeight, ZBTabBarItemImageHeight, ZBTabBarItemTitleHeight);
}


@end

@interface ZBTabBarItem()<UIGestureRecognizerDelegate,CAAnimationDelegate>

@property (nonatomic, strong) UIImageView  *backgroudView;
@end
@implementation ZBTabBarItem
{
    NSMutableArray *buttons_;
    UIButton *_addBut;
    BOOL _isDrop;
    CGFloat toobarHeight;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    
        if (ZB_DEVICE_IS_iPhoneX) {
            toobarHeight=83;
        }else{
            toobarHeight=49;
        }
        UITapGestureRecognizer *Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Tap:)];
        Tap.delegate = self;
        [self addGestureRecognizer:Tap];
        self.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.98];
        buttons_ = [[NSMutableArray alloc] initWithCapacity:6];

        [self createBackgroundView];
      //  [self advertise];
        [self createTime];
        [self locationAndWeather];
        [self createBottomButton];

    }
    return self;
}
//创建背景视图
- (void)createBackgroundView {
    ZBWeatherView* weatherView = [[ZBWeatherView alloc]initWithFrame:CGRectMake(0, 0, self.zb_width, self.zb_height)];
    [self addSubview:weatherView];
    self.weatherView=weatherView;
}

- (void)createTime{    
    UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(ZB_SCREEN_WIDTH-170, 64,150, 20)];
    timeLabel.text=[[ZBDateFormatter sharedInstance] currentDate];
    timeLabel.font = [UIFont boldSystemFontOfSize:20];
    timeLabel.textAlignment=NSTextAlignmentRight;
    timeLabel.textColor=[UIColor whiteColor];
    [self addSubview: timeLabel];

}
- (void)locationAndWeather{
    /*
    UIButton *locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    locationButton.frame=CGRectMake(SCREEN_WIDTH-144, 90, 44, 44);
    // locationButton.backgroundColor=[UIColor yellowColor];
    locationButton.imageEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8);
    [locationButton setImage:[UIImage imageNamed:@"location_hardware"] forState:UIControlStateNormal];
    [self addSubview:locationButton];
    self.locationButton=locationButton;
    */
    UIImageView *locationImage=[[UIImageView alloc]initWithFrame:CGRectMake(ZB_SCREEN_WIDTH-134, 100, 24, 24)];
    locationImage.image=[UIImage imageNamed:@"location_hardware"] ;
    [self addSubview:locationImage];
    
    [self addSubview:self.cityBtn];
 
    [self addSubview:self.weatherLabel];

}
- (UIButton *)cityBtn{
    if (!_cityBtn) {
        _cityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cityBtn.frame=CGRectMake(ZB_SCREEN_WIDTH-100, 90, 80, 44);
        //  cityButton.backgroundColor=[UIColor redColor];
        [_cityBtn setTitle:ZBLocalized(@"itemcity",nil) forState:UIControlStateNormal];
        _cityBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        //cityButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        _cityBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _cityBtn;
}
- (UILabel *)weatherLabel{
    if (!_weatherLabel) {
        _weatherLabel=[[UILabel alloc]initWithFrame:CGRectMake(ZB_SCREEN_WIDTH-140, 134,120, 20)];
        _weatherLabel.textColor=[UIColor whiteColor];
        _weatherLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _weatherLabel;
}
- (void)createBottomButton{
    UIView *addView=[[UIView alloc]init];
    [addView setFrame:CGRectMake(0, ZB_SCREEN_HEIGHT - toobarHeight, ZB_SCREEN_WIDTH, toobarHeight)];
    addView.backgroundColor=[UIColor clearColor];
    [self addSubview:addView];
    
    UITapGestureRecognizer *addViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addViewTap:)];
    addViewTap.delegate = self;
    [addView addGestureRecognizer:addViewTap];
    
    _addBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addBut setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_background_icon_add.png"] forState:UIControlStateNormal];
    _addBut.bounds = (CGRect){CGPointZero, [_addBut backgroundImageForState:UIControlStateNormal].size};
    [_addBut addTarget:self action:@selector(addButClick:) forControlEvents:UIControlEventTouchUpInside];
    _addBut.translatesAutoresizingMaskIntoConstraints = NO;
    [addView addSubview:_addBut];
    NSLayoutConstraint *XConstraint = [NSLayoutConstraint constraintWithItem:_addBut attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:addView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0];
    //Y
    NSLayoutConstraint *YConstraint = [NSLayoutConstraint constraintWithItem:_addBut attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:addView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0];
    [addView  addConstraint:XConstraint];
    [addView  addConstraint:YConstraint];

}

- (void)addItemWithTitle:(NSString*)title andIcon:(UIImage*)icon andSelectedBlock:(ZBTabBarItemSelectedBlock)block{
    ZBTabBarItemButton *button = [[ZBTabBarItemButton alloc] initWithTitle:title andIcon:icon andSelectedBlock:block];
    
    [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    self.tabBarItemButton=button;
    [buttons_ addObject:button];
}

- (void)addViewTap:(id)sender{
    [self dismiss];
}

- (void)addButClick:(UIButton *)sender{
    [self dismiss];
}

- (void)dismiss{
    
    if (_isDrop==NO) {
        [self dropAnimation];
    }
    double delayInSeconds = ZBTabBarItemAnimationInterval * buttons_.count-1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [UIView animateWithDuration:0.5f animations:^{
            self.alpha = 0.f;
        } completion:^(BOOL finished) {
            [_addBut.layer removeAnimationForKey:@"transform"];

            [self.weatherView removeAnimationView];
            [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self removeFromSuperview];
        }];
    });
}

- (void)Tap:(id)sender{
    if (_isDrop==NO) {
        [self dropAnimation];
    }else{
        [self riseAnimation];
    }
}

- (void)buttonTapped:(ZBTabBarItemButton*)sender{
    [self dismiss];
    double delayInSeconds =ZBTabBarItemAnimationInterval * buttons_.count;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        sender.selectedBlock();
    });
}

- (void)riseAnimation{
    _isDrop=NO;
    NSUInteger columnCount = 3;
    NSUInteger rowCount = buttons_.count / columnCount + (buttons_.count%columnCount>0?1:0);
    
    [buttons_ enumerateObjectsUsingBlock:^(NSString *urlString, NSUInteger idx, BOOL *stop) {
        ZBTabBarItemButton *button = buttons_[idx];
        button.layer.opacity = 0;
        CGRect frame = [self frameForButtonAtIndex:idx];
        NSUInteger rowIndex = idx / columnCount;
        NSUInteger columnIndex = idx % columnCount;
        CGPoint fromPosition = CGPointMake(frame.origin.x + ZBTabBarItemImageHeight / 2.0,frame.origin.y +  (rowCount - rowIndex + 2)*200 + (ZBTabBarItemImageHeight + ZBTabBarItemTitleHeight) / 2.0);
        
        CGPoint toPosition = CGPointMake(frame.origin.x + ZBTabBarItemImageHeight / 2.0,frame.origin.y + (ZBTabBarItemImageHeight + ZBTabBarItemTitleHeight) / 2.0);
        
        double delayInSeconds = rowIndex * columnCount * ZBTabBarItemAnimationInterval;
        
        if (columnIndex == 1) {
            delayInSeconds += ZBTabBarItemAnimationInterval * 0.3;
        }
        else if(columnIndex == 2) {
            delayInSeconds += ZBTabBarItemAnimationInterval * 0.6;
        }
        
        CABasicAnimation *positionAnimation;
        positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        positionAnimation.fromValue = [NSValue valueWithCGPoint:fromPosition];
        positionAnimation.toValue = [NSValue valueWithCGPoint:toPosition];
        positionAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.45f :1.2f :0.75f :1.0f];
        positionAnimation.duration = ZBTabBarItemAnimationTime;
        positionAnimation.beginTime = [button.layer convertTime:CACurrentMediaTime() fromLayer:nil] + delayInSeconds;
        [positionAnimation setValue:[NSNumber numberWithUnsignedInteger:idx] forKey:ZBTabBarItemRriseAnimationID];
        positionAnimation.delegate = [YYWeakProxy proxyWithTarget:self];;
        [button.layer addAnimation:positionAnimation forKey:@"riseAnimation"];
        
        CABasicAnimation* anim = [CABasicAnimation animationWithKeyPath:@"transform"];
        CATransform3D fromValue = _addBut.layer.transform;
        // 设置动画开始的属性值
        anim.fromValue = [NSValue valueWithCATransform3D:fromValue];
        // 绕Z轴旋转180度
        CATransform3D toValue = CATransform3DRotate(fromValue, M_PI_4 / 6, 0 , 0 , 1);
        // 设置动画结束的属性值
        anim.toValue = [NSValue valueWithCATransform3D:toValue];
        anim.duration = 0.2;
        anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        _addBut.layer.transform = toValue;
        anim.removedOnCompletion = YES;
        [_addBut.layer addAnimation:anim forKey:nil];

    }];
}

- (void)dropAnimation{
    _isDrop=YES;
    NSUInteger columnCount = 3;
    NSUInteger rowCount = buttons_.count / columnCount + (buttons_.count%columnCount>0?1:0);
    
    [buttons_ enumerateObjectsUsingBlock:^(NSString *urlString, NSUInteger idx, BOOL *stop) {
        ZBTabBarItemButton *button = buttons_[idx];
        CGRect frame = [self frameForButtonAtIndex:idx];
        NSUInteger rowIndex = (buttons_.count - 1 - idx) / columnCount;
        NSUInteger columnIndex = idx % columnCount;
        
        CGPoint toPosition = CGPointMake(frame.origin.x + ZBTabBarItemImageHeight / 2.0,frame.origin.y +  (rowCount - rowIndex + 2)*200 + (ZBTabBarItemImageHeight + ZBTabBarItemTitleHeight) / 2.0);
        
        CGPoint fromPosition = CGPointMake(frame.origin.x + ZBTabBarItemImageHeight / 2.0,frame.origin.y + (ZBTabBarItemImageHeight + ZBTabBarItemTitleHeight) / 2.0);
        
        double delayInSeconds = rowIndex * columnCount * ZBTabBarItemAnimationInterval;
        if (columnIndex == 1) {
            delayInSeconds += ZBTabBarItemAnimationInterval*0.3;
        }
        else if(columnIndex == 0) {
            delayInSeconds += ZBTabBarItemAnimationInterval * 0.6;
        }
        
        CABasicAnimation *positionAnimation;
        
        positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        positionAnimation.fromValue = [NSValue valueWithCGPoint:fromPosition];
        positionAnimation.toValue = [NSValue valueWithCGPoint:toPosition];
        positionAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.3 :0.5f :1.0f :1.0f];
        positionAnimation.duration = ZBTabBarItemAnimationTime;
        positionAnimation.beginTime = [button.layer convertTime:CACurrentMediaTime() fromLayer:nil] + delayInSeconds;
        [positionAnimation setValue:[NSNumber numberWithUnsignedInteger:idx] forKey:ZBTabBarItemDismissAnimationID];
        positionAnimation.delegate =  [YYWeakProxy proxyWithTarget:self];;
        
        [button.layer addAnimation:positionAnimation forKey:@"riseAnimation"];
        
        
        CABasicAnimation* anim = [CABasicAnimation animationWithKeyPath:@"transform"];
        CATransform3D fromValue = _addBut.layer.transform;
        // 设置动画开始的属性值
        anim.fromValue = [NSValue valueWithCATransform3D:fromValue];
        // 绕Z轴旋转180度
        CATransform3D toValue = CATransform3DRotate(fromValue, - M_PI_4 / 6, 0 , 0 , 1);
        // 设置动画结束的属性值
        anim.toValue = [NSValue valueWithCATransform3D:toValue];
        anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        anim.duration = 0.2;
        _addBut.layer.transform = toValue;
        anim.removedOnCompletion = YES;
        [_addBut.layer addAnimation:anim forKey:nil];
    }];
  
}

- (void)animationDidStart:(CAAnimation *)anim{
    NSUInteger columnCount = 3;
    if([anim valueForKey:ZBTabBarItemRriseAnimationID]) {
        NSUInteger index = [[anim valueForKey:ZBTabBarItemRriseAnimationID] unsignedIntegerValue];
        UIView *view = buttons_[index];
        CGRect frame = [self frameForButtonAtIndex:index];
        CGPoint toPosition = CGPointMake(frame.origin.x + ZBTabBarItemImageHeight / 2.0,frame.origin.y + (ZBTabBarItemImageHeight + ZBTabBarItemTitleHeight) / 2.0);
        CGFloat toAlpha = 1.0;
        
        view.layer.position = toPosition;
        view.layer.opacity = toAlpha;
        
        //        [_addBut setImage:[UIImage imageNamed:@"tabbar_compose_background_icon_close@2x.png"] forState:UIControlStateNormal];
    }
    else if([anim valueForKey:ZBTabBarItemDismissAnimationID]) {
        NSUInteger index = [[anim valueForKey:ZBTabBarItemDismissAnimationID] unsignedIntegerValue];
        NSUInteger rowIndex = index / columnCount;
        
        UIView *view = buttons_[index];
        CGRect frame = [self frameForButtonAtIndex:index];
        CGPoint toPosition = CGPointMake(frame.origin.x + ZBTabBarItemImageHeight / 2.0,frame.origin.y -  (rowIndex + 2)*200 + (ZBTabBarItemImageHeight + ZBTabBarItemTitleHeight) / 2.0);
        
        view.layer.position = toPosition;
    }
}


- (CGRect)frameForButtonAtIndex:(NSUInteger)index{
    NSUInteger columnCount = 3;
    NSUInteger columnIndex =  index % columnCount;
    
    NSUInteger rowCount = buttons_.count / columnCount + (buttons_.count%columnCount>0?1:0);
    NSUInteger rowIndex = index / columnCount;
    
    CGFloat itemHeight = (ZBTabBarItemImageHeight + ZBTabBarItemTitleHeight) * rowCount + (rowCount > 1?(rowCount - 1) * ZBTabBarItemHorizontalMargin:0);
    CGFloat offsetY = (self.bounds.size.height - itemHeight) / 2.0;
    CGFloat verticalPadding = (self.bounds.size.width - ZBTabBarItemHorizontalMargin * 2 - ZBTabBarItemImageHeight * 3) / 2.0;
    
    CGFloat offsetX = ZBTabBarItemHorizontalMargin;
    offsetX += (ZBTabBarItemImageHeight+ verticalPadding) * columnIndex;
    
    offsetY += (ZBTabBarItemImageHeight + ZBTabBarItemTitleHeight + ZBTabBarItemVerticalPadding) * rowIndex;
    
    return CGRectMake(offsetX, offsetY, ZBTabBarItemImageHeight, (ZBTabBarItemImageHeight+ZBTabBarItemTitleHeight));
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    for (NSUInteger i = 0; i < buttons_.count; i++) {
        ZBTabBarItemButton *button = buttons_[i];
        button.frame = [self frameForButtonAtIndex:i];
    }
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if([touch.view isKindOfClass:[ZBTabBarItemButton class]])
    {
        return NO;
    }
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer.view isKindOfClass:[ZBTabBarItemButton class]]) {
        return NO;
    }
    
    CGPoint location = [gestureRecognizer locationInView:self];
    for (UIView* subview in buttons_) {
        if (CGRectContainsPoint(subview.frame, location)) {
            return NO;
        }
    }
    return YES;
}

- (void)show{
   
    UIViewController *appRootViewController;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    appRootViewController = window.rootViewController;
    UIViewController *topViewController = appRootViewController;
    while (topViewController.presentedViewController != nil)
    {
        topViewController = topViewController.presentedViewController;
    }
    if ([topViewController.view viewWithTag:ZBTabBarItemTag]) {
        [[topViewController.view viewWithTag:ZBTabBarItemTag] removeFromSuperview];
    }
    self.frame = topViewController.view.bounds;
    [topViewController.view addSubview:self];
    [self riseAnimation];
}
/*
- (void)advertise{
    __weak typeof(self) weakSelf = self;
    [ZBAdvertiseInfo getAdvertisingInfo:^(NSString *imagePath,NSDictionary *urlDict,BOOL isExist){
        if (isExist) {
            ZBAdvertiseView *advertiseView= [[ZBAdvertiseView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 64, SCREEN_WIDTH/2-20, 100) type:ZBAdvertiseTypeView];
            
            advertiseView.filePath = imagePath;
            advertiseView.ZBAdvertiseBlock=^{
                if ([[urlDict objectForKey:@"link"]isEqualToString:@""]) {
                    return;
                }else{
                    ///有url跳转 要在tabbarController 里 presentViewController
                    [weakSelf dismiss:nil];//跳转时 移除view
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbarPushToAd" object:nil userInfo:urlDict];
                }
            };
            [self addSubview:advertiseView];
            self.advertiseView=advertiseView;
            //展示广告
        }else{
            //无广告"
        }
    }];
}
*/
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
