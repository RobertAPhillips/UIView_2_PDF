//
//  ViewController.m
//  RP_UIView_2_PDF
//
//  Created by Robert Phillips on 17/12/2013.
//  Copyright (c) 2013 Intohand. All rights reserved.
//

#import "ViewController.h"
#import "PageOneView.h"
#import "RP_UIView_2_PDF.h"
#import "PreviewViewController.h"

@implementation ViewController

#pragma mark - User Actions

- (IBAction)viewPDFButtonPressed:(id)sender {
    
    NSArray *pages = [self generateExamplePages];
    
    NSString *tempFilepath = [RP_UIView_2_PDF generatePDFWithPages:pages];
    
    [self performSegueWithIdentifier:@"WebView"
                              sender:[NSURL fileURLWithPath:tempFilepath]];
}

-(NSArray *)generateExamplePages {
    
    NSMutableArray *collection = [@[] mutableCopy];
    
    PageOneView *pageOneView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([PageOneView class]) owner:self options:nil].lastObject;
    pageOneView.titleOne.text = @"This title resizes:";
    pageOneView.titleTwo.text = @"This title also resizes:";
    pageOneView.labelOne.text = @"This label moves and resizes";
    pageOneView.labelTwo.text = @"This label also moves and resizes";
    pageOneView.rightAllignedLabel.text = @"$42.32";
    
    [collection addObject:pageOneView];
    
    UIView *pageTwoView = [[NSBundle mainBundle] loadNibNamed:@"PageTwoView" owner:self options:nil].lastObject;
    
    [collection addObject:pageTwoView];
    
    return [collection copy];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    PreviewViewController *controller = segue.destinationViewController;
    controller.url = sender;
}

@end
