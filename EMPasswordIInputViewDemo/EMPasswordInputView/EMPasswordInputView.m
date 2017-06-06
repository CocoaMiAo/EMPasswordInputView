//
//  EMPasswordInputView.m
//  EMPasswordIInputViewDemo
//
//  Created by Eric MiAo on 2017/6/1.
//  Copyright © 2017年 Eric MiAo. All rights reserved.
//

#import "EMPasswordInputView.h"

#define PERFECT_LINE_WIDTH 17.0f
#define PERFECT_LINE_INTERVAL 7.0f

@interface EMPasswordInputView()<UITextFieldDelegate> {

    NSUInteger _numberOfCount;
    
    UIColor *_normalLineColor;
    UIColor *_highLightLineColor;
    
    NSMutableArray *_lineArrayM;
    
    NSString *_contentStr;
    
    UITextField *_mainTextField;
    
    NSMutableArray *_textFieldArrM;
    

}
@property (nonatomic, copy) NSDictionary *defaultTextFiledAttributes;
@end
@implementation EMPasswordInputView

+ (instancetype)inputViewWithFrame:(CGRect)frame numberOfCount:(NSUInteger)count widthOfLine:(CGFloat)width intervalOfLine:(CGFloat)interval {
    return [[self alloc] initWithFrame:frame numberOfCount:count widthOfLine:width intervalOfLine:interval];
}

- (instancetype)initWithFrame:(CGRect)frame numberOfCount:(NSUInteger)count widthOfLine:(CGFloat)width intervalOfLine:(CGFloat)interval {
    if (self = [super init]) {
        if (count < 1) {
            
        } else {
            if (frame.size.width < (count * PERFECT_LINE_WIDTH + (count - 1) * PERFECT_LINE_INTERVAL)) {
                NSAssert((count * PERFECT_LINE_WIDTH + (count - 1) * PERFECT_LINE_INTERVAL) <= [[UIScreen mainScreen] bounds].size.width, @"***** EMPasswordInputViewError ***** : 我们已经帮你把横线的宽度和间距调整至最小，但你的屏幕宽度显示不下这么多横线了，减少横线数量试试");
                NSLog(@"***** EMPasswordInputError ***** 设置的宽度已小于最小值，已自动调整合适布局");
                self.frame = CGRectMake(frame.origin.x, frame.origin.y, (count * PERFECT_LINE_WIDTH + (count - 1) * PERFECT_LINE_INTERVAL), frame.size.height);
            } else {
                self.frame = frame;
            }
            self.userInteractionEnabled = YES;
            UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] init];
            [ges addTarget:self action:@selector(inputViewClicked)];
            [self addGestureRecognizer:ges];
            _widthOfLine = width;
            _intervalOfLine = interval;
            _numberOfCount = count;
            _normalLineColor = [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1.0];
            _highLightLineColor = [UIColor colorWithRed:61/255.0 green:216/255.0 blue:76/255.0 alpha:1.0];
            _lineArrayM = [[NSMutableArray alloc] init];
            _textFieldArrM = [[NSMutableArray alloc] init];
            _lineHeight = 1;
            [self initialUI];
        }
    }
    return self;
}

- (void)initialUI {
    [self layoutIfNeeded];
    [self checkFrameSettings];
    CGFloat startX = (self.frame.size.width - (_widthOfLine * _numberOfCount + _intervalOfLine * (_numberOfCount - 1))) / 2;
    if (_lineArrayM.count == 0) {
        for (int i = 0; i < _numberOfCount; i ++) {
            UIView *lineView = [[UIView alloc] init];
            lineView.frame = CGRectMake(startX + i * (_widthOfLine + _intervalOfLine), self.frame.size.height - _lineHeight, _widthOfLine, _lineHeight);
            [self addSubview:lineView];
            [_lineArrayM addObject:lineView];
            
            UITextField *tf = [[UITextField alloc] init];
            tf.frame = CGRectMake(0,  - (self.frame.size.height - lineView.frame.size.height), lineView.frame.size.width, self.frame.size.height - lineView.frame.size.height);
            tf.defaultTextAttributes = [self.defaultTextFiledAttributes copy];
            tf.textAlignment = NSTextAlignmentCenter;
            tf.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            tf.userInteractionEnabled = NO;
            tf.enabled = NO;
            tf.clipsToBounds = YES;
            [lineView addSubview:tf];
            [_textFieldArrM addObject:tf];
        }
        _mainTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _mainTextField.hidden = YES;
        _mainTextField.delegate = self;
        _mainTextField.keyboardType = UIKeyboardTypeDefault;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(inputViewStrChanged:) name:UITextFieldTextDidChangeNotification object:_mainTextField];
        [self addSubview:_mainTextField];
        [_mainTextField becomeFirstResponder];

        [self inputViewColorWithNormalColor:_normalLineColor highLightColor:_highLightLineColor];
    }
}



