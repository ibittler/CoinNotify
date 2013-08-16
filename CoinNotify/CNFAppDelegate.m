//
//  CNFAppDelegate.m
//  CoinNotify
//

#import "CNFConstants.h"

#import "CNFAppDelegate.h"
#import "CNFStatusIconView.h"
#import "CNFPopupViewController.h"
#import "CNFExchangeItemEntity.h"
#import "CNFExchangesDataSource.h"

#import <Sparkle/Sparkle.h>

@interface CNFAppDelegate () {
    NSViewController *_viewController;
    BOOL _active;
    NSPopover *_popover;
    CNFStatusIconView *_statusView;
}
@end

@implementation CNFAppDelegate

- (void)awakeFromNib
{
    _statusView = [[CNFStatusIconView alloc] initWithDelegate:self];
    _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:60];
    [_statusItem setView:_statusView];
    [_statusView setNeedsDisplay:YES];
    [[NSNotificationCenter defaultCenter] addObserverForName:kUpdatedNotificationName
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *notification){
                                                      if ([[CNFExchangesDataSource sharedDatasource] count] > 0) {
                                                          CNFExchangeItemEntity *entity = [[CNFExchangesDataSource sharedDatasource] objectAtIndex:0];
                                                          [_statusView setText:[entity priceString]];
                                                      } else {
                                                          [_statusView setText:@"Howdy"];
                                                      }
                                                      [_statusView setNeedsDisplay:YES];
                                                  }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changedDefaults)
                                                 name:NSUserDefaultsDidChangeNotification
                                               object:nil];

}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    _viewController = [[CNFPopupViewController alloc] initWithNibName:@"CNFPopupViewController"
                                                               bundle:[NSBundle mainBundle]];
    
    NSDictionary *defaultSettings = [NSDictionary dictionaryWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"default" withExtension:@"plist"]];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultSettings];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self scheduleTimer];
    
    [[SUUpdater sharedUpdater] setAutomaticallyDownloadsUpdates:YES];
    [[SUUpdater sharedUpdater] setSendsSystemProfile:YES];

    
    [[NSTimer scheduledTimerWithTimeInterval:7200
                                      target:self
                                    selector:@selector(checkForUpdates)
                                    userInfo:nil
                                     repeats:YES] fire];
}

- (void) mouseDown: (CNFStatusIconView *) sender {
    if (_popover.isShown) {
        [self hidePopover];
    } else {
        [self showPopoverAnimated:YES fromView:sender];
    }
}

- (void) updatedSize:(float)size
{        
    if (_statusItem.length != size + 10) {
        _statusItem.length = size + 10;
    }
}

- (void)showPopoverAnimated:(BOOL)animated fromView:(NSView*) view
{
    _active = YES;
    
    if (!_popover) {
        _popover = [[NSPopover alloc] init];
        _popover.contentViewController = _viewController;
    }
    
    if (!_popover.isShown) {
        _popover.behavior = NSPopoverBehaviorApplicationDefined;
        _popover.animates = animated;
        [_popover showRelativeToRect:[view frame] ofView:view preferredEdge:NSMinYEdge];
    }
}

- (void)hidePopover
{
    _active = NO;
    [_statusView setHighlight:NO];
    [_statusView setNeedsDisplay:YES];
    
    if (_popover && _popover.isShown) {
        [_popover close];
    }
}

- (void) updateQuotes
{
    NSLog(@"Updating…");
    [[CNFExchangesDataSource sharedDatasource] updateQuotes];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    [[CNFExchangesDataSource sharedDatasource] save];
}

- (void)checkForUpdates
{
    [[SUUpdater sharedUpdater] checkForUpdatesInBackground];
}

- (void)scheduleTimer
{
    _refreshingTimer = [NSTimer scheduledTimerWithTimeInterval:[[NSUserDefaults standardUserDefaults] floatForKey:kSettingsUpdateFrequency]
                                                        target:self
                                                      selector:@selector(updateQuotes)
                                                      userInfo:nil
                                                       repeats:YES];
    [_refreshingTimer fire];
}

- (void)changedDefaults
{
    if (_refreshingTimer.timeInterval == [[NSUserDefaults standardUserDefaults] floatForKey:kSettingsUpdateFrequency]) {
        return;
    }
    NSLog(@"Defaults changed");
    [_refreshingTimer invalidate];
    _refreshingTimer = nil;
    [self scheduleTimer];
}
@end
