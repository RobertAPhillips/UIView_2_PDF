//
//  ViewController.m
//  RP_UIView_2_PDF
//
//  Created by Robert Phillips on 17/12/2013.
//  Copyright (c) 2013 Intohand. All rights reserved.
//

#import "ViewController.h"
#import "PageOneView.h"
#import "PageTwoView.h"
#import "RP_UIView_2_PDF.h"

@interface ViewController ()

@property (strong, nonatomic) NSString *pdfPath;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - User Actions

- (IBAction)viewPDFButtonPressed:(id)sender
{
    NSMutableArray *arrayOfViews = [[NSMutableArray alloc] init];
    
    // create a page one instance
    PageOneView *pageOneView = [[PageOneView alloc] init];
    pageOneView.titleOne.text = @"This title resizes:";
    pageOneView.titleTwo.text = @"This title also resizes:";
    pageOneView.labelOne.text = @"This label moves and resizes";
    pageOneView.labelOne.text = @"This label also moves and resizes";
    [arrayOfViews addObject:pageOneView];
    
    // create a page two instance
    PageTwoView *pageTwoView = [[PageTwoView alloc] init];
    [arrayOfViews addObject:pageTwoView];
    
    // if you use the same view more than once then you will need to clone it or copy it
    NSData *viewConvertedToData = [NSKeyedArchiver archivedDataWithRootObject:pageOneView];
    UIView *pageOneClone = [NSKeyedUnarchiver unarchiveObjectWithData:viewConvertedToData];
    [arrayOfViews addObject:pageOneClone];
    
    // initialize the PDF drawing code
    RP_UIView_2_PDF *view2pdf = [[RP_UIView_2_PDF alloc] init];
    view2pdf.drawBoxesAroundLabels = YES;
    
    // assign the path to the PDF to the property variable so that QLPreviewController can display it by sending the views to the PDF creator
    self.pdfPath = [view2pdf pathToPDFByCreatingPDFFromUIViews:arrayOfViews withPDFFileName:@"myPDF"];
    
    // display the PDF
    QLPreviewController *preview = [[QLPreviewController alloc] init];
    preview.dataSource = self;
    [self presentViewController:preview animated:YES completion:nil];
}

#pragma mark - QLPreviewController DataSource

- (NSInteger) numberOfPreviewItemsInPreviewController: (QLPreviewController *) controller
{
    return 1;
}

- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    return [NSURL fileURLWithPath:_pdfPath];
}

@end