- (void)checkFrameSettings {
    CGFloat totalLength = _numberOfCount * _widthOfLine + (_numberOfCount - 1) * _intervalOfLine;
    if (totalLength > self.frame.size.width) {
        NSLog(@"***** EMPasswordInputError ***** 已自动调整至合适布局");
        if (((_numberOfCount - 1) * _intervalOfLine + _widthOfLine * _numberOfCount) > self.frame.size.width) {
            /** 使用用户设置间距并且使用最小线长度仍大于总宽度*/
            _widthOfLine = (self.frame.size.width - ((_numberOfCount - 1) * _intervalOfLine)) / _numberOfCount;
            if (_widthOfLine < PERFECT_LINE_WIDTH) {
                /** 自动调整宽度已小于最小宽度*/
                _widthOfLine = PERFECT_LINE_WIDTH;
                _intervalOfLine = (self.frame.size.width - _numberOfCount * _widthOfLine) / (_numberOfCount - 1);
                if (_intervalOfLine < PERFECT_LINE_INTERVAL) {
                    _intervalOfLine = PERFECT_LINE_INTERVAL;
                    CGRect rect = self.frame;
                    rect.size.width = PERFECT_LINE_INTERVAL * (_numberOfCount - 1) + PERFECT_LINE_WIDTH * _numberOfCount;
                    self.frame = rect;
                }
            }
        }
    }
}

- (void)setHighLightColor:(UIColor *)highLightColor {
    _highLightLineColor = highLightColor;
    [self inputViewColorWithNormalColor:_normalLineColor highLightColor:_highLightLineColor];
}

- (void)setNormalColor:(UIColor *)normalColor {
    _normalLineColor = normalColor;
    [self inputViewColorWithNormalColor:_normalLineColor highLightColor:_highLightLineColor];
}

- (void)inputViewColorWithNormalColor:(UIColor *)normalColor highLightColor:(UIColor *)highLightColor {
    for (int i = 0; i < _lineArrayM.count; i ++) {
        UIView *view = [_lineArrayM objectAtIndex:i];
        if (_contentStr.length <= i) {
            view.backgroundColor = normalColor;
        } else {
            view.backgroundColor = highLightColor;
        }
    }
}

- (void)inputViewClicked {
    if (!_mainTextField.isFirstResponder) {
        [_mainTextField becomeFirstResponder];
    }
}

- (void)inputViewStrChanged :(NSNotification *)noti {
    _mainTextField = noti.object;
    NSString *str = _mainTextField.text;
    if (str.length > _numberOfCount) {
        _mainTextField.text = [str substringToIndex:_numberOfCount];
    }
    for (int i = 0; i < _numberOfCount; i ++) {
        UITextField *tf = [_textFieldArrM objectAtIndex:i];
        
        if (i < _mainTextField.text.length) {
            if (_passwordType == EMPasswordTypeX) {
                tf.text = @"X";
            } else if (_passwordType == EMPasswordTypeDots) {
                tf.text = @"·";
            } else if (_passwordType == EMPasswordTypeStar) {
                tf.text = @"*";
            }else if (_passwordType == EMPasswordTypeCircle) {
                tf.text = @"○";
            } else if (_passwordType == EMPasswordTypeCustom) {
                tf.text = _customPasswordStr.length > 0?_customPasswordStr:@"C";
            } else if (_passwordType == EMPasswordTypeDefault) {
                tf.text = [_mainTextField.text substringWithRange:NSMakeRange(i, 1)];
            } else {
                tf.text = [_mainTextField.text substringWithRange:NSMakeRange(i, 1)];
            }
            
        } else {
            tf.text = @"";
        }
    }
    _contentStr = _mainTextField.text;
    if (_contentStr.length >= _numberOfCount) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(EM_passwordInputView:finishInput:)]) {
            [self.delegate EM_passwordInputView:self finishInput:_contentStr];
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(EM_passwordInputView:edittingPassword:inputStr:)]) {
        [self.delegate EM_passwordInputView:self edittingPassword:_contentStr inputStr:_contentStr.length>0?[_contentStr substringFromIndex:_contentStr.length - 1]:@""];
    }
    [self inputViewColorWithNormalColor:_normalLineColor highLightColor:_highLightLineColor];
}

