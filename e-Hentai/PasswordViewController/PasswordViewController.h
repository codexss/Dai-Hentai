//
//  PasswordViewController.h
//  e-Hentai
//
//  Created by 啟倫 陳 on 2015/2/24.
//  Copyright (c) 2015年 ChilunChen. All rights reserved.
//

#import "ColorThemeViewController.h"

@protocol PasswordViewControllerDelegate;

@interface PasswordViewController : ColorThemeViewController <UIAlertViewDelegate>

@property (nonatomic, weak) id <PasswordViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *field1Label;
@property (weak, nonatomic) IBOutlet UILabel *operatorLabel;
@property (weak, nonatomic) IBOutlet UILabel *field2Label;

@property (weak, nonatomic) IBOutlet UIButton *answer1Button;
@property (weak, nonatomic) IBOutlet UIButton *answer2Button;
@property (weak, nonatomic) IBOutlet UIButton *answer3Button;
@property (weak, nonatomic) IBOutlet UIButton *answer4Button;

@end

@protocol PasswordViewControllerDelegate <NSObject>

@required
- (void)onPassed;

@end
