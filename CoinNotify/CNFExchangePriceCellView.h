//
//  CNFExchangePriceCellView.h
//  CoinNotify
//

#import <Cocoa/Cocoa.h>

@interface CNFExchangePriceCellView : NSTableCellView

@property (assign) IBOutlet NSTextField *symbol;
@property (assign) IBOutlet NSTextField *price;
@property (assign) IBOutlet NSTextField *exchangeName;

@end
