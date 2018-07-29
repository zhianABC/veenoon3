//
//  CustomImagePickerCtrlor.m
//  Untitled
//
//  Created by mac on 10-5-17.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CustomImagePickerCtrlor.h"


@implementation CustomImagePickerCtrlor

@synthesize cdelegate=_cdelegate;


//rewrite the init function
-(id)initWithSourceType:(UIImagePickerControllerSourceType)sType maskView:(UIView*)maskView delegate:(id)dele
{
	if( (self=[super init]) )
	{
		super.delegate = self;
		self.cdelegate = dele;
        
		if(![UIImagePickerController isSourceTypeAvailable:sType])
		{
			sType = UIImagePickerControllerSourceTypePhotoLibrary;
		}
		self.sourceType = sType;
        
		
		if(sType == UIImagePickerControllerSourceTypeCamera)
		{
			self.showsCameraControls = NO;
		}
        
        
        
	}
	
	return self;
}

- (void) takeAction{
    [self takePicture];
}

- (void) flipCamera{
    
    if(self.cameraDevice == UIImagePickerControllerCameraDeviceFront)
    {
        self.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    }
    else
    {
        self.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    }
    
}

//rewrite the init function
-(id)initWithSourceType:(UIImagePickerControllerSourceType)sType maskImage:(UIImage*)maskImage maskOrigion:(CGPoint)origion delegate:(id)dele
{
	if( (self=[super init]) )
	{
		super.delegate = self;
		self.cdelegate = dele;
		
		if(![UIImagePickerController isSourceTypeAvailable:sType])
		{
			sType = UIImagePickerControllerSourceTypePhotoLibrary;
		}
		self.sourceType = sType;
		
		if(1/*sType == UIImagePickerControllerSourceTypeCamera*/)
		{
			UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(origion.x, origion.y, maskImage.size.width, maskImage.size.height)];
			maskView.backgroundColor = [UIColor clearColor];
			maskView.userInteractionEnabled = NO;
			[[maskView layer] setContents:(id)[maskImage CGImage]];
			
			self.cameraOverlayView = maskView;
		}
	}
	
	return self;
}

- (void)dealloc
{
   // [super dealloc];
}




#pragma mark -
#pragma mark delegate function for UIImagePickerController
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	if(self.cdelegate &&[(NSObject*)self.cdelegate respondsToSelector:@selector(customImagePickerController:didFinishPickingMediaWithInfo:)])
	{
		[self.cdelegate customImagePickerController:self didFinishPickingMediaWithInfo:info];
	}
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if(self.cdelegate &&[(NSObject*)self.cdelegate respondsToSelector:@selector(customImagePickerControllerDidCancel:)])
	{
		[self.cdelegate customImagePickerControllerDidCancel:self];
	}
}

//
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
//    NSLog(@"OK");
//    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
//}
//- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration

@end
