//
//  VideoDVDPlayer.m
//  veenoon
//
//  Created by 安志良 on 2018/3/25.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "VideoDVDPlayer.h"
#import "VeenoonConstatns.h"

@implementation VideoDVDPlayer

@synthesize _com;
@synthesize _ip;
@synthesize _name;
@synthesize _addressStatus;
@synthesize _tanchuStatus;
@synthesize _action;
@synthesize _powerStatus;

- (void) setDVDPlayerData:(NSDictionary*)dvdPlayerData{
    
    self._name = [dvdPlayerData objectForKey:VideoDVDPlayerName];
    self._com = [dvdPlayerData objectForKey:VideoDVDPlayerCom];
    self._ip = [dvdPlayerData objectForKey:VideoDVDPlayerIP];
    self._addressStatus = [dvdPlayerData objectForKey:VideoDVDPlayerAddressStatus];
    self._tanchuStatus = [dvdPlayerData objectForKey:VideoDVDPlayerTanchuStatus];
    self._action = [dvdPlayerData objectForKey:VideoDVDPlayerAction];
    self._powerStatus = [dvdPlayerData objectForKey:VideoDVDPlayerPowerStatus];
    
}
- (NSDictionary *)dvdPlayerData{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (self._com) {
        [dic setObject:self._com forKey:VideoDVDPlayerIP];
    }
    if (self._name) {
        [dic setObject:self._name forKey:VideoDVDPlayerName];
    }
    if (self._ip) {
        [dic setObject:self._ip forKey:VideoDVDPlayerIP];
    }
    if (self._addressStatus) {
        [dic setObject:self._addressStatus forKey:VideoDVDPlayerAddressStatus];
    }
    if (self._tanchuStatus) {
        [dic setObject:self._tanchuStatus forKey:VideoDVDPlayerTanchuStatus];
    }
    if (self._action) {
        [dic setObject:self._action forKey:VideoDVDPlayerAction];
    }
    if (self._powerStatus) {
        [dic setObject:self._powerStatus forKey:VideoDVDPlayerPowerStatus];
    }
    return dic;
}

@end
