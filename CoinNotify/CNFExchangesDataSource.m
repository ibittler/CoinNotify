//
//  CNFExchangesDataSource.m
//  CoinNotify
//

#import "CNFConstants.h"

#import "CNFExchangesDataSource.h"
#import "CNFExchangeItemEntity.h"
#import "CNFQuotesFetcher.h"

#import "NSFileManager+DirectoryLocations.h"

@implementation CNFExchangesDataSource

+ (id) sharedDatasource
{
    static CNFExchangesDataSource *sharedDataSource = nil;
    @synchronized(self) {
        if (sharedDataSource == nil)
            sharedDataSource = [[super allocWithZone:NULL] init];
    }

    return sharedDataSource;
}

- (id) init
{
    self = [super init];
    exchangePrice = [[NSMutableArray alloc] init];
    NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:[[[NSFileManager defaultManager] applicationSupportDirectory] stringByAppendingPathComponent:@"com.ibittler.coinnotify.plist"]];

    for (int i = 0; i < [array count]; i++) {
        [exchangePrice insertObject:[CNFExchangeItemEntity fromDictionary:[array objectAtIndex:i]] atIndex:i];
    }
    
    return self;
}

- (void)addEntity:(id)anObject
{
    [exchangePrice addObject:anObject];
    [self save];
    [self dispatchUpdatedNotification];
}

- (id)objectAtIndex:(NSUInteger)index
{
    return [exchangePrice objectAtIndex:index];
}
- (NSUInteger)count
{
    return [exchangePrice count];
}

- (void) updateQuotes
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    
    for (int i = 0; i < [exchangePrice count]; i++) {
        dispatch_async(queue, ^{
            CNFExchangeItemEntity *new = [CNFQuotesFetcher getQuotes:[exchangePrice objectAtIndex:i]];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                if (new != nil) {
                    [exchangePrice replaceObjectAtIndex:i withObject:new];
                    [self dispatchUpdatedNotification];
                }
            });
        });
    }
}

- (void) dispatchUpdatedNotification
{
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:kUpdatedNotificationName object:nil]];
}

- (void)moveObjectFromIndex:(NSInteger) from toIndex:(NSInteger)to
{
    if (to != from) {
        id obj = [exchangePrice objectAtIndex:from];
        [exchangePrice removeObjectAtIndex:from];
        if (to >= [exchangePrice count]) {
            [exchangePrice addObject:obj];
        } else {
            [exchangePrice insertObject:obj atIndex:to];
        }
        obj = nil;
        [self save];
    }
}

- (void)deleteObjectAtIndex:(NSUInteger)index
{
    [exchangePrice removeObjectAtIndex:index];
    [self save];
}

- (BOOL) save
{
    NSMutableArray* newArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < exchangePrice.count; i++) {
        [newArray addObject:[((CNFExchangeItemEntity*)[exchangePrice objectAtIndex:i]) toDictionary]];
    }
    BOOL result = [newArray writeToFile:[[[NSFileManager defaultManager] applicationSupportDirectory] stringByAppendingPathComponent:@"com.ibittler.coinnotify.plist"] atomically:YES];
    if (result) {
        NSLog(@":)");
    } else {
        NSLog(@":(");
    }
    return result;
}

@end
