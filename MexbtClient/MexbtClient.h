//
//  MexbtClient.h
//  MexbtClient
//
//  Created by Abdullah Alansari on 7/24/15.
//  Copyright (c) 2015 Abdullah Alansari. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MexbtClient : NSObject

@property NSString *privateKey;
@property NSString *publicKey;
@property NSString *userId;
@property BOOL      isSandbox;

+ (NSDictionary *) ticker:(NSString *)productPair;

+ (NSDictionary *) trades:(NSString *)ins startIndex:(NSInteger)startIndex count:(NSUInteger)count;

+ (NSDictionary *) tradesByDate:(NSString *)ins startDate:(NSUInteger)startDate endDate:(NSUInteger)endDate;

+ (NSDictionary *) orderBook:(NSString *)productPair;

+ (NSDictionary *) productPairs;

- (NSDictionary *) createOrder:(NSString *)ins side:(NSString *)side orderType:(NSInteger)orderType
                           qty:(NSNumber *)qty px:(NSNumber *)px;

- (NSDictionary *) createMarketOrder:(NSString *)ins side:(NSString *)side qty:(NSNumber *)qty px:(NSNumber *)px;
- (NSDictionary *) createLimitOrder:(NSString *)ins  side:(NSString *)side qty:(NSNumber *)qty px:(NSNumber *)px;

- (NSDictionary *) modifyOrder:(NSString *)ins serverOrderId:(NSInteger)serverOrderId
                  modifyAction:(NSInteger)modifyAction;

- (NSDictionary *) moveOrderToTop:(NSString *)ins serverOrderId:(NSInteger)serverOrderId;
- (NSDictionary *) executeOrder:(NSString *)ins   serverOrderId:(NSInteger)serverOrderId;

- (NSDictionary *) cancelOrder:(NSString *)ins serverOrderId:(NSInteger)serverOrderId;

- (NSDictionary *) cancelAll:(NSString *)ins;

- (NSDictionary *) accountInfo;

- (NSDictionary *) balance;

- (NSDictionary *) accountTrades:(NSString *)ins startIndex:(NSInteger)startIndex count:(NSUInteger)count;

- (NSDictionary *) orders;

- (NSDictionary *) depositAddresses;

- (NSString *) depositAddress:(NSString *)ins;

- (NSDictionary *) withdraw:(NSString *)ins amount:(NSNumber *)amount sendToAddress:(NSString *)address;

@end
