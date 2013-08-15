//
//  CNFExchangeItemEntity.h
//  CoinNotify
//

#import <Foundation/Foundation.h>

@interface CNFExchangeItemEntity : NSObject
typedef NS_ENUM(NSUInteger, CNFExchanges) {
    CNFMtGox = 0,
    CNFBitstamp = 1,
    CNFBtcE = 2,
    CNFCampBX = 3
};

@property (strong) NSString* symbol;
@property (strong) NSString* exchangeName;
@property (strong) NSString* priceString;
@property (strong) NSNumber* price;
@property (strong) NSURL* updateUrl;
@property (assign) int exchangeId;
@property (strong) NSString* currency_2;
@property (strong) NSString* currency_1;

+ (CNFExchangeItemEntity*) fromDictionary:(NSDictionary*) dictionary;
+ (NSString*) priceString:(NSNumber*) price withCurrency:(NSString*) currency;
- (NSDictionary*) toDictionary;
@end
