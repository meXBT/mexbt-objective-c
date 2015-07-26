//
//  MexbtClientTest.m
//  MexbtClient
//
//  Created by Abdullah Alansari on 7/24/15.
//  Copyright (c) 2015 Abdullah Alansari. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "MexbtClient.h"

@interface MexbtClientTest : XCTestCase
@end

@implementation MexbtClientTest

- (void)assertAccepted:(NSDictionary *)res {
    
    BOOL isAccepted = [res[@"isAccepted"] boolValue];
    XCTAssert(isAccepted);
}

- (void)testPublicApi {
    
    [self assertAccepted:[MexbtClient productPairs]];
    [self assertAccepted:[MexbtClient ticker:@"BTCMXN"]];
    [self assertAccepted:[MexbtClient trades:@"BTCMXN" startIndex:-1 count:20]];
    [self assertAccepted:[MexbtClient tradesByDate:@"BTCMXN" startDate:1416530012 endDate:1416559390]];
    [self assertAccepted:[MexbtClient orderBook:@"BTCMXN"]];
}

- (void)testPrivateApi {
    
    MexbtClient *client = [[MexbtClient alloc] init];
    client.privateKey = @"05f4208ccddcf336d4f328667e91c351";
    client.publicKey  = @"7d046e0665c4e8b05829129e461f9e21";
    client.userId     = @"ahimta@outlook.com";
    client.isSandbox  = YES;
    
    [self assertAccepted:[client createMarketOrder:@"BTCUSD" side:@"buy" qty:@1.0 px:@342.99]];
    [self assertAccepted:[client createLimitOrder:@"BTCUSD"  side:@"buy" qty:@1.0 px:@342.99]];
    
    NSDictionary *order = [client createOrder:@"BTCUSD" side:@"buy" orderType:0 qty:@1.0 px:@342.99];
    [self assertAccepted:order];
    
    NSInteger orderId = [order[@"serverOrderId"] integerValue];
    
    [self assertAccepted:[client modifyOrder:@"BTCUSD"    serverOrderId:orderId modifyAction:1]];
    [self assertAccepted:[client moveOrderToTop:@"BTCUSD" serverOrderId:orderId]];
    [self assertAccepted:[client executeOrder:@"BTCUSD"   serverOrderId:orderId]];
    
    [self assertAccepted:[client cancelOrder:@"BTCUSD" serverOrderId:orderId]];
    [self assertAccepted:[client cancelAll:@"BTCUSD"]];
    
    [self assertAccepted:[client accountInfo]];
    [self assertAccepted:[client balance]];
    [self assertAccepted:[client accountTrades:@"BTCUSD" startIndex:-1 count:20]];
    [self assertAccepted:[client orders]];
    [self assertAccepted:[client depositAddresses]];
    XCTAssertEqualObjects([client depositAddress:@"BTC"], @"SIM MODE - No addresses in Sim Mode");
    //[self assertAccepted:[client withdraw:@"BTC" amount:@1.123456 sendToAddress:@"address"]];
}

@end
