//
//  CNFExchangeItemEntity.m
//  CoinNotify
//
#import "CNFConstants.h"

#import "CNFExchangeItemEntity.h"

@implementation CNFExchangeItemEntity

+ (CNFExchangeItemEntity*) fromDictionary:(NSDictionary*) dictionary
{
    CNFExchangeItemEntity* item = [[self alloc] init];
    item.symbol = [dictionary objectForKey:@"symbol"];
    item.updateUrl = [NSURL URLWithString:[dictionary objectForKey:@"update_url"]];
    item.exchangeName = [dictionary objectForKey:@"exchange"];
    item.exchangeId = [(NSNumber*)[dictionary objectForKey:@"exchange_id"] intValue];
    item.currency_1 = [dictionary objectForKey:@"currency_1"];
    item.currency_2 = [dictionary objectForKey:@"currency_2"];
    return item;
}

- (NSDictionary*) toDictionary
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:_symbol forKey:@"symbol"];
    [dict setObject:[NSString stringWithFormat:@"%@", _updateUrl] forKey:@"update_url"];
    [dict setObject:_exchangeName forKey:@"exchange"];
    [dict setObject:[NSNumber numberWithInt:_exchangeId] forKey:@"exchange_id"];
    [dict setObject:_currency_1 forKey:@"currency_1"];
    [dict setObject:_currency_2 forKey:@"currency_2"];
    
    return dict;
}

+ (NSString*) priceString:(NSNumber*) price withCurrency:(NSString*) currency
{
    NSInteger decimalSteps = [[NSUserDefaults standardUserDefaults] integerForKey:kSettingsDecimalSteps];    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setCurrencyCode:currency];
    [formatter setMaximumFractionDigits:decimalSteps];
    NSString *string = [formatter stringFromNumber:[NSNumber numberWithFloat:[price floatValue]]];
    return string;
}

@end
