//
//  UIView+Toast.h
//  ZBKit
//
//  Created by NQ UEC on 2018/5/24.
//  Copyright © 2018年 Suzhibin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZBToastView;
@interface UIView (Toast)
+ (void)makeText:(void (^)(ZBToastView *make))block;
@end
