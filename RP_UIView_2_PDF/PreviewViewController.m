//
//  PreviewViewController.m
//  RP_UIView_2_PDF
//
//  Created by Robert Nash on 30/09/2015.
//  Copyright © 2015 Intohand. All rights reserved.
//

#import "PreviewViewController.h"

@interface PreviewViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation PreviewViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:self.url];
    [self.webView loadRequest:request];
}

@end
