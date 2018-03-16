//
//  SettingsViewView.m
//  veenoon
//
//  Created by 安志良 on 2017/11/18.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "SettingsViewView.h"
#import "JCActionView.h"
#import "AppDelegate.h"

@interface SettingsViewView () <UIImagePickerControllerDelegate, UINavigationControllerDelegate,JCActionViewDelegate> {
    UIImageView *desktopImageView;
    UIImageView *userImageView;
    
    UIScrollView *scrollView_;
    
    int _selectIndex;
    
    UIImagePickerController *_imagePicker;
}

@end

@implementation SettingsViewView
@synthesize _ctrl;

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.userInteractionEnabled = YES;
        
        
        int x = (frame.size.width - 400*2 - 20)/2;
        int y = (frame.size.height - 300)/2;
        
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn1.frame = CGRectMake(x, y, 400, 300);
        [self addSubview:btn1];
        btn1.tag = 0;
        [btn1 addTarget:self
                 action:@selector(chooseDesktopImg:)
       forControlEvents:UIControlEventTouchUpInside];
        
        desktopImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"settings_view_1.png"]];
        //desktopImageView.userInteractionEnabled = YES;
        desktopImageView.frame = CGRectMake(0, 0, 400, 300);
        [btn1 addSubview:desktopImageView];
        
        
        
        UILabel* titleL2 = [[UILabel alloc] initWithFrame:CGRectMake(x, y-40, 400, 30)];
        titleL2.backgroundColor = [UIColor clearColor];
        [self addSubview:titleL2];
        titleL2.font = [UIFont systemFontOfSize:16];
        titleL2.textColor  = [UIColor whiteColor];
        titleL2.text = @"桌面壁纸";
        titleL2.textAlignment = NSTextAlignmentCenter;
        
        UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn2.frame = CGRectMake(x+400+20, y, 400, 300);
        [self addSubview:btn2];
        btn2.tag = 1;
        [btn2 addTarget:self
                 action:@selector(chooseUserImg:)
       forControlEvents:UIControlEventTouchUpInside];
        
        userImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"settings_view_2.png"]];
        //userImageView.userInteractionEnabled = YES;
        userImageView.frame = CGRectMake(0, 0, 400, 300);
        [btn2 addSubview:userImageView];
        
        
        UILabel* titleL3 = [[UILabel alloc] initWithFrame:CGRectMake(x+400+20, y-40, 400, 30)];
        titleL3.backgroundColor = [UIColor clearColor];
        [self addSubview:titleL3];
        titleL3.font = [UIFont systemFontOfSize:16];
        titleL3.textColor  = [UIColor whiteColor];
        titleL3.text = @"用户壁纸";
        titleL3.textAlignment = NSTextAlignmentCenter;
        
        
       
    }
    return self;
}

- (void) chooseDesktopImg:(id)sender{
    
    
    UIButton *cameraBtn = (UIButton*) sender;
    _selectIndex = (int) cameraBtn.tag;
    
    [self choosePhoto];
    
}

- (void) chooseUserImg:(id)sender{
    UIButton *cameraBtn = (UIButton*) sender;
    _selectIndex = (int) cameraBtn.tag;
    
    [self choosePhoto];
}

- (void) choosePhoto{
    
    if(_imagePicker == nil)
    {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
        _imagePicker.allowsEditing = NO;
        
    }
    
    [[UINavigationBar appearance] setTintColor:THEME_COLOR];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        JCActionView *jcAction = [[JCActionView alloc] initWithTitles:@[@"直接拍照", @"从相册中选取"]
                                                                frame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        jcAction.delegate_ = self;
        jcAction.tag = 2017;
        
        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [app.window addSubview:jcAction];
        [jcAction animatedShow];
        
    }
    else
    {
        _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self._ctrl presentViewController:_imagePicker animated:YES
                         completion:^{
                             
                         }];
    }
    
}

- (void) didJCActionButtonIndex:(int)index actionView:(UIView*)actionView{
    
    if(index == 0)
    {
        _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self._ctrl presentViewController:_imagePicker animated:YES
                         completion:^{
                         }];
    }
    else if(index == 1)
    {
        _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self._ctrl presentViewController:_imagePicker animated:YES
                         completion:^{
                             
                         }];
    }
    
}


/**** Image Picker Delegates ******/
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if(image)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 耗时的操作
            
            UIImage *img = [self imageWithImage:image scaledToSize:CGSizeMake(800, 800)];
            
            dispatch_async(dispatch_get_main_queue(), ^{
               
                if(_selectIndex == 0)
                    desktopImageView.image = img;
                else
                    userImageView.image = img;
                
            });
        });
    }
    
    
    [_imagePicker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [_imagePicker dismissViewControllerAnimated:YES completion:NULL];
}

- (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    if(image==nil)return nil;
    
    float width = image.size.width;
    float height = image.size.height;
    float x, x1, y1;
    
    if(width > height)
    {
        x1 = width / newSize.height;
        y1 = height / newSize.width;
    }
    else
    {
        x1 = width / newSize.width;
        y1 = height / newSize.height;
    }
    
    x = (x1 > y1) ? x1:y1;
    
    if(x < 1.0)return image;
    
    if(fabs(x-1.0) < 0.0001)return image;
    
    CGSize s = CGSizeMake(width/x,height/x);
    
    
    UIGraphicsBeginImageContext(s);
    [image drawInRect:CGRectMake(0,0,s.width,s.height)];
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}




@end
