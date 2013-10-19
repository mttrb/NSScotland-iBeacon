//
//  BLCAppDelegate.m
//  Beacon
//
//  Created by Matthew Robinson on 15/09/13.
//  Copyright (c) 2013 Blended Cocoa. All rights reserved.
//

#import "BLCAppDelegate.h"

#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface BLCAppDelegate () <CBPeripheralManagerDelegate>

@property (strong,nonatomic) CBPeripheralManager *peripheralManager;

@end

@implementation BLCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSUUID *proximityUUID = [[NSUUID alloc] initWithUUIDString:@"A6C4C5FA-A8DD-4BA1-B9A8-A240584F02D3"];
    
    CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:proximityUUID
                                                                     major:4
                                                                     minor:4000
                                                                identifier:@"com.blendedcocoa.RBLBeacons"];
    
    NSDictionary *proximityData = [region peripheralDataWithMeasuredPower:nil];
    
    _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self
                                                                 queue:nil];
    
    [_peripheralManager startAdvertising:proximityData];
    
    // Override point for customization after application launch.
    return YES;
}

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    NSLog(@"State: %d", peripheral.state);
}

- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error {
    NSLog(@"Started advertising");
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
