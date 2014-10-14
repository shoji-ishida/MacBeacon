//
//  AppDelegate.m
//  MacBeacon
//
//  Created by 石田 勝嗣 on 2014/01/14.
//  Copyright (c) 2014年 石田 勝嗣. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

NSUserDefaults* userDefaults;

bool changed;

- (IBAction)UUIDField:(id)sender {
    return;
    NSString *str = [self.UUIDField stringValue];
    [userDefaults setObject:(str) forKey:@"uuid"];
    [userDefaults synchronize];
    self.proximityUUID =[[NSUUID alloc]    initWithUUIDString:str];
}

- (IBAction)MajorField:(id)sender {
    return;
    NSLog(@"MajorField updated");
    int i = [self.MajorField intValue];
    [userDefaults setInteger:(i) forKey:@"major"];
    [userDefaults synchronize];
    self.majorID = i;
}

- (IBAction)MinorField:(id)sender {
    return;
    int i = [self.MinorField intValue];
    [userDefaults setInteger:(i) forKey:@"minor"];
    [userDefaults synchronize];
    self.minorID = i;
}

- (IBAction)RSSIField:(id)sender {
    return;
    int i = [self.RSSIField intValue];
    [userDefaults setInteger:(i) forKey:@"rssi"];
    [userDefaults synchronize];
    self.measuredPower = i;
}

- (IBAction)Start:(id)sender {
    NSLog(@"Start pressed");
    [self startAdvertise];
}

- (IBAction)Stop:(id)sender {
    NSLog(@"Stop pressed");
    [self stopAdvertise];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // initialize beacon data from user property here
    userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = @{
                           @"uuid" : @"e2c56db5-dffb-48d2-b060-d0f5a71096e0",
                           @"major": @1,
                           @"minor": @1,
                           @"rssi" : @-55
                           };
    [userDefaults registerDefaults:dict];
    
    self.proximityUUIDStr = [userDefaults objectForKey:@"uuid"];
    self.proximityUUID =[[NSUUID alloc]    initWithUUIDString:self.proximityUUIDStr];

    self.majorID = [userDefaults integerForKey:@"major"];
    self.minorID = [userDefaults integerForKey:@"minor"];
    self.measuredPower = [userDefaults integerForKey:@"rssi"];
    
    [userDefaults synchronize];
    
    changed = false;
    
    // CBPeripheralManagerを初期化
    self.manager = [[CBPeripheralManager alloc]initWithDelegate:self
        queue:nil];
}

-(void)controlTextDidEndEditing:(NSNotification *)notification {
    // validation here
    NSTextField *textField = [notification object];
    NSString *identifier = [textField identifier];
    NSLog(@"didEndEditing %@", identifier);
    
    if (changed) {
        changed = false;
    } else {
        return;
    }
    if ([identifier isEqualToString:@"uuid"]) {
        NSString *str = [textField stringValue];
        [userDefaults setObject:(str) forKey:@"uuid"];
        self.proximityUUID =[[NSUUID alloc]    initWithUUIDString:str];
    } else if ([identifier isEqualToString:@"majorid"]) {
        int i = [textField intValue];
        [userDefaults setInteger:(i) forKey:@"major"];
    } else if ([identifier isEqualToString:@"minorid"]) {
        int i = [textField intValue];
        [userDefaults setInteger:(i) forKey:@"minor"];
    } else if ([identifier isEqualToString:@"rssi"]) {
        int i = [textField intValue];
        [userDefaults setInteger:(i) forKey:@"rssi"];
    }
    [userDefaults synchronize];
    NSLog(@"updated %@", identifier);
    
    // if validated, put start button back to enabled
    [self.StartButton setEnabled:YES];
}

-(void)validateMajorID {
    
}


-(void)controlTextDidBeginEditing:(NSNotification *)notification {
    NSLog(@"didBegineEditing");

    
    // stop advertising while editing
    [self stopAdvertise];
    // disable both start/end buttons until editing fields are validated
    [self.StartButton setEnabled:NO];
    [self.StopButton setEnabled:NO];
}

-(void)controlTextDidChange:(NSNotification *)notification {
    NSLog(@"didChange");
    changed = true;
}

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    // Bluetoothがオンのときにアドバタイズする
    self.peripheral = peripheral;
    if (peripheral.state == CBPeripheralManagerStatePoweredOn) {
        [self startAdvertise];
    }
}

-(void) setAdvertisementData {
    // アドバタイズ用のデータを作成
    self.beaconData
    = [[MBCBeaconAdvertisementData alloc] initWithProximityUUID:self.proximityUUID
                                                          major:self.majorID
                                                          minor:self.minorID
                                                  measuredPower:self.measuredPower];
}

-(void) startAdvertise {
    [self setAdvertisementData];

    [self.StartButton setEnabled:NO];
    [self.StopButton setEnabled:YES];
    if (!self.manager.isAdvertising && self.peripheral.state == CBPeripheralManagerStatePoweredOn) {
        [self.peripheral startAdvertising:self.beaconData.beaconAdvertisement];
    }
}

-(void)stopAdvertise {
    [self.StartButton setEnabled:YES];
    [self.StopButton setEnabled:NO];
    if (self.manager.isAdvertising && self.peripheral.state == CBPeripheralManagerStatePoweredOn) {
        [self.peripheral stopAdvertising];
    }
}

@end
