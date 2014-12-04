//
//  UIViewController+helper.m
//  keyboardSolution
//
//  Created by john on 14-12-4.
//  Copyright (c) 2014年 ___coco-sh___. All rights reserved.
//

#import "UIViewController+helper.h"
#import <objc/objc.h>
#import <objc/runtime.h>


@implementation UIViewController (helper)

char* const ASSOCIATION_originY_KB = "ASSOCIATION_originY_KB";
char* const ASSOCIATION_actView_KB = "ASSOCIATION_actView_KB";
char* const ASSOCIATION_editViews_KB = "ASSOCIATION_editViews_KB";

- (void)setOriginY_KB:(NSNumber *)originY_KB
{
    [self willChangeValueForKey:[NSString stringWithCString:ASSOCIATION_originY_KB encoding:NSUTF8StringEncoding]];
    objc_setAssociatedObject(self, ASSOCIATION_originY_KB, originY_KB, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:[NSString stringWithCString:ASSOCIATION_originY_KB encoding:NSUTF8StringEncoding]];
}

- (NSNumber *)originY_KB
{
    return objc_getAssociatedObject(self, ASSOCIATION_originY_KB);
}

- (void)setActView_KB:(UIView *)actView_KB
{
    [self willChangeValueForKey:[NSString stringWithCString:ASSOCIATION_actView_KB encoding:NSUTF8StringEncoding]];
    objc_setAssociatedObject(self, ASSOCIATION_actView_KB, actView_KB, OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:[NSString stringWithCString:ASSOCIATION_actView_KB encoding:NSUTF8StringEncoding]];
}

- (UIView *)actView_KB
{
    return objc_getAssociatedObject(self, ASSOCIATION_actView_KB);
}

- (void)setEditViews_KB:(NSArray *)editViews_KB
{
    [self willChangeValueForKey:[NSString stringWithCString:ASSOCIATION_editViews_KB encoding:NSUTF8StringEncoding]];
    objc_setAssociatedObject(self, ASSOCIATION_editViews_KB, editViews_KB, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:[NSString stringWithCString:ASSOCIATION_editViews_KB encoding:NSUTF8StringEncoding]];
}

- (NSArray *)editViews_KB
{
    return objc_getAssociatedObject(self, ASSOCIATION_editViews_KB);
}

- (void)tapBackground_KB:(UIGestureRecognizer *)gesture
{
    [self.view endEditing:YES];
}

- (void)keyBoardShow:(CGFloat)keyboardHeight interval:(CGFloat)duration
{
    UIView *editView = nil;
    for (UIView *view in self.editViews_KB) {
        if (view.isFirstResponder) {
            editView = view;
            break;
        }
    }
    if (!editView) {
        //存在多个监听者时，没找到好办法区分不同监听者，简单返回算了
#warning todo 多个监听者时的bug。控制器A监听键盘事件，从控制器A push 控制器B，B也监听事件，这时，这个代理方法会走两次。如果抛出异常，那是必然异常的，因为A没有firstResponder。没有找到良好解决方案
        return;
        //        [NSException raise:@"keyboard delegate" format:@"editViews_KB argument error in '%@'", NSStringFromClass(self.class)];
    }
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGRect dstFrame = [editView convertRect:editView.bounds toView:window];
    CGFloat deltaY = window.frame.size.height - keyboardHeight - CGRectGetMaxY(dstFrame);
    if (deltaY < 0) {
        self.originY_KB = [NSNumber numberWithFloat:CGRectGetMinY(self.actView_KB.frame)];
        [UIView animateWithDuration:duration animations:^{
            CGRect frame = self.actView_KB.frame;
            frame.origin.y += deltaY;
            self.actView_KB.frame = frame;
        }completion:nil];
    }
}

- (void)keyBoardHide:(CGFloat)duration
{
    if (self.originY_KB) {
        [UIView animateWithDuration:duration animations:^{
            CGRect frame = self.actView_KB.frame;
            frame.origin.y = self.originY_KB.floatValue;
            self.actView_KB.frame = frame;
        }completion:^(BOOL finished) {
            self.originY_KB = nil;
        }];
    }
}

/** 注册键盘出现和消失事件 */
- (void)registerKeyboardNotifications:(UIView *)actView EditViews:(NSArray *)editViews;
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    /** 当你实现多个手势时，可能存在手势冲突，此时你需要实现相关手势代理方法。
        你可能会想重写 tapBackground_KB 方法。
     */
    UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackground_KB:)];
    gesture.delegate = self;
    [self.view addGestureRecognizer:gesture];
    self.view.userInteractionEnabled = YES;
    
    if (actView) {
        self.actView_KB = actView;
    } else {
        self.actView_KB = self.view;
    }
    if (editViews) {
        self.editViews_KB = editViews;
    }
}

- (void)resignKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    self.actView_KB = nil;
    self.originY_KB = nil;
    self.editViews_KB = nil;
}

- (void)keyboardWillShown:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyboardHeight = [value CGRectValue].size.height;
    NSNumber *seconds = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    [self keyBoardShow:keyboardHeight interval:[seconds floatValue]];
}

- (void)keyboardWillBeHidden:(NSNotification*)notification
{
    NSNumber *seconds = [[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    [self keyBoardHide:[seconds floatValue]];
}

@end
