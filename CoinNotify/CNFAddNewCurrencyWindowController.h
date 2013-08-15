//
//  CNFAddNewCurrencyWindowController.h
//  CoinNotify
//

#import <Cocoa/Cocoa.h>

@interface CNFAddNewCurrencyWindowController : NSWindowController <NSTableViewDataSource, NSTableViewDelegate>

@property (strong) NSMutableArray *options;
@property (assign) IBOutlet NSTableView *resultsTableView;

- (IBAction)addCurrency:(id)sender;
@end
