//
//  UserDefaultsKV.m
//  zhucebao
//
//  Created by jack on 2/22/14.
//
//

#import "UserDefaultsKV.h"
#import "NetworkChecker.h"
#import "UILabel+ContentSize.h"

@implementation UserDefaultsKV

+ (void) setRecordMeFlag{
    
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"CFBundle_KV_RecordMe"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

+ (void) clearRecordMeFlag{
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"CFBundle_KV_RecordMe"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL) checkRecordMeFlag{
    
   int r = [[[NSUserDefaults standardUserDefaults] objectForKey:@"CFBundle_KV_RecordMe"] intValue];
    if(r)
    {
        return YES;
    }
    
    return NO;
}

+ (void) saveRegPhone:(NSString*)phone{
    
    [[NSUserDefaults standardUserDefaults] setObject:phone forKey:@"CFBundle_KV_Phone"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString*) getRegPhone{
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"CFBundle_KV_Phone"];
}

+ (void) saveUser:(User*)u{
    
    NSData *archiveCarPriceData = [NSKeyedArchiver archivedDataWithRootObject:u];
    [[NSUserDefaults standardUserDefaults] setObject:archiveCarPriceData forKey:@"CFBundle_KV_USER"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
+ (User*)getUser{
   
    NSData *myEncodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:@"CFBundle_KV_USER"];
    if(myEncodedObject == nil)
        return nil;
    User *u = [NSKeyedUnarchiver unarchiveObjectWithData:myEncodedObject];
    
    return u;
}
+ (void) clearUser{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CFBundle_KV_USER"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void) saveUserPwd:(NSString*)pwd{
    
    [[NSUserDefaults standardUserDefaults] setObject:pwd forKey:@"CFBundle_KV_Password"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

+ (NSString *) getUserPwd{
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"CFBundle_KV_Password"];
}

+ (int) networkCheckStatus{
    
    NetworkStatus status = [[NetworkChecker sharedNetworkChecker] networkStatus];
    if(status == NotReachable)
        return 0;
    
    NSString *network = [[NSUserDefaults standardUserDefaults] objectForKey:@"CKEY_Network_setting"];
    if([network isEqualToString:@"Wifi"])
    {
        if(status == ReachableViaWiFi)
            return 1;
    }
    else if([network isEqualToString:@"3G"])
    {
        if(status == ReachableVia3G || status == ReachableViaWiFi || status == ReachableViaWWAN)
            return 1;
    }
    else if([network isEqualToString:@"2G"])
    {
        return 1;
    }
    
    return 2;
}


+ (CGSize) testLabelTextSize:(NSString*)txt frame:(CGRect)frame font:(UIFont*)font{
    
    UILabel *tL = [[UILabel alloc] initWithFrame:frame];
    tL.backgroundColor = [UIColor clearColor];
    tL.font = font;
    tL.text = txt;
    tL.numberOfLines = 0;
    tL.lineBreakMode = NSLineBreakByWordWrapping;
    
    CGSize size = [tL contentSize];
    
    return size;
    
}

+ (NSDictionary *)resultByJsonRoot:(NSDictionary *)ggJSON
{
    //{"Root":{"Node":{"@Verify":"成功","@FeedBackID":"","@FrameID":"","@ContentEncode":"Unicode (UTF-8)","Node":{"@UserID":"1264130","@CompanyID":"1532512","@Token":"2324E67A1C2A043667829D3F01E0F304","@ExpoID":"239","@ExpoNameCn":"2015GMIC全球移动互联网大会","@ExpoNameEn":"2015GMIC"}}}}
    
    NSDictionary *Root = [ggJSON objectForKey:@"Root"];
    if(Root)
    {
        NSDictionary *Node = [Root objectForKey:@"Node"];
        
        return Node;
    }
    
    return nil;
}

@end
