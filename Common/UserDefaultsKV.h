//
//  UserDefaultsKV.h
//  zhucebao
//
//  Created by jack on 2/22/14.
//
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "User.h"

@interface UserDefaultsKV : NSObject
+ (void) setRecordMeFlag;
+ (void) clearRecordMeFlag;
+ (BOOL) checkRecordMeFlag;

+ (void) saveRegPhone:(NSString*)phone;
+ (NSString*) getRegPhone;

+ (void) saveUser:(User*)u;
+ (User*)getUser;
+ (void) clearUser;

+ (void) saveUserPwd:(NSString*)pwd;
+ (NSString *) getUserPwd;

+ (int) networkCheckStatus;

+ (NSString *)testiPadUrl:(NSString*)url;

+ (CGSize) testLabelTextSize:(NSString*)txt frame:(CGRect)frame font:(UIFont*)font;

+ (NSDictionary *)resultByJsonRoot:(NSDictionary*)ggJSON;

@end
