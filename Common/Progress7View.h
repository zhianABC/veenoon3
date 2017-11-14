//
//  Progress7View.h
//  ZhiHui_CR
//
//  Created by jack on 7/11/14.
//
//

#import <UIKit/UIKit.h>

@interface Progress7View : UIView
{
    UIImageView *progressBar;
    UILabel *_progressL;
    
}

- (void) setProgress:(float)value;
- (void) prepare;

- (void) errorFlag;

- (id) initWithProgressBar;
- (void) updateProgressBar:(float) value;

@end
