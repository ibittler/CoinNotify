//
//  CNFAppDelegate.h
//  CoinNotify
//

#import <Cocoa/Cocoa.h>
#import "CNFStatusIconView.h"

@interface CNFAppDelegate : NSObject <NSApplicationDelegate, CNFStatusIconViewDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (retain) NSStatusItem *statusItem;
@property (strong) NSTimer *refreshingTimer;


@end
