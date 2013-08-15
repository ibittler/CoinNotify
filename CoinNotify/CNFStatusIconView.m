//
//  CNFStatusIconView.m
//  CoinNotify
//

#import "CNFStatusIconView.h"
#import "CNFConstants.h"

@implementation CNFStatusIconView

- (id)initWithDelegate:(id<CNFStatusIconViewDelegate>)delegate
{
    _delegate = delegate;
    self = [super initWithFrame:NSMakeRect(0, 0, 60, [NSStatusBar systemStatusBar].thickness)];
    
    if (self) {
        _text = @"Howdy";
    }
    
    return self;
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    if (_text == nil) {
        _text = @"Howdy";
    }
    
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
    
    if (_highlight) {
        [[NSColor selectedMenuItemColor] setFill];
        CGContextFillRect(context, dirtyRect);
    }
    
    NSFont *font = [NSFont menuBarFontOfSize:[NSFont systemFontSize] + 2.0f];
    
    NSColor *color;
    if (_highlight) {
        color = [NSColor selectedMenuItemTextColor];
    } else {
        color = [NSColor controlTextColor];
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setAlignment:NSCenterTextAlignment];
    NSShadow *stringShadow = [[NSShadow alloc] init];
	[stringShadow setShadowColor:[NSColor colorWithDeviceWhite:0.35 alpha:0.4]];
	NSSize shadowSize;
	shadowSize.width = 0.2f;
	shadowSize.height = 0.1f;
	[stringShadow setShadowOffset:shadowSize];
	[stringShadow setShadowBlurRadius:0.1f];
    
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                font, NSFontAttributeName,
                                color, NSForegroundColorAttributeName,
                                paragraphStyle, NSParagraphStyleAttributeName,
                                stringShadow, NSShadowAttributeName,
                                nil];
        
    CGContextSetAllowsAntialiasing(context, YES);
    CGContextSetAllowsFontSmoothing(context, YES);
    CGContextSetShouldSmoothFonts(context, YES);
    CGContextSetAllowsFontSubpixelPositioning(context, YES);
    CGContextSetShouldSubpixelPositionFonts(context, YES);
    CGContextSetAllowsFontSubpixelQuantization(context, YES);
    CGContextSetShouldSubpixelQuantizeFonts(context, YES);
    
	NSString *budgetString = _text;
	NSSize stringSize = [budgetString sizeWithAttributes:attributes];
    [self updatedSize:stringSize];
    
    float newWidth = stringSize.width * 1.1;
    dirtyRect = self.frame = NSMakeRect(0, 0, newWidth, [NSStatusBar systemStatusBar].thickness);
    
    NSPoint centerPoint;
	centerPoint.x = (dirtyRect.size.width / 2) - (stringSize.width / 2);
	centerPoint.y = dirtyRect.size.height / 2 - (stringSize.height / 2);
    
	[budgetString drawAtPoint:centerPoint withAttributes:attributes];
    CGContextFlush(context);
}


-(void)mouseDown:(NSEvent *)theEvent
{
    [self setHighlight:YES];
    [self setNeedsDisplay:YES];
    [_delegate mouseDown:self];
}

-(void)updatedSize:(NSSize)size
{
    [_delegate updatedSize:size.width];
    
}
@end
