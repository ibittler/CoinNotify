//
//  CNFPopupViewController.m
//  CoinNotify
//

#import "CNFConstants.h"

#import "CNFPopupViewController.h"
#import "CNFExchangesDataSource.h"
#import "CNFExchangePriceCellView.h"
#import "CNFExchangeItemEntity.h"
#import "CNFExchangesDataSource.h"
#import "CNFAddNewCurrencyWindowController.h"
#import "CNFSettingsWindowController.h"

@implementation CNFPopupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    [[NSNotificationCenter defaultCenter] addObserverForName:kUpdatedNotificationName
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *notification){
                                                      [_pricesTableView reloadData];
                                                  }];
    [self loadView];
    
    [[NSTimer scheduledTimerWithTimeInterval:3000
                                      target:self
                                    selector:@selector(loadAd)
                                    userInfo:nil
                                     repeats:YES] fire];
    
    return self;
}

- (void) awakeFromNib
{
    [_pricesTableView registerForDraggedTypes:[NSArray arrayWithObject:kPricesTableViewType]];
    [_adWebView setShouldUpdateWhileOffscreen:YES];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    CNFExchangeItemEntity* item = [[CNFExchangesDataSource sharedDatasource] objectAtIndex:row];
    CNFExchangePriceCellView *cellView = [tableView makeViewWithIdentifier:@"MainCell" owner:self];

    cellView.symbol.stringValue = [item symbol];
    cellView.exchangeName.stringValue = [item exchangeName];

    if ([item priceString] == NULL) {
        [cellView.price setHidden:YES];
    } else {
        cellView.price.stringValue = [item priceString];
        [cellView.price setHidden:NO];
    }
    
    return cellView;
}

- (BOOL)tableView:(NSTableView *)aTableView writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard *)pboard
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:rowIndexes];
    [pboard declareTypes:[NSArray arrayWithObject:kPricesTableViewType] owner:self];
    [pboard setData:data forType:kPricesTableViewType];
    
    return YES;
}

- (NSDragOperation)tableView:(NSTableView *)aTableView validateDrop:(id < NSDraggingInfo >)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)operation
{
    if ([info draggingSource] == aTableView) {
        if (operation == NSTableViewDropOn){
            [aTableView setDropRow:row dropOperation:NSTableViewDropAbove];
        }
        return NSDragOperationMove;
    } else {
        return NSDragOperationNone;
    }
}

- (BOOL)tableView:(NSTableView *)aTableView acceptDrop:(id < NSDraggingInfo >)info row:(NSInteger)row dropOperation:(NSTableViewDropOperation)operation
{
    NSPasteboard* pboard = [info draggingPasteboard];
    NSData* rowData = [pboard dataForType:kPricesTableViewType];
    NSIndexSet* rowIndexes = [NSKeyedUnarchiver unarchiveObjectWithData:rowData];
    NSInteger from = [rowIndexes firstIndex];
    
    [[CNFExchangesDataSource sharedDatasource] moveObjectFromIndex:from toIndex:row];
    [aTableView reloadData];
    [[CNFExchangesDataSource sharedDatasource] dispatchUpdatedNotification];
    return YES;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [[CNFExchangesDataSource sharedDatasource] count];
}

- (IBAction)openAddWindow:(id)sender
{
    if (_addCurrencyWindowController == nil) {
        _addCurrencyWindowController = [[CNFAddNewCurrencyWindowController alloc] initWithWindowNibName:@"CNFAddNewCurrencyWindowController"];
    }
    
    [_addCurrencyWindowController showWindow:sender];
}

- (IBAction)openSettings:(id)sender
{
    if (_settingWindowsController == nil) {
        _settingWindowsController = [[CNFSettingsWindowController alloc] initWithWindowNibName:@"CNFSettingsWindowController"];
    }
    [_settingWindowsController showWindow:sender];
}

- (IBAction)deleteRow:(id)sender
{
    [[CNFExchangesDataSource sharedDatasource] deleteObjectAtIndex:[_pricesTableView clickedRow]];
    [_pricesTableView reloadData];
    [[CNFExchangesDataSource sharedDatasource] dispatchUpdatedNotification];
}

- (IBAction)openDonation:(id)sender
{
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://ibittler.github.io/CoinNotify/#donations"]];
}

- (void) loadAd
{
    [[_adWebView mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://coinnotify.appspot.com/static/ad.html"] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30]];
}

-(void)webView:(WebView *)webView decidePolicyForNewWindowAction:(NSDictionary *)actionInformation
       request:(NSURLRequest *)request
  newFrameName:(NSString *)frameName
decisionListener:(id <WebPolicyDecisionListener>)listener
{
    NSLog(@"Policy new window: %@", [request URL]);
    [listener ignore];
    [[NSWorkspace sharedWorkspace] openURL:[request URL]];

}
@end
