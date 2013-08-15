//
//  CNFQuotesFetcher.h
//  CoinNotify
//

#import <Foundation/Foundation.h>
#import "CNFExchangeItemEntity.h"

@interface CNFQuotesFetcher : NSObject

+ (CNFExchangeItemEntity*) getQuotes:(CNFExchangeItemEntity*) item;
@end
