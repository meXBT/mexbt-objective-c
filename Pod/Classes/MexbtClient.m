//
//  MexbtClient.m
//  Pods
//
//  Created by Abdullah Alansari on 7/24/15.
//
//

#import "MexbtClient.h"

#import <CommonCrypto/CommonHMAC.h>
#import <string.h>

@implementation MexbtClient

@synthesize privateKey = _privateKey;
@synthesize publicKey  = _publicKey;
@synthesize isSandbox  = _isSandbox;
@synthesize userId     = _userId;

- (NSDictionary *) createOrder:(NSString *)ins side:(NSString *)side orderType:(NSInteger)orderType
                           qty:(NSNumber *)qty px:(NSNumber *)px {
    return [self privateRequest:@"orders/create"
                            req:@{@"ins": ins, @"side": side,
                                  @"orderType": [NSNumber numberWithUnsignedInteger:orderType],
                                  @"qty": qty, @"px": px}];
}

- (NSDictionary *) createMarketOrder:(NSString *)ins side:(NSString *)side qty:(NSNumber *)qty px:(NSNumber *)px {
    return [self createOrder:ins side:side orderType:1 qty:qty px:px];
}

- (NSDictionary *) createLimitOrder:(NSString *)ins side:(NSString *)side qty:(NSNumber *)qty px:(NSNumber *)px {
    return [self createOrder:ins side:side orderType:0 qty:qty px:px];
}

- (NSDictionary *) modifyOrder:(NSString *)ins serverOrderId:(NSInteger)serverOrderId
                  modifyAction:(NSInteger)modifyAction {
    
    return [self privateRequest:@"orders/modify"
                            req:@{@"ins": ins,
                                  @"serverOrderId": [NSNumber numberWithUnsignedInteger:serverOrderId],
                                  @"modifyAction": [NSNumber numberWithUnsignedInteger:modifyAction]}];
}

- (NSDictionary *) moveOrderToTop:(NSString *)ins serverOrderId:(NSInteger)serverOrderId {
    return [self modifyOrder:ins serverOrderId:serverOrderId modifyAction:0];
}

- (NSDictionary *) executeOrder:(NSString *)ins serverOrderId:(NSInteger)serverOrderId {
    return [self modifyOrder:ins serverOrderId:serverOrderId modifyAction:1];
}

- (NSDictionary *) cancelOrder:(NSString *)ins serverOrderId:(NSInteger)serverOrderId {
    return [self privateRequest:@"orders/cancel"
                            req:@{@"ins": ins,
                                  @"serverOrderId": [NSNumber numberWithUnsignedInteger:serverOrderId]}];
}

- (NSDictionary *) cancelAll:(NSString *)ins {
    return [self privateRequest:@"orders/cancel-all" req:@{@"ins": ins}];
}

- (NSDictionary *) accountInfo {
    return [self privateRequest:@"me" req:@{}];
}

- (NSDictionary *) balance {
    return [self privateRequest:@"balance" req:@{}];
}

- (NSDictionary *) accountTrades:(NSString *)ins startIndex:(NSInteger)startIndex count:(NSUInteger)count {
    
    return [self privateRequest:@"trades"
                            req:@{@"ins": ins,
                                  @"startIndex": [NSNumber numberWithInteger:startIndex],
                                  @"count": [NSNumber numberWithUnsignedInteger:count]}];
}

- (NSDictionary *) orders {
    return [self privateRequest:@"orders" req:@{}];
}

- (NSDictionary *) depositAddresses {
    return [self privateRequest:@"deposit-addresses" req:@{}];
}

- (NSString *) depositAddress:(NSString *)ins {
    
    NSDictionary *res = [self depositAddresses];
    
    if (res == nil) { return nil; }
    else {
        NSArray *nameAddressPairs = res[@"addresses"];
        
        NSUInteger index = [nameAddressPairs indexOfObjectPassingTest:^BOOL(id pair, NSUInteger idx, BOOL *stop) {
            
            NSString *name = pair[@"name"];
            return [name isEqualToString:ins];
        }];
        
        if (index == NSNotFound) {
            return nil;
        }
        else {
            NSString *address = nameAddressPairs[index][@"depositAddress"];
            return address;
        }
    }
}

