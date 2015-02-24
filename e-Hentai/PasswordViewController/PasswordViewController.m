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
    if ([btn.currentTitle isEqualToString:self.currentQuestion[@"answer"]]) {
        NSLog(@"對");
    }
    else {
        NSLog(@"錯");
    }
    
    if (!self.isRealPlayer) {
        [self.passwordString appendString:btn.currentTitle];
        
        NSString *savedPassword = [HentaiSettingManager temporaryPassword][@"password"];
        
        if ([self.passwordString isEqualToString:savedPassword]) {
            //pass
            NSLog(@"成功");
            [self.delegate onPassed];
            [self.passwordString setString:@""];
        }
        else {
            NSString *savedPasswordSubString = [savedPassword substringWithRange:NSMakeRange(0, self.passwordString.length)];
            if ([self.passwordString isEqualToString:savedPasswordSubString]) {
                //繼續等下一個字串
                NSLog(@"等");
            }
            else {
                //失敗
                [self.passwordString setString:@""];
            }
        }
    }
    
    [self newQuestion];
}


#pragma mark - private

- (void)newQuestion {
    self.currentQuestion = [MathGenerator generator];
    self.field1Label.text = self.currentQuestion[@"field1"];
    self.operatorLabel.text = self.currentQuestion[@"operator"];
    self.field2Label.text = self.currentQuestion[@"field2"];
    
    if (!self.isRealPlayer) {
        NSString *savedPassword = [HentaiSettingManager temporaryPassword][@"password"];
        NSInteger fakePasswordAnswerLength;
        do {
            fakePasswordAnswerLength = arc4random()%3 + 1;
        } while ((self.passwordString.length + fakePasswordAnswerLength) > savedPassword.length);
        NSString *fakePasswordAnswer = [savedPassword substringWithRange:NSMakeRange(self.passwordString.length, fakePasswordAnswerLength)];
        
        BOOL isSuccess = NO;
        do {
            NSInteger randomIndex = arc4random()%4;
            if (![self.currentQuestion[@"options"][randomIndex] isEqualToString:self.currentQuestion[@"answer"]]) {
                [self.currentQuestion[@"options"] replaceObjectAtIndex:randomIndex withObject:fakePasswordAnswer];
                isSuccess = YES;
            }
        } while (!isSuccess);
    }
    
    [self.answer1Button setTitle:self.currentQuestion[@"options"][0] forState:UIControlStateNormal];
    [self.answer2Button setTitle:self.currentQuestion[@"options"][1] forState:UIControlStateNormal];
    [self.answer3Button setTitle:self.currentQuestion[@"options"][2] forState:UIControlStateNormal];
    [self.answer4Button setTitle:self.currentQuestion[@"options"][3] forState:UIControlStateNormal];
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.passwordString = [NSMutableString string];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
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
