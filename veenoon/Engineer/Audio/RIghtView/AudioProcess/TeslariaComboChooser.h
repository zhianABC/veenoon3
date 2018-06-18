#import <UIKit/UIKit.h>

typedef void (^TeslariaComboChooserBlock)(id object, int index);


@interface TeslariaComboChooser : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableView;
    
    TeslariaComboChooserBlock _block;
    
    NSArray *_dataArray;
    //0:gaotong, 1:ditong
    int _type;
}
@property (nonatomic, copy) TeslariaComboChooserBlock _block;
@property (nonatomic, assign) CGSize _size;
@property (nonatomic, strong) NSArray *_dataArray;
@property (nonatomic, assign) int _type;
@end