- (void)setContentAttributes:(NSDictionary *)contentAttributes {
    NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithDictionary:self.defaultTextFiledAttributes];
    if (!contentAttributes) {
        contentAttributes = [self.defaultTextFiledAttributes copy];
    } else {
        
        [dictM addEntriesFromDictionary:[contentAttributes copy]];
        contentAttributes = [dictM copy];
    }
    _contentAttributes = contentAttributes;
    for (int i = 0; i < _textFieldArrM.count; i ++) {
        UITextField *tf = [_textFieldArrM objectAtIndex:i];
        
        tf.defaultTextAttributes = contentAttributes;
    }
}

- (NSDictionary *)defaultTextFiledAttributes {
    if (!_defaultTextFiledAttributes) {
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineBreakMode = NSLineBreakByTruncatingTail;
        style.alignment = NSTextAlignmentCenter;

        _defaultTextFiledAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:9.0f], NSParagraphStyleAttributeName : style};
    }
    return _defaultTextFiledAttributes;
}

- (void)setContentColor:(UIColor *)contentColor {
    _contentColor = contentColor;
    for (int i = 0; i < _textFieldArrM.count; i ++) {
        UITextField *tf = [_textFieldArrM objectAtIndex:i];
        tf.textColor = contentColor;
    }
}

- (void)setContentFontSize:(CGFloat)contentFontSize {
    _contentFontSize = contentFontSize;
    for (int i = 0; i < _textFieldArrM.count; i ++) {
        UITextField *tf = [_textFieldArrM objectAtIndex:i];
        tf.font = [UIFont systemFontOfSize:contentFontSize];
    }
}

- (void)setLineHeight:(CGFloat)lineHeight {
    _lineHeight = lineHeight;
    if (_lineHeight>= self.frame.size.height) {
        NSLog(@"***** EMPasswordInputError ***** 横线高度超过控件自身高度，已自动调整至最大高度");
        _lineHeight = self.frame.size.height - 1;
    }
    for (int i = 0; i < _numberOfCount; i ++) {
        UIView *lineView = [_lineArrayM objectAtIndex:i];
        CGRect lineRect = lineView.frame;
        lineRect.origin.y = self.frame.size.height - _lineHeight;
        lineRect.size.height = _lineHeight;
        lineView.frame = lineRect;
        
        UITextField *tf = [_textFieldArrM objectAtIndex:i];
        tf.frame = CGRectMake(0,  - (self.frame.size.height - lineView.frame.size.height), lineView.frame.size.width, self.frame.size.height - lineView.frame.size.height);
    }
}

- (void)setWordsLineOffset:(CGFloat)wordsLineOffset {
    _wordsLineOffset = wordsLineOffset;
    for (int i = 0; i < _numberOfCount; i ++) {
        UITextField *tf = [_textFieldArrM objectAtIndex:i];
        CGRect tfRect = tf.frame;
        tfRect.origin.y += _wordsLineOffset;
        tfRect.size.height += _wordsLineOffset>0?0:-_wordsLineOffset;
        tf.frame = tfRect;
    }
}

- (void)setPasswordKeyboardType:(UIKeyboardType)passwordKeyboardType {
    _passwordKeyboardType = passwordKeyboardType;
    _mainTextField.keyboardType = _passwordKeyboardType;
}
@end
