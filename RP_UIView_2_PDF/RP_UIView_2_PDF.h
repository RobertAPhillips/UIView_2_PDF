//
//  RP_UIView_2_PDF.h
//  UIView_2_PDF
//
//  Created by Robert Phillips on 16/12/2013.
//  Copyright (c) 2013 Intohand. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RP_UIView_2_PDF : NSObject

@property (assign, nonatomic) BOOL drawBoxesAroundLabels;

- (NSString *)pathToPDFByCreatingPDFFromUIViews:(NSArray *)arrayOfViews withPDFFileName:(NSString *)fileName;

@end
