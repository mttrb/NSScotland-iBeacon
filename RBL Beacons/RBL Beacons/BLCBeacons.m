//
//  BLCBeacons.m
//  RBL Beacons
//
//  Created by Matthew Robinson on 4/10/13.
//  Copyright (c) 2013 Blended Cocoa. All rights reserved.
//

#import "BLCBeacons.h"

#import <CoreLocation/CoreLocation.h>

@interface BLCBeacons () <CLLocationManagerDelegate>

@property (strong,nonatomic) CLLocationManager *locationManager;

@end

@implementation BLCBeacons

- (id)init {
    self = [super init];
    
    if (self) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        
        if ([CLLocationManager isRangingAvailable]) {
            NSLog(@"Beacon Ranging Available");
            
            NSString *proxUUIDString = @"A6C4C5FA-A8DD-4BA1-B9A8-A240584F02D3";
            
            NSUUID *proximityUUID = [[NSUUID alloc] initWithUUIDString:proxUUIDString];
            
            CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:proximityUUID                                                                                      identifier:@"com.blendedcocoa.RBLBeacons" ];
            
            beaconRegion.notifyEntryStateOnDisplay = YES;
            beaconRegion.notifyOnEntry = NO;
            beaconRegion.notifyOnExit = NO;
            
            [_locationManager startMonitoringForRegion:beaconRegion];
            
        }
    }
    
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    NSLog(@"Entered Region: %@", region);
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    NSLog(@"Exited Region: %@", region);
    
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region{
    if (state == CLRegionStateInside) {
        NSLog(@"Inside Region");
        
        [_locationManager startRangingBeaconsInRegion:(CLBeaconRegion *)region];
    } else {
        NSLog(@"Outside Region");
        
        [_locationManager stopRangingBeaconsInRegion:(CLBeaconRegion *)region];
    }
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    
    NSLog(@"%@", beacons);
}

- (void)locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error {
    NSLog(@"Beacon Ranging Failed");
}

@end
