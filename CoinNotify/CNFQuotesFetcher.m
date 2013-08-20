//
//  CNFQuotesFetcher.m
//  CoinNotify
//

#import "CNFQuotesFetcher.h"
#import "CNFExchangeItemEntity.h"

#define kPriceKey @"price"
#define kCurrencyKey @"currency"

@implementation CNFQuotesFetcher

+ (CNFExchangeItemEntity*) getQuotes:(CNFExchangeItemEntity*) item
{
    NSMutableURLRequest *quotesRequest = [NSMutableURLRequest requestWithURL:item.updateUrl
                                                              cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                              timeoutInterval:15.0];
    [quotesRequest addValue:[self getUserAgent] forHTTPHeaderField:@"User-Agent"];
    
    NSURLResponse *response;
    NSError *error;
    
    NSData *quotesData = [NSURLConnection sendSynchronousRequest:quotesRequest returningResponse:&response error:&error];
    
    if (quotesData == nil || error != nil) {
        NSLog(@"**ERROR GETTING QUOTES** (%@) with error: %@ ", [quotesRequest URL], error);
        return nil;
    }
    NSLog(@"Quote request %@ (%d)", [quotesRequest URL], item.exchangeId);
    
    NSNumber* quotesResponse;
    
    switch (item.exchangeId) {
        case CNFMtGox:
            quotesResponse = [self parseMtGOX:quotesData];
            break;
        case CNFBitstamp:
            quotesResponse = [self parseBitstamp:quotesData];
            break;
        case CNFBtcE:
            quotesResponse = [self parseBtcE:quotesData];
            break;
        case CNFCampBX:
            quotesResponse = [self parseCampBX:quotesData];
            break;
        case CNFBitcoinAverage:
            quotesResponse = [self parseBitcoinAverage:quotesData];
            break;
        default:
            return nil;
            break;
    }
    
    item.price = quotesResponse;
    NSString* price = [CNFExchangeItemEntity priceString:item.price withCurrency:item.currency_2];
    item.priceString = price;
    return item;
}

+ (NSNumber*) parseMtGOX:(NSData*) json
{
    NSError *error;
    NSDictionary *quotes = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableContainers error:&error];
    
    if (error != nil) {
        NSLog(@"Error parsing MtGox data: %@", error);
        return nil;
    }
        
    float lastPrice = [(NSNumber*)[(NSDictionary*)[(NSDictionary*)[quotes objectForKey:@"data"] objectForKey:@"last"] objectForKey:@"value_int"] floatValue] / 100000;
    
    return [NSNumber numberWithFloat:lastPrice];
}

+ (NSNumber*) parseBitstamp:(NSData*) json
{
    NSError *error;
    NSDictionary *quotes = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableContainers error:&error];
    
    if (error != nil) {
        NSLog(@"** ERROR parsing Bitstamp ticker**: %@", error);
    }
    
    NSNumber* lastPrice = [quotes objectForKey:@"last"];
    return lastPrice;
}

+ (NSNumber*) parseBtcE:(NSData*) json
{
    NSError *error;
    NSDictionary *quotes = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableContainers error:&error];
    
    if (error != nil) {
        NSLog(@"** ERROR parsing BtcE ticker**: %@", error);
    }
    
    NSNumber* lastPrice = [(NSDictionary*)[quotes objectForKey:@"ticker"] objectForKey:@"last"];
    return lastPrice;
}

+ (NSNumber*) parseCampBX:(NSData*) json
{
    NSError *error;
    NSDictionary *quotes = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableContainers error:&error];
    
    if (error != nil) {
        NSLog(@"** ERROR parsing CampBZ ticker**: %@", error);
    }
    
    NSNumber* lastPrice = [quotes objectForKey:@"Last Trade"];
    return lastPrice;
}

+ (NSNumber*) parseBitcoinAverage:(NSData*) json
{
    NSError *error;
    NSDictionary *quotes = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableContainers error:&error];

    if (error != nil) {
        NSLog(@"** ERROR parsing BitcoinAverage ticker**: %@", error);
    }
    
    NSNumber* lastPrice = [quotes objectForKey:@"last"];
    return lastPrice;
}

+ (NSString*) getUserAgent
{
    return [NSString stringWithFormat:@"CoinNotify/%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
}

@end
