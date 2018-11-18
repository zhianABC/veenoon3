//
//  AudioEMinMaxProxy.h
//  veenoon
//
//  Created by chen jack on 2018/11/18.
//  Copyright © 2018 jack. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RgsProxyObj;

@interface AudioEMinMaxProxy : NSObject
{
    
}
@property (nonatomic, strong) RgsProxyObj *_rgsProxyObj;

- (int)getMinVolRange;
- (int)getMaxVolRange;
- (int)getVol;
- (BOOL)getMute;

- (void) getCurrentDataState;

- (BOOL) haveProxyCommandLoaded;
- (void) checkRgsProxyCommandLoad:(NSArray*)cmds;
- (void) recoverWithDictionary:(NSArray*)datas;

- (void) syncDeviceDataRealtime;
- (void) updateRealtimeData:(NSDictionary*)data;

- (void) controlDeviceMute:(BOOL)isMute exec:(BOOL)exec;
- (id) generateEventOperation_Mute;

- (void) controlDeviceVol:(int)vol exec:(BOOL)exec;
- (id) generateEventOperation_Vol;


@end
