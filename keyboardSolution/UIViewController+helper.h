//
//  UIViewController+helper.h
//  keyboardSolution
//
//  Created by john on 14-12-4.
//  Copyright (c) 2014年 ___coco-sh___. All rights reserved.
//

#import <UIKit/UIKit.h>

/** @usage: 必须调用键盘注册。在dealloc中取消注册。
 无需实现协议声明属性，该属性将在运行时自动实现。
 协议方法为可选方法，具有默认行为。你可以在实现类中重写改方法
 */
@protocol KeyBoardDelegate <NSObject>

@optional
/** 记录键盘出现时动画view的原始位置， 键盘消失后还原位置*/
@property (nonatomic, strong) NSNumber *originY_KB;
/** 执行动画的view */
@property (nonatomic, weak) UIView *actView_KB;
/** 将会调用键盘的所有view */
@property (nonatomic, strong) NSArray *editViews_KB;

- (void)keyBoardShow:(CGFloat)keyboardHeight interval:(CGFloat)duration;
- (void)keyBoardHide:(CGFloat)duration;

@end



@interface UIViewController (helper)<KeyBoardDelegate, UIGestureRecognizerDelegate>

/** 注册键盘出现事件监听
 @param actView 键盘出现时，产生相应动画的view。传入nil时默认为self.view
 @param editViews 会调用键盘的所有控件数组。不可为nil。若某个控件调用键盘未被加入，产生异常
 */
- (void)registerKeyboardNotifications:(UIView *)actView EditViews:(NSArray *)editViews;

/** 取消注册
 @warning 请务必记得调用。用于取消监听，清理动态创建的相关属性
 */
- (void)resignKeyboardNotifications;

@end
