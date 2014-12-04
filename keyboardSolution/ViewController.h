//
//  ViewController.h
//  keyboardSolution
//
//  Created by john on 14-12-4.
//  Copyright (c) 2014年 ___coco-sh___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+helper.h"

@interface ViewController : UIViewController<KeyBoardDelegate>
{
    IBOutlet UITextField *_textFiled1, *_textField2, *_textField3, *_textField4, *_textField5, *_textField6;
}

@end

