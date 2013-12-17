//
//  RP_UIView_2_PDF.m
//  UIView_2_PDF
//
//  Created by Robert Phillips on 16/12/2013.
//  Copyright (c) 2013 Intohand. All rights reserved.
//

#import "RP_UIView_2_PDF.h"

@interface RP_UIView_2_PDF()

@property (strong, nonatomic) NSString *pdfFilePath;

@end

@implementation RP_UIView_2_PDF

- (NSString *)pathToPDFByCreatingPDFFromUIViews:(NSArray *)arrayOfViews withPDFFileName:(NSString *)fileName
{
    self.pdfFilePath = [self tempDirectoryPathAddingFileName:[NSString stringWithFormat:@"%@.pdf", fileName]];
    
    // Create the PDF context
    UIGraphicsBeginPDFContextToFile(_pdfFilePath, CGRectZero, nil);
    
    // get the context reference so we can render to it.
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (UIView *inputView in arrayOfViews)
    {
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0.0, 0.0, inputView.bounds.size.width, inputView.bounds.size.height), nil);
        
        NSArray *allSubViews = [self allSubViewsForView:inputView];
        
        // draw UIView boxes and lines
        for (UIView *view in allSubViews)
        {
            if ([view isKindOfClass:[UIView class]] &&
                ![view isKindOfClass:[UILabel class]] &&
                ![view isKindOfClass:[UIImageView class]])
            {
                // draw view as boxes or lines
                [self drawLinesUsingUIView:view withLineThickness:1.0 inGraphicsContext:context fillView:view.tag];
            }
            else if ([view isKindOfClass:[UILabel class]])
            {
                UILabel *label = (UILabel *)view;
                
                if (_drawBoxesAroundLabels)
                    [self drawLinesUsingUIView:label withLineThickness:1.0 inGraphicsContext:context fillView:NO];
                
                NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
                paragraphStyle.lineBreakMode = label.lineBreakMode;
                paragraphStyle.alignment = label.textAlignment;
                
                NSDictionary *attributes = @{NSFontAttributeName:label.font,
                                             NSParagraphStyleAttributeName:paragraphStyle,
                                             NSForegroundColorAttributeName:label.textColor};
                
                CGRect labelRect = CGRectMake(label.frame.origin.x,
                                              label.frame.origin.y,
                                              label.frame.size.width,
                                              label.frame.size.height);
                
                [label.text drawInRect:labelRect withAttributes:attributes];
            }
            else if ([view isKindOfClass:[UIImageView class]])
            {
                UIImageView *imageView = (UIImageView *)view;
                
                [imageView.image drawInRect:CGRectMake(imageView.frame.origin.x,
                                                       imageView.frame.origin.y,
                                                       imageView.frame.size.width,
                                                       imageView.frame.size.height)];
            }
        }
    }
    
    UIGraphicsEndPDFContext();
    
    return _pdfFilePath;
}

- (void)drawLinesUsingUIView:(UIView *)view withLineThickness:(float)thickness inGraphicsContext:(CGContextRef)context fillView:(BOOL)fillView
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

- (NSString *)tempDirectoryPathAddingFileName:(NSString *)fileName
{
    NSString *path = NSTemporaryDirectory();
	return [path stringByAppendingPathComponent:fileName];
}

- (NSMutableArray*)allSubViewsForView:(UIView *)view
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:view];
    
    for (UIView *subview in view.subviews)
    {
        if ([subview isKindOfClass:[UILabel class]])
        {
            UILabel *label = (UILabel *)subview;
            [label sizeToFit];
            [label layoutIfNeeded];
        }
        
        CGPoint origin = [subview.superview convertPoint:subview.frame.origin toView:subview.superview.superview];
        subview.frame = CGRectMake(origin.x, origin.y, subview.frame.size.width, subview.frame.size.height);
        [array addObjectsFromArray:(NSArray*)[self allSubViewsForView:subview]];
    }
    return array;
}

@end
