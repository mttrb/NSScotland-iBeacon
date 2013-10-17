//
//  PyroManager.m
//  PyroBLE
//
//  Created by Matthew Robinson on 14/09/13.
//  Copyright (c) 2013 Blended Cocoa. All rights reserved.
//

#import "PyroManager.h"

#ifdef __OSX_PLATFORM__
    #import <IOBluetooth/IOBluetooth.h>
#else
    #import <CoreBluetooth/CoreBluetooth.h>
#endif

NSString *kBLEShieldServiceUUIDString = @"F9266FD7-EF07-45D6-8EB6-BD74F13620F9";
NSString *kBLEShieldCharacteristicRXUUIDString = @"4585C102-7784-40B4-88E1-3CB5C4FD37A3";
NSString *kBLEShieldCharacteristicTXUUIDString = @"E788D73B-E793-4D9E-A608-2F2BAFC59A00";
NSString *kBLEShieldCharacteristicReceiveBufferUUIDString = @"11846C20-6630-11E1-B86C-0800200C9A66";
NSString *kBLEShieldCharacteristicClearReceiveBufferUUIDString = @"DAF75440-6EBA-11E1-B0C4-0800200C9A66";


NSString *TemperatureDidUpdateNotification = @"TemperatureDidUpdateNotification";
NSString *TemperatureKey = @"TemperatureKey";

@interface PyroManager () <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (strong,nonatomic) CBCentralManager *centralManager;
@property (strong,nonatomic) CBPeripheral *bleShield;

@end

@implementation PyroManager

- (id)init {
    self = [super init];
    
    if (self) {
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self
                                                               queue:nil];
        
        CBUUID *bleShieldServiceUUID = [CBUUID UUIDWithString:kBLEShieldServiceUUIDString];
                
        NSLog(@"Starting Scan");
        [_centralManager scanForPeripheralsWithServices:@[ bleShieldServiceUUID ]
                                                options:@{
                                                          CBCentralManagerScanOptionAllowDuplicatesKey: @NO
                                                          }];
        
    }
    
    return self;
}


#pragma mark - CBCentralManagerDelegate Methods

- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary *)advertisementData
                  RSSI:(NSNumber *)RSSI {
    
    if ([advertisementData[CBAdvertisementDataLocalNameKey] isEqualToString:@"BLE-Shield  80535D18"]) {
        NSLog(@"Found %@", peripheral.name);
        
        self.bleShield = peripheral;   // If we don't retain peripheral we can't connect
        
        [self.centralManager connectPeripheral:peripheral
                                       options:@{CBConnectPeripheralOptionNotifyOnDisconnectionKey: @NO}];
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    
    NSLog(@"didConnectPeripheral");
    
    self.bleShield = peripheral;
    self.bleShield.delegate = self;
    [self.bleShield discoverServices:nil];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral
                 error:(NSError *)error {
    NSLog(@"didDisconnectPeripheral");
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral
                 error:(NSError *)error {
    
    NSLog(@"didFailToConnectPeripheral");
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    NSLog(@"centralManagerDidUpdateState: %ld", central.state);
}

#pragma mark - CBPeripheralDelegate Methods

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    NSLog(@"Found Services");
    
    CBUUID *bleServiceUUID = [CBUUID UUIDWithString:kBLEShieldServiceUUIDString];
    
    for(CBService *service in peripheral.services) {
        if ([service.UUID isEqual:bleServiceUUID]) {
            
            [peripheral discoverCharacteristics:nil
                                     forService:service];
            
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service
             error:(NSError *)error {
    NSLog(@"Found Characteristics");
    
    CBUUID *RXUUID = [CBUUID UUIDWithString:kBLEShieldCharacteristicRXUUIDString];
    
    for(CBCharacteristic *characteristic in service.characteristics) {
        NSLog(@"%@", characteristic.UUID);
        
        if ([characteristic.UUID isEqual:RXUUID]) {
            
            [peripheral setNotifyValue:YES
                     forCharacteristic:characteristic];
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic
             error:(NSError *)error {
    
    NSString *value = [[NSString alloc] initWithData:characteristic.value
                                            encoding:NSASCIIStringEncoding];
    
    NSLog(@"%@", value);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TemperatureDidUpdateNotification
                                                        object:nil
                                                      userInfo:@{
                                                                 TemperatureKey: value
                                                                 }];
}



@end
