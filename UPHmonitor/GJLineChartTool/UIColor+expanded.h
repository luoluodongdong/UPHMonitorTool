//  您好，谢谢您参考我的项目，如果有问题请移步
//  https://github.com/manofit/GJLineChartView

/****
 VOORBEELDEN
 
 [UIColor colorWithRGBHex:0xff00ff];
 [UIColor colorWithHexString:@"0xff00ff"]
 *******/

#import <Cocoa/Cocoa.h>

#define SUPPORTS_UNDOCUMENTED_API	0

@interface NSColor (NSColor_Expanded)
@property (nonatomic, readonly) CGColorSpaceModel colorSpaceModel;
@property (nonatomic, readonly) BOOL canProvideRGBComponents;
@property (nonatomic, readonly) CGFloat red; // Only valid if canProvideRGBComponents is YES
@property (nonatomic, readonly) CGFloat green; // Only valid if canProvideRGBComponents is YES
@property (nonatomic, readonly) CGFloat blue; // Only valid if canProvideRGBComponents is YES
@property (nonatomic, readonly) CGFloat white; // Only valid if colorSpaceModel == kCGColorSpaceModelMonochrome
@property (nonatomic, readonly) CGFloat alpha;
@property (nonatomic, readonly) UInt32 rgbHex;

- (NSString *)colorSpaceString;

- (NSArray *)arrayFromRGBAComponents;

- (BOOL)red:(CGFloat *)r green:(CGFloat *)g blue:(CGFloat *)b alpha:(CGFloat *)a;

- (NSColor *)colorByLuminanceMapping;

- (NSColor *)colorByMultiplyingByRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
- (NSColor *)       colorByAddingRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
- (NSColor *) colorByLighteningToRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
- (NSColor *)  colorByDarkeningToRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;

- (NSColor *)colorByMultiplyingBy:(CGFloat)f;
- (NSColor *)       colorByAdding:(CGFloat)f;
- (NSColor *) colorByLighteningTo:(CGFloat)f;
- (NSColor *)  colorByDarkeningTo:(CGFloat)f;

- (NSColor *)colorByMultiplyingByColor:(NSColor *)color;
- (NSColor *)       colorByAddingColor:(NSColor *)color;
- (NSColor *) colorByLighteningToColor:(NSColor *)color;
- (NSColor *)  colorByDarkeningToColor:(NSColor *)color;

- (NSString *)stringFromColor;
- (NSString *)hexStringFromColor;

- (BOOL)isDark;

+ (NSColor *)randomColor;
+ (NSColor *)colorWithString:(NSString *)stringToConvert;
+ (NSColor *)colorWithRGBHex:(UInt32)hex;
+ (NSColor *)colorWithHexString:(NSString *)stringToConvert;
+ (NSColor *)colorWithHexString:(NSString *)stringToConvert andAlpha:(CGFloat)alpha;

+ (NSColor *)colorWithName:(NSString *)cssColorName;

@end

#if SUPPORTS_UNDOCUMENTED_API
// UIColor_Undocumented_Expanded
// Methods which rely on undocumented methods of UIColor
@interface NSColor (NSColor_Undocumented_Expanded)
- (NSString *)fetchStyleString;
- (NSColor *)rgbColor; // Via Poltras
@end
#endif // SUPPORTS_UNDOCUMENTED_API
