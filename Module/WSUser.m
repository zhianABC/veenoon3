//
//  WSUser.m
//  ws
//
//  Created by jack on 1/17/16.
//  Copyright (c) 2016 jack. All rights reserved.
//

#import "WSUser.h"
#import "SBJson4.h"
#import "WaitDialog.h"
#import "UserDefaultsKV.h"
#import "WebClient.h"

@interface WSUser ()
{
    WebClient *_http;
    
    BOOL _isSearching;
    
    WebClient *_query;
    WebClient *_create;
    
    WebClient *_regClient;
    WebClient *_regPToC;
}

@property (nonatomic, strong) UIImage *_cardImg;

@end

@implementation WSUser
@synthesize _company;
@synthesize _cardImg;
@synthesize _potentialDic;
@synthesize _companyId;
@synthesize _recId;
@synthesize _posterSum;
@synthesize _admTicket;

- (id) initWithWBDataDictionary:(NSDictionary*)data{
    
    if(self = [super init])
    {
        
        self.userId = [[data objectForKey:@"id"] intValue];
        
        self.wb_personid = [[data objectForKey:@"@PersonID"] intValue];
        
        NSString *name = @"";
        NSString *company = @"";
        NSString *rank = @"";
        
        name = [data objectForKey:@"@CName"];
        name = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if([name length] == 0)
        {
            name = [data objectForKey:@"@EName"];
        }
        
        company = [data objectForKey:@"@CompanyName"];
        company = [company stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if([company length] == 0)
        {
            company = [data objectForKey:@"@CompanyEName"];
        }
        
        rank = [data objectForKey:@"@Rank"];
        rank = [rank stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if([rank length] == 0)
        {
            rank = [data objectForKey:@"@RankEn"];
        }
        
        
        self.fullname       = name;
        self.realname       = name;
        self.avatarurl      = [data objectForKey:@"@filePhoto"];
        
        self.companyname    = company;
        self.ranktitle      = rank;
        self.url            = [data objectForKey:@"@CompanyWebUrl"];
        
        //        NSString *timeStr = [data objectForKey:@"@ScanTime"];
        //
        //        NSDate *d = nsstringToNSDate(timeStr);
        //        self.ctime = [NSNumber numberWithInteger:[d timeIntervalSince1970]];
        //
    }
    
    
    return self;
}



- (void) updateWithWBDataDictionary:(NSDictionary*)data{
    
    
    NSString *name = @"";
    NSString *company = @"";
    NSString *rank = @"";
    
    name = [data objectForKey:@"@CName"];
    name = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if([name length] == 0)
    {
        name = [data objectForKey:@"@EName"];
    }
    
    company = [data objectForKey:@"@CompanyName"];
    company = [company stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if([company length] == 0)
    {
        company = [data objectForKey:@"@CompanyEName"];
    }
    
    rank = [data objectForKey:@"@Rank"];
    rank = [rank stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if([rank length] == 0)
    {
        rank = [data objectForKey:@"@RankEn"];
    }
    
    
    self.fullname       = name;
    self.realname       = name;
    self.avatarurl      = [data objectForKey:@"@filePhoto"];
    
    self.companyname    = company;
    self.ranktitle      = rank;
    
    self.cellphone      = [data objectForKey:@"@Mobile"];
    self.email          = [data objectForKey:@"@Email"];
    self.address        = [data objectForKey:@"@CompanyAddress"];
    self.telphone       = [data objectForKey:@"@TelCode"];
    self.fax            = [data objectForKey:@"@FaxCode"];
    self.url            = [data objectForKey:@"@CompanyWebUrl"];
    
    if([data objectForKey:@"@fileCard"])
    {
        self.bizcardurl = [data objectForKey:@"@fileCard"];
    }
    
    //    NSString *timeStr = [data objectForKey:@"@ScanTime"];
    //
    //    NSDate *d = nsstringToNSDate(timeStr);
    //    self.ctime = [NSNumber numberWithInteger:[d timeIntervalSince1970]];
    
}

- (id) initWithDictionary:(NSDictionary*)data{
    
    if(self = [super init])
    {
        
        if([data isKindOfClass:[NSDictionary class]])
        {
            if([data objectForKey:@"uid"])
            {
                self.userId = [[data objectForKey:@"uid"] intValue];
            }
            else
            {
                self.userId = [[data objectForKey:@"id"] intValue];
                
            }
            
            
            //        if([data objectForKey:@"uid"])
            //        {
            //            self.userId = [[data objectForKey:@"uid"] intValue];
            //        }
            
            self.fullname       = [data objectForKey:@"fullname"];
            self.realname       = [data objectForKey:@"realname"];
            self.cellphone      = [data objectForKey:@"cellphone"];
            self.email          = [data objectForKey:@"email"];
            self.avatarurl      = [data objectForKey:@"avatarurl"];
            self.address        = [data objectForKey:@"address"];
            
            self.companyname    = [data objectForKey:@"company"];
            self.telphone       = [data objectForKey:@"telephone"];
            self.ranktitle      = [data objectForKey:@"title"];
            
            self.wechat         = [data objectForKey:@"wechat"];
            
            self.bizcardurl     = [data objectForKey:@"bizcardurl"];
            
            self.ctime          = [data objectForKey:@"ctime"];
            
            self.tags           = [data objectForKey:@"tags"];
            
            self.status         = [[data objectForKey:@"status"] intValue];
            
            self.seatno         = [data objectForKey:@"seatno"];
            self.hotel          = [data objectForKey:@"hotel"];
            self.traffic        = [data objectForKey:@"traffic"];
            
            self.cuid           = [[data objectForKey:@"cuid"] intValue];
            
            self.role           = [data objectForKey:@"role"];
            self.url            = [data objectForKey:@"url"];
            
            
            if([data objectForKey:@"app"])
            {
                if([[[data objectForKey:@"app"] objectForKey:@"id"] intValue] == 0)
                {
                    self.source = @"后台录入";
                }
                else
                {
                    self.source = [[data objectForKey:@"app"] objectForKey:@"name"];
                }
            }
            
            
            if([data objectForKey:@"companyid"])
            {
                self.companyid = [[data objectForKey:@"companyid"] intValue];
            }
            else if([data objectForKey:@"orgid"])
            {
                self.companyid = [[data objectForKey:@"orgid"] intValue];
            }
            
            NSString * cname = @"";
            NSDictionary *exhibitor = [data objectForKey:@"exhibitor"];
            if(exhibitor)
            {
                NSDictionary *zh_cn = [exhibitor objectForKey:@"zh-cn"];
                if(zh_cn && [zh_cn objectForKey:@"fullname"])
                {
                    cname = [zh_cn objectForKey:@"fullname"];
                }
                
                if([cname length] == 0)
                {
                    NSDictionary *en = [exhibitor objectForKey:@"en"];
                    if(en && [en objectForKey:@"fullname"])
                    {
                        cname = [en objectForKey:@"fullname"];
                    }
                }
                
                if([cname length])
                {
                    self.companyname = cname;
                }
            }
            
            self.memo           = [data objectForKey:@"memo"];
        }
        
    }
    
    return self;
}

- (void) updateWithDictionary:(NSDictionary*)data{
    
    
    self.fullname       = [data objectForKey:@"fullname"];
    self.realname       = [data objectForKey:@"realname"];
    self.cellphone      = [data objectForKey:@"cellphone"];
    self.email          = [data objectForKey:@"email"];
    self.avatarurl      = [data objectForKey:@"avatarurl"];
    self.address        = [data objectForKey:@"address"];
    
    self.wechat         = [data objectForKey:@"wechat"];
    
    self.companyname    = [data objectForKey:@"company"];
    self.telphone       = [data objectForKey:@"telephone"];
    self.ranktitle      = [data objectForKey:@"title"];
    
    self.ctime          = [data objectForKey:@"ctime"];
    
    self.bizcardurl     = [data objectForKey:@"bizcardurl"];
    
    self.status         = [[data objectForKey:@"status"] intValue];
    
    self.tags           = [data objectForKey:@"tags"];
    
    self.memo           = [data objectForKey:@"memo"];
    
    self.role           = [data objectForKey:@"role"];
    self.url            = [data objectForKey:@"url"];
    
    if([data objectForKey:@"app"])
    {
        
        if([[[data objectForKey:@"app"] objectForKey:@"id"] intValue] == 0)
        {
            self.source = @"后台录入";
        }
        else
        {
            self.source = [[data objectForKey:@"app"] objectForKey:@"name"];
        }
    }
    
    
}

- (void) postWorkNameCard:(UIImage *)cardImg
{
    
    self._potentialDic = nil;
    
    self._cardImg = cardImg;
    
    if([self.companyname length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"没有设置公司名称"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    
    [self searchByKey:self.companyname];
    
}

- (void) submitRequest
{
    
}

- (void) successAddCard:(NSDictionary *)v{
    
    if(_potentialDic)
    {
        [self potential];
    }
    else
    {
        [[WaitDialog sharedAlertDialog] setTitle:@"已成功提交"];
        [[WaitDialog sharedAlertDialog] animateShow];
    }
    
    
}


- (void) searchByKey:(NSString *)keywords{
    
    
    
}


- (void) pendingData:(NSArray*)list{
    
    
    if([list count] == 0)
    {
        [self okCreate];
    }
    else {
        
        self._company = [list objectAtIndex:0];
        if(_company)
        {
            self._companyId = [NSString stringWithFormat:@"%d", [[_company objectForKey:@"id"] intValue]];
            
        }
        
        
        [self submitRequest];
    }
    
}


- (void) okCreate{
    
    
    
}

- (void) pendingAData:(NSDictionary*)company{
    
    self._company = company;
    if(_company)
    {
        self._companyId = [NSString stringWithFormat:@"%d", [[_company objectForKey:@"id"] intValue]];
    }
    
    [self submitRequest];
}


- (void) addToPotentialExhibitor:(int)companyid{
    
    if(companyid)
    {
        self._companyId = [NSString stringWithFormat:@"%d", companyid];
        
        [self potential];
    }
    else
    {
        if([self.companyname length] == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"没有设置公司名称"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
            [alert show];
            
            return;
        }
        
        [self okCreate];
    }
}


- (void) potential{
    
    int companyid = [_companyId intValue];
    
    if(companyid == 0)
    {
        //[[WaitDialog sharedDialog] endLoading];
        return;
    }
    
    if(_regClient == nil)
    {
        _regClient = [[WebClient alloc] initWithDelegate:self];
    }
    
    _regClient._method = @"/v1/potential/exhibitor";
    _regClient._httpMethod = @"POST";
    
    User *u = [UserDefaultsKV getUser];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  u._authtoken,@"token",
                                  nil];
    
    _regClient._requestParam = param;
    
    int _dogEventId = [[_potentialDic objectForKey:@"eventid"] intValue];
    if(_dogEventId)
    {
        [param setObject:[NSString stringWithFormat:@"%d", _dogEventId] forKey:@"eventid"];
    }
    else
    {
        //[[WaitDialog sharedDialog] endLoading];
        return;
    }
    
    [param setObject:[NSString stringWithFormat:@"%d", self.userId] forKey:@"uid"];
    [param setObject:[NSString stringWithFormat:@"%d", companyid] forKey:@"companyid"];
    
    IMP_BLOCK_SELF(WSUser);
    
    
    [_regClient requestWithSusessBlock:^(id lParam, id rParam) {
        
        NSString *response = lParam;
        // NSLog(@"%@", response);
        
        [[WaitDialog sharedDialog] endLoading];
        
        SBJson4ValueBlock block = ^(id v, BOOL *stop) {
            
            
            if([v isKindOfClass:[NSDictionary class]])
            {
                int code = [[v objectForKey:@"code"] intValue];
                
                if(code == 0)
                {
                    
                    [block_self successRegEvent];
                    //[block_self addExhibitorContact];
                }
                else
                {
                    [[WaitDialog sharedAlertDialog] setTitle:[v objectForKey:@"msg"]];
                    [[WaitDialog sharedAlertDialog] animateShow];
                }
                
                return;
            }
            
            
        };
        
        SBJson4ErrorBlock eh = ^(NSError* err) {
            
            
            
            NSLog(@"OOPS: %@", err);
        };
        
        id parser = [SBJson4Parser multiRootParserWithBlock:block
                                               errorHandler:eh];
        
        id data = [response dataUsingEncoding:NSUTF8StringEncoding];
        [parser parse:data];
        
        
    } FailBlock:^(id lParam, id rParam) {
        
        NSString *response = lParam;
        NSLog(@"%@", response);
        
        [[WaitDialog sharedDialog] endLoading];
    }];
    
}

- (void) addExhibitorContact{
    
    int companyid = [_companyId intValue];
    //    if(_company)
    //    {
    //        NSString *cid = [NSString stringWithFormat:@"%d", [[_company objectForKey:@"id"] intValue]];
    //        companyid = [cid intValue];
    //    }
    
    if(companyid == 0)
    {
        //[[WaitDialog sharedDialog] endLoading];
        return;
    }
    if(_regPToC == nil)
    {
        _regPToC = [[WebClient alloc] initWithDelegate:self];
    }
    
    _regPToC._method = @"/v1/exhibitor/contact/";
    _regPToC._httpMethod = @"POST";
    
    User *u = [UserDefaultsKV getUser];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  u._authtoken,@"token",
                                  nil];
    
    _regPToC._requestParam = param;
    
    
    int _dogEventId = [[_potentialDic objectForKey:@"eventid"] intValue];
    if(_dogEventId)
    {
        [param setObject:[NSString stringWithFormat:@"%d", _dogEventId] forKey:@"eventid"];
    }
    else
    {
        // [[WaitDialog sharedDialog] endLoading];
        return;
    }
    
    
    [param setObject:[NSString stringWithFormat:@"%d", self.userId] forKey:@"uid"];
    [param setObject:[NSString stringWithFormat:@"%d", companyid] forKey:@"companyid"];
    
    [param setObject:@"contactor" forKey:@"role"];
    
    IMP_BLOCK_SELF(WSUser);
    
    
    [_regPToC requestWithSusessBlock:^(id lParam, id rParam) {
        
        NSString *response = lParam;
        // NSLog(@"%@", response);
        
        
        SBJson4ValueBlock block = ^(id v, BOOL *stop) {
            
            
            if([v isKindOfClass:[NSDictionary class]])
            {
                int code = [[v objectForKey:@"code"] intValue];
                
                if(code == 0)
                {
                    [block_self successRegEvent];
                }
                else
                {
                    [[WaitDialog sharedAlertDialog] setTitle:[v objectForKey:@"msg"]];
                    [[WaitDialog sharedAlertDialog] animateShow];
                }
                
                return;
            }
            
            
        };
        
        SBJson4ErrorBlock eh = ^(NSError* err) {
            
            
            
            NSLog(@"OOPS: %@", err);
        };
        
        id parser = [SBJson4Parser multiRootParserWithBlock:block
                                               errorHandler:eh];
        
        id data = [response dataUsingEncoding:NSUTF8StringEncoding];
        [parser parse:data];
        
        
    } FailBlock:^(id lParam, id rParam) {
        
        NSString *response = lParam;
        NSLog(@"%@", response);
        
    }];
}

- (void) successRegEvent{
    
    [[WaitDialog sharedAlertDialog] setTitle:@"成功添加目标展商!"];
    [[WaitDialog sharedAlertDialog] animateShow];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotifySuccessAddPotentialExhibitor"
                                                        object:nil];
    
}

@end
