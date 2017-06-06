//
//  ViewController.m
//  EMPasswordIInputViewDemo
//
//  Created by Eric MiAo on 2017/6/1.
//  Copyright © 2017年 Eric MiAo. All rights reserved.
//

#import "ViewController.h"
#import "EMPasswordInputView/EMPasswordInputView.h"

@interface ViewController ()<EMPasswordInputViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    EMPasswordInputView *empView = [EMPasswordInputView inputViewWithFrame:CGRectMake(10, 100, 250, 30) numberOfCount:5 widthOfLine:35 intervalOfLine:20];
    empView.backgroundColor = [UIColor yellowColor];
    empView.delegate = self;
    empView.contentAttributes = @{NSForegroundColorAttributeName : [UIColor redColor], NSFontAttributeName : [UIFont systemFontOfSize:30]};
    empView.lineHeight = 2;
    empView.wordsLineOffset = 7;
    empView.passwordKeyboardType = UIKeyboardTypeNumberPad;
    empView.passwordType = EMPasswordTypeStar;
//    empView.passwordType = EMPasswordTypeCustom;
//    empView.customPasswordStr = @"a";
    [self.view addSubview:empView];
    NSLog(@"%f  %f",empView.widthOfLine,empView.intervalOfLine);
    
}

- (void)EM_passwordInputView:(EMPasswordInputView *)passwordView finishInput:(NSString *)contentStr {
    NSLog(@"1.%@",contentStr);
}

- (void)EM_passwordInputView:(EMPasswordInputView *)passwordView edittingPassword:(NSString *)contentStr inputStr:(NSString *)inputStr {
    NSLog(@"2.%@,%@",contentStr,inputStr);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    NSLog(@"touch");
}



@end
