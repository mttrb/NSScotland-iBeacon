//
//  BLCAppDelegate.m
//  PyroBLE
//
//  Created by Matthew Robinson on 14/09/13.
//  Copyright (c) 2013 Blended Cocoa. All rights reserved.
//

#import "BLCAppDelegate.h"

#import "PyroManager.h"

@interface BLCAppDelegate ()

@property (strong, nonatomic) PyroManager *pyroManager;

@end

@implementation BLCAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [[NSNotificationCenter defaultCenter] addObserverForName:TemperatureDidUpdateNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note) {
                                                      
                                                      self.temperature.stringValue = note.userInfo[TemperatureKey];
                                                  
                                                  }];
    
    self.pyroManager = [PyroManager new];
}

@end
