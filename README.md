UIView_2_PDF
============

PDF generator using UIViews or UIViews with an associated XIB

UIView_2_PDF supports UIViews containing UIViews, UILables and UIImageViews

How To Use:

1) Add the class files RP_UIView_2_PDF.h and RP_UIView_2_PDF.m into your project.
2) Import RP_UIView_2_PDF into the class that you will use to create your UIViews.
3) Create a UIView class or classes that you want to be your PDF page or pages. Best done using a XIB by loading the XIB into the UIView class. For A4 size pages, create a UIView that is 595 points wide and 842 points high. US Letter size create a UIView that is 612 points wide by 792 points high.
4) Create an array and add your views to it.
5) Send the array of UIViews to the PDF generator class RP_UIView_2_PDF using the method:
```- (NSString *)pathToPDFByCreatingPDFFromUIViews:(NSArray *)arrayOfViews withPDFFileName:(NSString *)fileName;```
6) This method returns the path to the PDF located in the temp directory.
7) Use the path how you wish to either email or display the PDF.

Tips:
1) There is a bool property you may set to draw boxes around labels for debugging: drawBoxesAroundLabels = YES
2) Use autolayout in your XIBs to have the labels size themselves according to text content.
3) Use UIViews to make boxes and lines. Use views that are 1 pixel high or wide to create lines. Set the tag of a UIView to 1 to have it filled and zero to draw it as a 1 pixel bordered box.
4) If you want to use a UIView more than once in the same array, then clone it using the method in the code example or implement copy in your UIView class, otherwise the drawing of the second view will not draw correctly.
