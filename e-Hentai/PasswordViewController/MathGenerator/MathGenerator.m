//
//  MathGenerator.m
//  e-Hentai
//
//  Created by 啟倫 陳 on 2015/2/24.
//  Copyright (c) 2015年 ChilunChen. All rights reserved.
//

#import "MathGenerator.h"

@implementation MathGenerator

#pragma mark - class method

+ (NSDictionary *)generator {
    NSInteger answer;
    NSInteger fakeAnswer1, fakeAnswer2, fakeAnswer3;
    NSInteger field1, field2;
    NSString *operator;
    switch (arc4random() % 4) {
            //加
        case 0:
            operator = @"+";
            field1 = arc4random() % 150 + 1;
            field2 = arc4random() % 150 + 1;
            answer = field1 + field2;
            break;
            
            //減
        case 1:
            operator = @"-";
            field1 = arc4random() % 150 + 1;
            field2 = arc4random() % 150 + 1;
            answer = abs(field1 - field2);
            break;
            
            //乘
        case 2:
            operator = @"*";
            field1 = arc4random() % 30 + 1;
            field2 = arc4random() % 30 + 1;
            answer = field1 * field2;
            break;
            
            //除
        case 3:
            operator = @"/";
            answer = arc4random() % 30 + 1;
            field2 = arc4random() % 30 + 1;
            field1 = answer * field2;
            break;
            
        default:
            operator = nil;
            answer = 0;
            field2 = 0;
            field1 = 0;
            break;
    }
    
    fakeAnswer1 = (answer / (arc4random() % 3 + 2)) + (arc4random() % 150 + 1);
    fakeAnswer2 = (answer * (arc4random() % 3 + 2)) - (arc4random() % 150 + 1);
    NSInteger denominator = (arc4random() % 3 + 2);
    fakeAnswer3 = (fakeAnswer1 + fakeAnswer2) / denominator;
    
    NSMutableArray *options = [NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"%d", abs(answer)], [NSString stringWithFormat:@"%d", abs(fakeAnswer1)], [NSString stringWithFormat:@"%d", abs(fakeAnswer2)], [NSString stringWithFormat:@"%d", abs(fakeAnswer3)], nil];
    
    for (int i = 0; i < [options count]; i++) {
        [options exchangeObjectAtIndex:arc4random() % [options count] withObjectAtIndex:arc4random() % [options count]];
    }
    
    return @{ @"options": options, @"answer": [NSString stringWithFormat:@"%d", abs(answer)], @"field1": [NSString stringWithFormat:@"%d", MAX(field1, field2)], @"field2": [NSString stringWithFormat:@"%d", MIN(field1, field2)], @"operator": operator };
}

@end
