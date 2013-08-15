//
//  CNFExchangesDataSource.h
//  CoinNotify
//

#import <Foundation/Foundation.h>

@interface CNFExchangesDataSource : NSObject {
    NSMutableArray* exchangePrice;
}

+ (id) sharedDatasource;

- (void) updateQuotes;

- (void)addEntity:(id)anObject;
- (id)objectAtIndex:(NSUInteger)index;
- (void)deleteObjectAtIndex:(NSUInteger)index;
- (void)moveObjectFromIndex:(NSInteger) from toIndex:(NSInteger)to;
- (BOOL)save;
- (void)dispatchUpdatedNotification;
@end
