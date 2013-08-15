//
//  CNFPopupViewController.h
//  CoinNotify
//

#import <Cocoa/Cocoa.h>
#import "CNFAddNewCurrencyWindowController.h"
#import "CNFSettingsWindowController.h"

@interface CNFPopupViewController : NSViewController <NSTableViewDelegate, NSTableViewDataSource>

@property (assign) IBOutlet NSTableView* pricesTableView;
@property (strong, nonatomic) CNFAddNewCurrencyWindowController* addCurrencyWindowController;
@property (strong, nonatomic) CNFSettingsWindowController* settingWindowsController;

- (IBAction)openAddWindow:(id)sender;
- (IBAction)openSettings:(id)sender;
- (IBAction)openDonation:(id)sender;
- (IBAction)deleteRow:(id)sender;
@end
