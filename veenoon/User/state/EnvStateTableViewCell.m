//
//  EnvStateTableViewCell.m
//  veenoon
//
//  Created by chen jack on 2018/11/4.
//  Copyright © 2018 jack. All rights reserved.
//

#import "EnvStateTableViewCell.h"
#import "RegulusSDK.h"

@interface EnvStateTableViewCell ()
{
    UIImageView *titleIcon;
    UILabel* titleL;
    UILabel* valueL;
}
@property (nonatomic, assign) NSInteger _proxyId;
@end

@implementation EnvStateTableViewCell
@synthesize connection;
@synthesize _proxyId;

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        
        titleIcon = [[UIImageView alloc] init];
        [self.contentView addSubview:titleIcon];
        titleIcon.frame = CGRectMake(30, 12, 20, 20);
        
        self.backgroundColor = [UIColor clearColor];
        
        titleL = [[UILabel alloc] initWithFrame:CGRectMake(60,2,SCREEN_WIDTH/2-110, 40)];
        titleL.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:titleL];
        titleL.font = [UIFont systemFontOfSize:13];
        titleL.textColor  = [UIColor colorWithWhite:1.0 alpha:1];

        valueL = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-192,
                                                                    12,
                                                                    80, 20)];
        valueL.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:valueL];
        valueL.font = [UIFont systemFontOfSize:13];
        valueL.textColor  = [UIColor colorWithWhite:1.0 alpha:1];
        valueL.textAlignment = NSTextAlignmentRight;
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(30, 43,
                                                                  SCREEN_WIDTH-140, 1)];
        line.backgroundColor =  NEW_ER_BUTTON_GRAY_COLOR2;
        [self.contentView addSubview:line];
    }
    
    return self;
    
}

- (void) refreshData
{
    
    IMP_BLOCK_SELF(EnvStateTableViewCell);
    
    [[RegulusSDK sharedRegulusSDK] GetDriverProxys:connection.driver_id completion:^(BOOL result, NSArray *proxys, NSError *error) {
        
        if([proxys count])
        {
            [block_self processReturnProxys:proxys];
        }
        
    }];
    
}

- (void) processReturnProxys:(NSArray*)proxys{
    
    NSString *danwei = nil;
    if([connection.bound_connect_str count])
    {
        NSString *str = [connection.bound_connect_str objectAtIndex:0];
        if([str containsString:@"PM2.5"])
        {
            titleL.text = @"PM2.5";
            danwei = @" μg/m³";
            titleIcon.image = [UIImage imageNamed:@"pm2.5_zhishu.png"];
        }
        else if([str containsString:@"Temperature"])
        {
            titleL.text = @"温度";
            danwei = @" ℃";
            titleIcon.image = [UIImage imageNamed:@"wendu_zhishu.png"];
        }
        else
        {
            titleL.text = @"湿度";
            danwei = @" %";
            titleIcon.image = [UIImage imageNamed:@"shidu_zhishu.png"];
        }
    }
    
    RgsProxyObj *proxy = [proxys objectAtIndex:0];
    self._proxyId = proxy.m_id;
    
    IMP_BLOCK_SELF(EnvStateTableViewCell);
    
    [[RegulusSDK sharedRegulusSDK] GetProxyCurState:proxy.m_id completion:^(BOOL result, NSDictionary *state, NSError *error) {
        
        
        if([state count]) {
            [block_self updateTxt:[[state objectForKey:@"value"] stringByAppendingString:danwei]];
        }
        
    }];
}

- (void) updateTxt:(NSString*)txt{
    
    valueL.text = txt;//;
    
}



- (void) updateValue:(NSDictionary*)val{
    
    id key = [NSNumber numberWithInteger:_proxyId];
    if([val objectForKey:key])
    {
        NSString *danwei = nil;
        if([connection.bound_connect_str count])
        {
            NSString *str = [connection.bound_connect_str objectAtIndex:0];
            if([str containsString:@"PM2.5"])
            {
                titleL.text = @"PM2.5";
                danwei = @" μg/m³";
                titleIcon.image = [UIImage imageNamed:@"pm2.5_zhishu.png"];
            }
            else if([str containsString:@"Temperature"])
            {
                titleL.text = @"温度";
                danwei = @" ℃";
                titleIcon.image = [UIImage imageNamed:@"wendu_zhishu.png"];
            }
            else
            {
                titleL.text = @"湿度";
                danwei = @" %";
                titleIcon.image = [UIImage imageNamed:@"shidu_zhishu.png"];
            }
        }
        NSString *value = [val objectForKey:key];
        valueL.text = [value stringByAppendingString:danwei];
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
