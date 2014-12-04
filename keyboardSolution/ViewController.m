//
//  ViewController.m
//  keyboardSolution
//
//  Created by john on 14-12-4.
//  Copyright (c) 2014年 ___coco-sh___. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self registerKeyboardNotifications:self.view EditViews:@[_textFiled1, _textField2, _textField3, _textField4, _textField5, _textField6]];
}

- (void)dealloc
{
    [self resignKeyboardNotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