- (NSDictionary *) withdraw:(NSString *)ins amount:(NSNumber *)amount sendToAddress:(NSString *)address {
    
    NSString *amountFormat = self.isSandbox ? @"%.6f" : @"%.8f";
    NSString *formattedAmount = [NSString stringWithFormat:amountFormat, amount];
    
    return [self privateRequest:@"withdraw"
                            req:@{@"ins": ins, @"amount": formattedAmount, @"sendToAddress": address}];
}

- (NSDictionary *) privateRequest:(NSString *)endpoint req:(NSDictionary *)req {
    
    NSString *baseUrl = self.isSandbox ? @"https://private-api-sandbox.mexbt.com/v1/"
    : @"https://private-api.mexbt.com/v1/";
    
    NSString *url = [baseUrl stringByAppendingString:endpoint];
    
    return [MexbtClient url:url req:[self sign:req]];
}

- (NSDictionary *) sign:(NSDictionary *)req {
    
    long nonce = (long)([[NSDate date] timeIntervalSince1970] * 1000.0);
    
    NSString *message = [[NSString alloc] initWithFormat:@"%ld%@%@",nonce,self.userId,self.publicKey];
    
    const char *key  = [self.privateKey cStringUsingEncoding:NSUTF8StringEncoding];
    const char *data = [message cStringUsingEncoding:NSUTF8StringEncoding];
    
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, key, strlen(key), data, strlen(data), cHMAC);
    NSData *sig = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    
    const unsigned char *buffer = (const unsigned char*)[sig bytes];
    NSMutableString *s = [NSMutableString stringWithCapacity:sig.length * 2];
    
    for (int i = 0; i < sig.length; i++) {
        [s appendFormat:@"%02x", buffer[i]];
    }
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:req];
    dict[@"apiNonce"] = [NSNumber numberWithLong:nonce];
    dict[@"apiSig"]   = [s uppercaseString];
    dict[@"apiKey"]   = self.publicKey;
    
    return [[NSDictionary alloc] initWithDictionary:dict];
}

+ (NSDictionary *) ticker:(NSString *)productPair {
    return [MexbtClient publicRequest:@"ticker" req:@{@"productPair": productPair}];
}

+ (NSDictionary *) trades:(NSString *)ins startIndex:(NSInteger)startIndex count:(NSUInteger)count {
    
    return [MexbtClient publicRequest:@"trades"
                                  req:@{@"ins": ins,
                                        @"startIndex": [NSNumber numberWithInteger:startIndex],
                                        @"count": [NSNumber numberWithUnsignedInteger:count]}];
}

+ (NSDictionary *) tradesByDate:(NSString *)ins startDate:(NSUInteger)startDate endDate:(NSUInteger)endDate {
    
    return [MexbtClient publicRequest:@"trades-by-date"
                                  req:@{@"ins": ins,
                                        @"startDate": [NSNumber numberWithUnsignedInteger:startDate],
                                        @"endDate": [NSNumber numberWithUnsignedInteger:endDate]}];
}

+ (NSDictionary *) orderBook:(NSString *)productPair {
    return [MexbtClient publicRequest:@"order-book" req:@{@"productPair": productPair}];
}


+ (NSDictionary *) productPairs {
    return [MexbtClient publicRequest:@"product-pairs" req:@{}];
}

+ (NSDictionary *)publicRequest:(NSString *)endpoint req:(NSDictionary *)req {
    
    NSString *url = [@"https://public-api.mexbt.com/v1/" stringByAppendingString:endpoint];
    return [MexbtClient url:url req:req];
}

+ (NSDictionary *)url:(NSString *)url req:(NSDictionary *)req {
    
    NSError *error = [[NSError alloc] init];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:req options:0 error:&error];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setHTTPMethod: @"POST"];
    [request setURL:[NSURL URLWithString:url]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPBody:postData];
    NSHTTPURLResponse *responseCode = nil;
    
    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    
    NSInteger statusCode = [responseCode statusCode];
    
    if (statusCode != 200) { return nil;                                                                           }
    else                   { return [NSJSONSerialization JSONObjectWithData:oResponseData options:0 error:&error]; }
}
@end