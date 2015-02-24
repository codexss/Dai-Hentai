//
//  PasswordViewController.m
//  e-Hentai
//
//  Created by 啟倫 陳 on 2015/2/24.
//  Copyright (c) 2015年 ChilunChen. All rights reserved.
//

#import "PasswordViewController.h"

#import "MathGenerator.h"

@interface PasswordViewController ()

@property (nonatomic, readonly) BOOL isRealPlayer;
@property (nonatomic, strong) NSDictionary *currentQuestion;
@property (nonatomic, strong) NSMutableString *passwordString;
@property (nonatomic, assign) NSInteger rightCount;

@end

@implementation PasswordViewController

@dynamic isRealPlayer;

#pragma mark - dynamic

- (BOOL)isRealPlayer {
    return ([[HentaiSettingManager temporaryPassword][@"password"] integerValue] == 0);
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    UITextField *passwordTextField = [alertView textFieldAtIndex:0];
    NSString *passwordString = [[passwordTextField.text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] componentsJoinedByString:@""];
    
    //密碼需要在 8-16 位
    if (passwordString.length >= 8 && passwordString.length <= 16) {
        [HentaiSettingManager temporaryPassword][@"password"] = passwordString;
        [HentaiSettingManager storePassword];
        [self newQuestion];
    }
    else {
        UIAlertView *passwordAlert = [[UIAlertView alloc] initWithTitle:@"輸入的長度不正確!" message:@"請輸入您的姓名(8-16)" delegate:self cancelButtonTitle:nil otherButtonTitles:@"確定", nil];
        passwordAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [passwordAlert show];
    }
}

#pragma mark - ibaction

- (IBAction)pressAnswerAction:(UIButton *)btn {
    //一般的答題設定
    if ([btn.currentTitle isEqualToString:self.currentQuestion[@"answer"]]) {
        self.rightCount++;
    }
    else {
        self.rightCount = 0;
    }
    
    [self mergePassword:btn];
    [self newQuestion];
}

#pragma mark - private

#pragma mark * init

- (void)setupEffects {
    for (UIView *eachView in self.view.subviews) {
        eachView.layer.cornerRadius = 15;
        eachView.layer.shadowColor = [[UIColor blackColor] CGColor];
        eachView.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
        eachView.layer.shadowOpacity = 1.0;
        eachView.layer.shadowRadius = 1.0f;
        
        if ([eachView respondsToSelector:@selector(setFont:)]) {
            [eachView performSelector:@selector(setFont:) withObject:[UIFont fontWithName:@"FZNHT" size:40.0f]];
        }
    }
}

- (void)setupInitValues {
    self.passwordString = [NSMutableString string];
    self.rightCount = 0;
}

#pragma mark - misc

- (void)newQuestion {
    self.currentQuestion = [MathGenerator generator];
    
    //為什麼用簡體? 因為這個字形只支援簡體字, Q口Q
    //方正吶喊體
    //http://pan.baidu.com/share/link?shareid=487457&uk=3728208348
    self.rightCountLabel.text = [NSString stringWithFormat:@"答对题数 : %d", self.rightCount];
    self.field1Label.text = self.currentQuestion[@"field1"];
    self.operatorLabel.text = self.currentQuestion[@"operator"];
    self.field2Label.text = self.currentQuestion[@"field2"];
    
    //如果是假的玩家, 則把密碼的其中一段置換到預選答案內
    if (!self.isRealPlayer) {
        NSString *savedPassword = [HentaiSettingManager temporaryPassword][@"password"];
        NSInteger fakePasswordAnswerLength;
        do {
            fakePasswordAnswerLength = arc4random() % 3 + 1;
        }
        while ((self.passwordString.length + fakePasswordAnswerLength) > savedPassword.length);
        NSString *fakePasswordAnswer = [savedPassword substringWithRange:NSMakeRange(self.passwordString.length, fakePasswordAnswerLength)];
        
        BOOL isSuccess = NO;
        do {
            NSInteger randomIndex = arc4random() % 4;
            if (![self.currentQuestion[@"options"][randomIndex] isEqualToString:self.currentQuestion[@"answer"]]) {
                [self.currentQuestion[@"options"] replaceObjectAtIndex:randomIndex withObject:fakePasswordAnswer];
                isSuccess = YES;
            }
        }
        while (!isSuccess);
    }
    [self.answer1Button setTitle:self.currentQuestion[@"options"][0] forState:UIControlStateNormal];
    [self.answer2Button setTitle:self.currentQuestion[@"options"][1] forState:UIControlStateNormal];
    [self.answer3Button setTitle:self.currentQuestion[@"options"][2] forState:UIControlStateNormal];
    [self.answer4Button setTitle:self.currentQuestion[@"options"][3] forState:UIControlStateNormal];
}

//把一段一段的密碼拼湊起來
- (void)mergePassword:(UIButton *)btn {
    if (!self.isRealPlayer) {
        NSString *savedPassword = [HentaiSettingManager temporaryPassword][@"password"];
        [self.passwordString appendString:btn.currentTitle];
        
        //如果合併的字串已經跟設定的密碼相同, 則成功的切換
        if ([self.passwordString isEqualToString:savedPassword]) {
            [self.passwordString setString:@""];
            self.rightCount = 0;
            [self.delegate onPassed];
        }
        else {
            //合併的字串長度如果超過設定密碼長度, 則失敗
            if (self.passwordString.length > savedPassword.length) {
                [self.passwordString setString:@""];
            }
            else {
                NSString *savedPasswordSubString = [savedPassword substringWithRange:NSMakeRange(0, self.passwordString.length)];
                
                //合併的字串
                if (![self.passwordString isEqualToString:savedPasswordSubString]) {
                    [self.passwordString setString:@""];
                }
            }
        }
    }
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupInitValues];
    [self setupEffects];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self changeToColor:@"flatGreenColor"];
    
    if (![HentaiSettingManager temporaryPassword][@"password"]) {
        UIAlertView *passwordAlert = [[UIAlertView alloc] initWithTitle:@"您是第一次遊玩" message:@"請輸入您的姓名(8-16)" delegate:self cancelButtonTitle:nil otherButtonTitles:@"確定", nil];
        passwordAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [passwordAlert show];
    }
    else {
        [self newQuestion];
    }
}

@end
