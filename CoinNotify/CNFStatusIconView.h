//
//  CNFStatusIconView.h
//  CoinNotify
//

#import <Cocoa/Cocoa.h>

@class CNFStatusIconView;

@protocol CNFStatusIconViewDelegate
- (void) mouseDown: (CNFStatusIconView *) sender;
- (void) updatedSize: (float) width;
@end

@interface CNFStatusIconView : NSView 

@property (nonatomic, weak) id <CNFStatusIconViewDelegate> delegate;
@property (assign) BOOL highlight;
@property (strong) NSString* text;

- (id)initWithDelegate:(id<CNFStatusIconViewDelegate>)delegate;
@end

