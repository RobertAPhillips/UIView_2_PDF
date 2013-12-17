//
//  PageOneView.m
//  XIB_2_PDF
//
//  Created by Robert Phillips on 16/12/2013.
//  Copyright (c) 2013 Intohand. All rights reserved.
//

#import "PageOneView.h"

@interface PageOneView()

@end

@implementation PageOneView

- (id)init
{
    self = [super init];
    if (self)
    {
        // load the xib and add it to the view
        [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
        self.frame = _xibView.frame;
        [self addSubview:_xibView];
    }
    return self;
}

@end
