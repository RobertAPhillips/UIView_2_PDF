Create UIView objects using any method you like, including interface builder and Auto-layout, then generate a PDF directly from those views !

## Requirements
XCode 6.4+, iOS 7.0+

## Installation
In XCode, select 'Add Files To Project', and select RP_UIView_2_PDF.h

## Usage
1. Make a xib file that creates only UILabels and/or UIImageViews and/or other UIView subviews. Use views that are 1 pixel high or wide to create lines. Set the tag of a UIView to 1 to have it draw filled or zero to draw it as just a 1 pixel bordered box.
2. Load your xib like so
```objective-c
UIView *pageOne = [[NSBundle mainBundle] loadNibNamed:@"NibNameOne" owner:self options:nil].lastObject;
UIView *pageTwo = [[NSBundle mainBundle] loadNibNamed:@"NibNameTwo" owner:self options:nil].lastObject;
```
3. Then generate your PDF like this
```objective-c
NSString *tempFilepath = [RP_UIView_2_PDF generatePDFWithPages:@[pageOne, pageTwo];
```

See demo project for details.

## License
UIView_2_PDF is released under the MIT license. See 'LICENCE.md' for details.
