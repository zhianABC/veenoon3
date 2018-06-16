#import <UIKit/UIKit.h>

typedef void (^XinHaoFaShengQi_ChooserBlock)(id object);


@interface XinHaoFaShengQi_Chooser : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableView;
    
    XinHaoFaShengQi_ChooserBlock _block;
    
    NSArray *_dataArray;
    //0:gaotong, 1:ditong
    int _type;
}
@property (nonatomic, copy) XinHaoFaShengQi_ChooserBlock _block;
@property (nonatomic, assign) CGSize _size;
@property (nonatomic, strong) NSArray *_dataArray;
@property (nonatomic, assign) int _type;
@end
