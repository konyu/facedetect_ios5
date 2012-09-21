//
//  ViewController.h
//  FaceDetectSample
//
//  Created by paraches on 11/12/19.
//  Copyright (c) 2011年 paraches lifestyle lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController
<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate>

{
    UIImagePickerController *imagePicker;   // イメージ・ピッカー
    UIAlertView *saveAlert;                 // 保存確認アラート
    UIAlertView *clearAlert;                // 消去確認アラート

    
	IBOutlet UISwitch *faceSwitch;
	dispatch_queue_t videoDataOutputQueue;
	CIDetector *faceDetector;
	UIImage *squarePNG;
	UIImage *eyeLinePNG;
	BOOL eyeLine;
}
- (IBAction)unkBtn:(id)sender;


- (IBAction)touchSwitch:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cameraButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *photoLibraryButton;


- (IBAction)openCamera:(id)sender;
- (IBAction)openLibrary:(id)sender;
- (IBAction)saveImage:(id)sender;
- (IBAction)clearImage:(id)sender;

@end
