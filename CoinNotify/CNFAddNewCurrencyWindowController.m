//
//  CNFAddNewCurrencyWindowController.m
//  CoinNotify
//

#import "CNFAddNewCurrencyWindowController.h"
#import "CNFExchangeItemEntity.h"
#import "CNFExchangesDataSource.h"

@implementation CNFAddNewCurrencyWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        NSURL *currenciesURL = [[NSBundle mainBundle] URLForResource:@"currencies" withExtension:@"plist"];
        _options = [[NSMutableArray alloc] initWithContentsOfURL:currenciesURL];
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"symbol" ascending:YES];
        [_options sortUsingDescriptors:[NSArray arrayWithObject:sort]];

        NSLog(@"Options count %ld", (unsigned long)_options.count);
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    [[self window] makeKeyAndOrderFront:nil];
    [_resultsTableView reloadData];
}

- (IBAction)addCurrency:(id)sender
{
    NSInteger row = [_resultsTableView selectedRow];
    if (row == -1) {
        return;
    }

    [[CNFExchangesDataSource sharedDatasource] addEntity:[CNFExchangeItemEntity fromDictionary:[_options objectAtIndex:row]]];
    [[CNFExchangesDataSource sharedDatasource] updateQuotes];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
    return [_options count];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSTextField *result = [[NSTextField alloc] init];
    [result setBordered:NO];
    [result setBackgroundColor:[NSColor colorWithCalibratedWhite:1 alpha:0]];
    [result setEditable:NO];
    
    if ([tableColumn.identifier isEqual: @"symbol"]) {
        result.stringValue = [(NSDictionary*)[_options objectAtIndex:row] objectForKey:@"symbol"];
    } else if ([tableColumn.identifier isEqual: @"exchange"]) {
        result.stringValue = [(NSDictionary*)[_options objectAtIndex:row] objectForKey:@"exchange"];
    }
    
    return result;
}

@end
