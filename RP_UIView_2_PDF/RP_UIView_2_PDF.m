//
//  RP_UIView_2_PDF.m
//  UIView_2_PDF
//
//  Created by Robert Phillips on 16/12/2013.
//  Copyright (c) 2013 Intohand. All rights reserved.
//

#import "RP_UIView_2_PDF.h"

@implementation RP_UIView_2_PDF

+(NSString *)generatePDF:(NSArray *)pages withName:(NSString *)filename outlineLabels:(BOOL)drawBoxesAroundLabels {
    
    NSString *filepath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.pdf", filename]];
    
    // Create the PDF context
    UIGraphicsBeginPDFContextToFile(filepath, CGRectZero, nil);
    
    // get the context reference so we can render to it.
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (UIView *page in pages)
    {
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0.0, 0.0, page.bounds.size.width, page.bounds.size.height), nil);
        
        NSArray *allSubViews = [self allSubViewsForPage:page];
        
        // draw UIView boxes and lines
        for (UIView *view in allSubViews)
        {
            if ([view isKindOfClass:[UIImageView class]]) {
                
                UIImageView *imageView = (UIImageView *)view;
                [imageView.image drawInRect:imageView.frame];
            } else if ([view isKindOfClass:[UILabel class]]) {
                
                UILabel *label = (UILabel *)view;
                
                if (drawBoxesAroundLabels) {
                    [self drawLinesUsingUIView:label withLineThickness:1.0 inGraphicsContext:context fillView:NO];
                }
                
                NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
                paragraphStyle.lineBreakMode = label.lineBreakMode;
                paragraphStyle.alignment = label.textAlignment;
                
                [label.text drawInRect:label.frame
                        withAttributes:@{
                                         NSFontAttributeName:label.font,
                                         NSParagraphStyleAttributeName:paragraphStyle,
                                         NSForegroundColorAttributeName:label.textColor
                                         }];
            } else if ([view isKindOfClass:[UIView class]]) {
                
                // draw view as boxes or lines
                [self drawLinesUsingUIView:view withLineThickness:1.0 inGraphicsContext:context fillView:view.tag];
            }
        }
    }
    
    UIGraphicsEndPDFContext();
    
    return filepath;
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
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, view.frame.origin.x, view.frame.origin.y+view.frame.size.height);
        CGPathAddLineToPoint(path, NULL, view.frame.origin.x, view.frame.origin.y);
        CGPathAddLineToPoint(path, NULL, view.frame.origin.x+view.frame.size.width, view.frame.origin.y);
        CGPathAddLineToPoint(path, NULL, view.frame.origin.x+view.frame.size.width, view.frame.origin.y+view.frame.size.height);
        CGPathCloseSubpath(path);
        CGContextAddPath(context, path);
        CGContextStrokePath(context);
        
        if (fillView)
        {
            // fill box if view tag set to 1 or boolean == yes
            CGContextSetFillColorWithColor(context, view.backgroundColor.CGColor);
            CGContextAddPath(context, path);
            CGContextFillPath(context);
        }
    }
    CGContextRestoreGState(context);
}

+(NSMutableArray*)allSubViewsForPage:(UIView *)page
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
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
        [array addObjectsFromArray:(NSArray*)[self allSubViewsForPage:subview]];
    }
    return array;
}

@end
