//
//  RP_UIView_2_PDF.m
//  UIView_2_PDF
//
//  Created by Robert Phillips on 16/12/2013.
//  Copyright (c) 2013 Intohand. All rights reserved.
//

#import "RP_UIView_2_PDF.h"

@implementation RP_UIView_2_PDF

+(NSString *)generatePDFWithPages:(NSArray *)pages {
    
    NSString *filepath = [[NSTemporaryDirectory() stringByAppendingPathComponent:@"temp"] stringByAppendingPathExtension:@"pdf"];
    
    UIGraphicsBeginPDFContextToFile(filepath, CGRectZero, nil);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (UIView *page in pages) {
        [self drawPage:page withContext:context];
    }
    
    UIGraphicsEndPDFContext();
    
    return filepath;
}

+(void)drawPage:(UIView *)page withContext:(CGContextRef)context {
    
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0.0, 0.0, page.bounds.size.width, page.bounds.size.height), nil);
    
    for (UIView *subview in [self allSubViewsForPage:page]) {
        
        if ([subview isKindOfClass:[UIImageView class]]) {
            
            UIImageView *imageView = (UIImageView *)subview;
            [imageView.image drawInRect:imageView.frame];
            
        } else if ([subview isKindOfClass:[UILabel class]]) {
            
            UILabel *label = (UILabel *)subview;
            
            NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            paragraphStyle.lineBreakMode = label.lineBreakMode;
            paragraphStyle.alignment = label.textAlignment;
            
            [label.text drawInRect:label.frame
                    withAttributes:@{
                                     NSFontAttributeName:label.font,
                                     NSParagraphStyleAttributeName:paragraphStyle,
                                     NSForegroundColorAttributeName:label.textColor
                                     }];
            
        } else if ([subview isKindOfClass:[UIView class]]) {
            
            [self drawLinesUsingUIView:subview
                     withLineThickness:1.0
                     inGraphicsContext:context
                              fillView:subview.tag];
            
        }
    }
    
}

+(void)drawLinesUsingUIView:(UIView *)view withLineThickness:(float)thickness inGraphicsContext:(CGContextRef)context fillView:(BOOL)fillView
{    
    CGContextSaveGState(context);
    CGContextSetStrokeColorWithColor(context, view.backgroundColor.CGColor);
    CGContextSetFillColorWithColor(context, view.backgroundColor.CGColor);
    CGContextSetLineWidth(context, thickness);
    
    if (view.frame.size.width > 1 && view.frame.size.height == 1)
    {
        // view represents a horizontal line so draw one based on the top edge
        CGContextMoveToPoint(context, view.frame.origin.x-0.5, view.frame.origin.y);
        CGContextAddLineToPoint(context, view.frame.origin.x+view.frame.size.width-0.5, view.frame.origin.y);
        CGContextStrokePath(context);
    }
    else if (view.frame.size.width == 1 && view.frame.size.height > 1)
    {
        // view represents a vertical line so draw one based on the left edge
        CGContextMoveToPoint(context, view.frame.origin.x, view.frame.origin.y-0.5);
        CGContextAddLineToPoint(context, view.frame.origin.x, view.frame.origin.y+view.frame.size.height+0.5);
        CGContextStrokePath(context);
    }
    else if (view.frame.size.width > 1 && view.frame.size.height > 1)
    {
        // both the width and height of the view are greater than 1, so draw a rect around the frame
        if (fillView) {
            CGContextSetFillColorWithColor(context, view.backgroundColor.CGColor);
            CGContextFillRect(context, view.frame);
        }
        CGContextStrokeRect(context, view.frame);
    }
    CGContextRestoreGState(context);
}

+(NSArray*)allSubViewsForPage:(UIView *)page
{
    NSMutableArray *array = [@[] mutableCopy];
    
    [array addObject:page];
    
    for (UIView *subview in page.subviews)
    {
        if ([subview isKindOfClass:[UILabel class]])
        {
            UILabel *label = (UILabel *)subview;
            [label sizeToFit];
            [label layoutIfNeeded];
        }
                
        CGPoint origin = [subview.superview convertPoint:subview.frame.origin toView:subview.superview.superview];
        subview.frame = CGRectMake(origin.x, origin.y, subview.frame.size.width, subview.frame.size.height);
        [array addObjectsFromArray:[self allSubViewsForPage:subview]];
    }
    
    return [array copy];
}

@end
