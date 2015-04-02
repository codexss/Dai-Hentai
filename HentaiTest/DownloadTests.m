//
//  DownloadTests.m
//  e-Hentai
//
//  Created by DaidoujiChen on 2015/4/2.
//  Copyright (c) 2015年 ChilunChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <KIF/KIF.h>
#import <KIF/CGGeometry-KIFAdditions.h>

@interface DownloadTests : KIFTestCase

@end

@implementation DownloadTests

- (void)beforeEach {
    [tester waitForTimeInterval:2.0f];
}

- (void)afterEach {
    [tester waitForTimeInterval:2.0f];
}

- (void)testDownload {
    [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:(arc4random()%5 + 5)] inTableViewWithAccessibilityIdentifier:@"listTableView"];
    [tester waitForAnimationsToFinish];
    [tester tapViewWithAccessibilityLabel:@"下載"];
    [tester waitForAnimationsToFinish];
    [tester tapViewWithAccessibilityLabel:@"Done"];
    [tester waitForAnimationsToFinish];
    [self customLongSwipe];
    [tester waitForTimeInterval:10.0f];
    [tester tapViewWithAccessibilityLabel:@"Done"];
}

- (void)customLongSwipe {
    UIView *viewToSwipe = nil;
    UIAccessibilityElement *element = nil;
    [tester waitForAccessibilityElement:&element view:&viewToSwipe withLabel:@"sliderView" value:nil traits:UIAccessibilityTraitNone tappable:NO];
    CGRect elementFrame = [viewToSwipe.windowOrIdentityWindow convertRect:element.accessibilityFrame toView:viewToSwipe];
    CGPoint swipeStart = CGPointCenteredInRect(elementFrame);
    swipeStart.x = [UIScreen mainScreen].bounds.size.width - 10;
    CGPoint swipeEnd = swipeStart;
    swipeEnd.x = 10;
    [viewToSwipe dragFromPoint:swipeStart toPoint:swipeEnd];
}

@end
