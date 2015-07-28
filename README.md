# MexbtClient

[![CI Status](http://img.shields.io/travis/Ahimta/MexbtClient.svg?style=flat)](https://travis-ci.org/Ahimta/MexbtClient)
[![Version](https://img.shields.io/cocoapods/v/MexbtClient.svg?style=flat)](http://cocoapods.org/pods/MexbtClient)
[![License](https://img.shields.io/cocoapods/l/MexbtClient.svg?style=flat)](http://cocoapods.org/pods/MexbtClient)
[![Platform](https://img.shields.io/cocoapods/p/MexbtClient.svg?style=flat)](http://cocoapods.org/pods/MexbtClient)

Objective C client library for the meXBT exchange API

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

### Public API
```objective-c
[MexbtClient productPairs];
[MexbtClient ticker:@"BTCMXN"];
[MexbtClient trades:@"BTCMXN" startIndex:-1 count:20];
[MexbtClient tradesByDate:@"BTCMXN" startDate:1416530012 endDate:1416559390];
[MexbtClient orderBook:@"BTCMXN"];
```

### Private API
```objective-c
MexbtClient *client = [[MexbtClient alloc] init];
client.privateKey = @"<YOUR PRIVATE KEY>";
client.publicKey  = @"<YOUR PUBLIC  KEY>";
client.userId     = @"<YOUR USER ID / EMAIL";
client.isSandbox  = YES;

[client createMarketOrder:@"BTCUSD" side:@"buy" qty:@1.0 px:@342.99];
[client createLimitOrder:@"BTCUSD"  side:@"buy" qty:@1.0 px:@342.99];

NSDictionary *order = [client createOrder:@"BTCUSD" side:@"buy" orderType:0 qty:@1.0 px:@342.99];
NSInteger orderId = [order[@"serverOrderId"] integerValue];

[client modifyOrder:@"BTCUSD"    serverOrderId:orderId modifyAction:1];
[client moveOrderToTop:@"BTCUSD" serverOrderId:orderId];
[client executeOrder:@"BTCUSD"   serverOrderId:orderId];

[client cancelOrder:@"BTCUSD" serverOrderId:orderId];
[client cancelAll:@"BTCUSD"];

[client accountInfo];
[client balance];
[client accountTrades:@"BTCUSD" startIndex:-1 count:20];
[client orders];
[client depositAddresses];
[client depositAddress:@"BTC"]
[client withdraw:@"BTC" amount:@1.123456 sendToAddress:@"address"];
```

## Requirements

## Installation

MexbtClient is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "MexbtClient"
```

## Important Notes
1. All functions return `(NSDictionary *)` except for `depositAddress` which returns `(NSString *)`.
2. All functions return `nil` when meXBT API returns with HTTP status code other than `200` or returns non-json or empty response.
3. All functions assume that meXBT API will respond with the expected format as specified in meXBT APIs documentation: 1)[Public API](http://docs.mexbtpublicapi.apiary.io/#reference/mexbt-exchange-data). 2)[Private API](http://docs.mexbtprivateapi.apiary.io/#), otherwise some exceptions will be thrown; please, keep that in mind when you find some unexpcted behavior in your code.

## Author

Abdullah Alansari, ahimta@gmail.com

## License

MexbtClient is available under the MIT license. See the LICENSE file for more info.
