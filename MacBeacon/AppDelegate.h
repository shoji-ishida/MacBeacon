//
//  AppDelegate.h
//  MacBeacon
//
//  Created by 石田 勝嗣 on 2014/01/14.
//  Copyright (c) 2014年 石田 勝嗣. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <IOBluetooth/IOBluetooth.h>

#import "MBCBeaconAdvertisementData.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, CBPeripheralManagerDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (strong, nonatomic) CBPeripheralManager *manager;
@property (nonatomic) CBPeripheralManager *peripheral;
@property (nonatomic) MBCBeaconAdvertisementData *beaconData;
@property (weak) IBOutlet NSTextField *UUIDField;
@property (weak) IBOutlet NSTextField *MajorField;
@property (weak) IBOutlet NSTextField *MinorField;
@property (weak) IBOutlet NSTextField *RSSIField;
@property (weak) IBOutlet NSButton *StartButton;
@property (weak) IBOutlet NSButton *StopButton;

@property (nonatomic) int majorID;
@property (nonatomic) int minorID;
@property (nonatomic) int measuredPower;
@property (nonatomic) NSString *proximityUUIDStr;
@property (nonatomic) NSUUID *proximityUUID;

-(void)startAdvertise;
-(void)stopAdvertise;

@end
