//
//  EngineerPortSettingView.m
//  veenoon
//
//  Created by 安志良 on 2017/12/4.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "EngineerPortSettingView.h"


@interface EngineerPortSettingView () <UITableViewDelegate,UITableViewDataSource> {
    NSMutableArray *_portList;
    NSInteger *_selectedRow;
}
@property (nonatomic, strong) NSMutableArray *_portList;
@property (nonatomic, strong)UITableView *tableView;
@end

@implementation EngineerPortSettingView
@synthesize _portList;

-(void) initDat {
    if (_portList) {
        [_portList removeAllObjects];
    } else {
        NSMutableDictionary *dic1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     @"Com1", @"portNumber",
                                     @"RS-232", @"portType",
                                     @"4800", @"portLv",
                                     @"4", @"digitPosition",
                                     @"PAR_EVEN", @"checkPosition",
                                     @"NONE1", @"stopPosition",
                                     nil];
        NSMutableDictionary *dic2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     @"Com2", @"portNumber",
                                     @"RS-232", @"portType",
                                     @"4800", @"portLv",
                                     @"4", @"digitPosition",
                                     @"PAR_EVEN", @"checkPosition",
                                     @"NONE2", @"stopPosition",
                                     nil];
        self._portList = [NSMutableArray arrayWithObjects:dic1, dic2, nil];
    }
}

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.backgroundColor = [UIColor cyanColor];
        _selectedRow = -1;
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor clearColor];
        [self addSubview:_tableView];
    }
    return self;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_portList count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _selectedRow) {
        return 150;
    }
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    NSMutableDictionary *dic = [self._portList objectAtIndex:indexPath.row];
//
//    int startX =
//
//    UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(40, roomeImageView.frame.size.height-45, 200, 30)];
//    titleL.backgroundColor = [UIColor clearColor];
//    [roomeImageView addSubview:titleL];
//    titleL.font = [UIFont boldSystemFontOfSize:16];
//    titleL.textColor  = [UIColor whiteColor];
//    titleL.text = [dic objectForKey:@"roomname"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
@end
