//
//  InAppPurchaseManager.m
//  TimeManagerForIOS4
//
//  Created by juweihua on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InAppPurchaseManager.h"

@implementation InAppPurchaseManager

- (void)requestProUpgradeProductData
{
    NSSet *productIdentifiers = [NSSet setWithObjects: @"com.joycom.tm.iap.gold", @"com.joyqom.tm.iap.gold",nil];
    productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];
    
    // we will release the request object in the delegate callback
}

#pragma mark -
#pragma mark SKProductsRequestDelegate methods

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSArray *products = response.products;
    NSLog(@"--------%d Products, %d invalid products -----------", [products count], [response.invalidProductIdentifiers count]);
//    proUpgradeProduct = [products count] == 1 ? [products objectAtIndex:0] : nil;
    for (SKProduct* p in products)
    {
        NSLog(@"Product title: %@" , p.localizedTitle);
        NSLog(@"Product description: %@" , p.localizedDescription);
        NSLog(@"Product price: %@" , p.price);
        NSLog(@"Product id: %@" , p.productIdentifier);
    }
    
    for (NSString *invalidProductId in response.invalidProductIdentifiers)
    {
        NSLog(@"Invalid product id: %@" , invalidProductId);
    }
    
    // finally release the reqest we alloc/init’ed in requestProUpgradeProductData
//    [productsRequest release];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerProductsFetchedNotification object:self userInfo:nil];
}


@end
