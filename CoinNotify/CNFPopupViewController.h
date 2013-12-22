//
//  CNFPopupViewController.h
//  CoinNotify
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "CNFAddNewCurrencyWindowController.h"
#import "CNFSettingsWindowController.h"

@interface CNFPopupViewController : NSViewController <NSTableViewDelegate, NSTableViewDataSource>

@property (assign) IBOutlet NSTableView* pricesTableView;
@property (strong, nonatomic) CNFAddNewCurrencyWindowController* addCurrencyWindowController;
@property (strong, nonatomic) CNFSettingsWindowController* settingWindowsController;
@property (assign) IBOutlet WebView* adWebView;

- (IBAction)openAddWindow:(id)sender;
- (IBAction)openSettings:(id)sender;
- (IBAction)openDonation:(id)sender;
- (IBAction)deleteRow:(id)sender;

- (void)loadAd;
@end
