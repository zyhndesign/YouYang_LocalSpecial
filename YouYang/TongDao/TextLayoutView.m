//
//  TextLayoutView.m
//  labelPragraphT
//
//  Created by sunyong on 13-10-14.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "TextLayoutView.h"
#import <CoreText/CoreText.h>

@implementation TextLayoutView

@synthesize characterSpacing = characterSpacing_;
@synthesize linesSpacing = linesSpacing_;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.characterSpacing = 2.0f;
        self.linesSpacing = 5.0f;
    }
    return self;
}

- (void)setCharacterSpacing:(CGFloat)characterSpacing
{
    characterSpacing_ = characterSpacing;
    [self setNeedsDisplay];
}

- (void)setLinesSpacing:(long)linesSpacing
{
    linesSpacing_ = linesSpacing;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    NSString *labelString = self.text;
    NSString *myString = [labelString stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\n"];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:myString];
    CTFontRef helveticaBold = CTFontCreateWithName((CFStringRef)self.font.fontName, self.font.pointSize, nil);
    [string addAttribute:(id)kCTFontAttributeName value:(__bridge id)helveticaBold range:NSMakeRange(0, myString.length)];
    ////// set character space
    if (self.characterSpacing)
    {
        long number = self.characterSpacing;
        CFNumberRef num =  CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
        [string addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0, myString.length)];
        CFRelease(num);
    }
    //// set color
    [string addAttribute:(id)kCTForegroundColorAttributeName value:(__bridge id)self.textColor.CGColor range:NSMakeRange(0, myString.length)];
    
    ///// set text alignment
    CTTextAlignment alignment = kCTLeftTextAlignment;
    if (self.textAlignment == NSTextAlignmentCenter)
        alignment = kCTCenterTextAlignment;
    if (self.textAlignment == NSTextAlignmentRight)
        alignment = kCTRightTextAlignment;
    CTParagraphStyleSetting alignmentStyle;
    alignmentStyle.spec = kCTParagraphStyleSpecifierAlignment;
    alignmentStyle.valueSize = sizeof(alignment);
    alignmentStyle.value = &alignment;
    
    //// set line space
    CGFloat lineSpace = self.linesSpacing;
    CTParagraphStyleSetting lineSpaceStyle;
    lineSpaceStyle.spec = kCTParagraphStyleSpecifierLineSpacingAdjustment;
    lineSpaceStyle.valueSize = sizeof(lineSpace);
    lineSpaceStyle.value = &lineSpace;
    
    //// set paragraph space
    CGFloat paragraphSpacing = 5.0;
    CTParagraphStyleSetting paragraphSpaceStyle;
    paragraphSpaceStyle.spec = kCTParagraphStyleSpecifierParagraphSpacing;
    paragraphSpaceStyle.valueSize = sizeof(CGFloat);
    paragraphSpaceStyle.value = &paragraphSpacing;
    
    ////// rebulid setting group and add
    CTParagraphStyleSetting settings[] = {alignmentStyle, lineSpaceStyle, paragraphSpaceStyle};
    CTParagraphStyleRef style = CTParagraphStyleCreate(settings, sizeof(settings));
    [string addAttribute:(id)kCTParagraphStyleAttributeName value:(__bridge id)style range:NSMakeRange(0, myString.length)];
    CFRelease(style);
    
    ///// composing
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)string);
    
    CGMutablePathRef leftColumnPath = CGPathCreateMutable();
    
    CGPathAddRect(leftColumnPath, NULL ,CGRectMake(0 , 0 ,self.bounds.size.width , self.bounds.size.height));
    
    CTFrameRef leftFrame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0, 0), leftColumnPath , NULL);
    
    //////
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetTextMatrix(context , CGAffineTransformIdentity);
    
    CGContextTranslateCTM(context , 0 ,self.bounds.size.height);
    
    CGContextScaleCTM(context, 1.0 ,-1.0);
    
    CTFrameDraw(leftFrame,context);
    
    //释放
    CGPathRelease(leftColumnPath);
    CFRelease(leftFrame);
    CFRelease(framesetter);
    CFRelease(helveticaBold);
    UIGraphicsPushContext(context);
}

@end
