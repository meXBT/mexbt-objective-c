//
//  MexbtClientTests.m
//  MexbtClientTests
//
//  Created by Abdullah Alansari on 07/27/2015.
//

// https://github.com/Specta/Specta
#import <MexbtClient/MexbtClient.h>

SpecBegin(InitialSpecs)

describe(@"Public API", ^{
    
    it(@"ticker", ^{
        expect([MexbtClient ticker:@"BTCMXN"][@"isAccepted"]).to.beTruthy();
    });
    
    it(@"trades", ^{
        expect([MexbtClient trades:@"BTCMXN" startIndex:-1 count:20][@"isAccepted"]).to.beTruthy();
    });
    
    it(@"tradesByDate", ^{
        expect([MexbtClient tradesByDate:@"BTCMXN" startDate:1416530012 endDate:1416559390][@"isAccepted"]).to.beTruthy();
    });
    
    it(@"orderBook", ^{
        expect([MexbtClient orderBook:@"BTCMXN"][@"isAccepted"]).to.beTruthy();
    });
    
    it(@"productPairs", ^{
        expect([MexbtClient productPairs][@"isAccepted"]).to.beTruthy();
    });
});

describe(@"Private API", ^{
    
    MexbtClient *client = [[MexbtClient alloc] init];
    client.privateKey = @"05f4208ccddcf336d4f328667e91c351";
    client.publicKey  = @"7d046e0665c4e8b05829129e461f9e21";
    client.userId     = @"ahimta@outlook.com";
    client.isSandbox  = YES;
    
    describe(@"Account information", ^{
        
        it(@"User Information", ^{
            expect([client accountInfo][@"isAccepted"]).to.beTruthy();
        });
        
        it(@"Account Balance", ^{
            expect([client balance][@"isAccepted"]).to.beTruthy();
        });
        
        it(@"Account Orders", ^{
            expect([client orders][@"isAccepted"]).to.beTruthy();
        });
        
        it(@"Account Trades", ^{
            expect([client accountTrades:@"BTCUSD" startIndex:-1 count:20][@"isAccepted"]).to.beTruthy();
        });
        
        it(@"Deposit Addresses", ^{
            expect([client depositAddresses][@"isAccepted"]).to.beTruthy();
        });
        
        it(@"Deposit Address", ^{
            expect([client depositAddress:@"BTC"]).to.equal(@"SIM MODE - No addresses in Sim Mode");
        });
    });
    
    describe(@"Order management", ^{
        
        it(@"Create Market Order", ^{
            expect([client createMarketOrder:@"BTCUSD" side:@"buy" qty:@1.0 px:@342.99][@"isAccepted"]).to.beTruthy();
        });
        
        it(@"Create Limit Order", ^{
            expect([client createLimitOrder:@"BTCUSD" side:@"buy" qty:@1.0 px:@342.99][@"isAccepted"]).to.beTruthy();
        });
        
        it(@"Cancel All Orders", ^{
            expect([client cancelAll:@"BTCUSD"][@"isAccepted"]).to.beTruthy();
        });
        
        it(@"Modify/Cancel Order", ^{
            
            NSDictionary *order = [client createOrder:@"BTCUSD" side:@"buy" orderType:0 qty:@1.0 px:@342.99];
            
            expect(order[@"isAccepted"]).to.beTruthy();
            
            NSInteger orderId = [order[@"serverOrderId"] integerValue];
            
            expect([client modifyOrder:@"BTCUSD"    serverOrderId:orderId modifyAction:1][@"isAccepted"]).to.beTruthy();
            expect([client moveOrderToTop:@"BTCUSD" serverOrderId:orderId][@"isAccepted"]).to.beTruthy();
            expect([client executeOrder:@"BTCUSD"   serverOrderId:orderId][@"isAccepted"]).to.beTruthy();
            
            expect([client cancelOrder:@"BTCUSD" serverOrderId:orderId][@"isAccepted"]).to.beTruthy();
        });
    });
    
    describe(@"Withdrawals", ^{
        
        pending(@"Withdraw", ^{
            expect([client withdraw:@"BTC" amount:@1.123456 sendToAddress:@"address"][@"isAccepted"]).to.beTruthy();
        });
    });
});

SpecEnd