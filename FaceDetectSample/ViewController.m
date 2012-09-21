//
//  ViewController.m
//  FaceDetectSample
//
//  Created by paraches on 11/12/19.
//  Copyright (c) 2011年 paraches lifestyle lab. All rights reserved.
//

#import "ViewController.h"
#import <CoreVideo/CoreVideo.h>
#import <CoreImage/CoreImage.h>

@implementation ViewController
@synthesize photoLibraryButton;
@synthesize imageView;
@synthesize cameraButton;

- (IBAction)unkBtn:(id)sender {
}

- (IBAction)touchSwitch:(id)sender
{
	eyeLine = !eyeLine;
}

+ (CGRect)videoPreviewBoxForGravity:(NSString *)gravity frameSize:(CGSize)frameSize apertureSize:(CGSize)apertureSize
{
    CGFloat apertureRatio = apertureSize.height / apertureSize.width;
    CGFloat viewRatio = frameSize.width / frameSize.height;
    
    CGSize size = CGSizeZero;
	if ([gravity isEqualToString:AVLayerVideoGravityResizeAspect]) {
		if (viewRatio > apertureRatio) {
			size.width = apertureSize.height * (frameSize.height / apertureSize.width);
			size.height = frameSize.height;
		} else {
			size.width = frameSize.width;
			size.height = apertureSize.width * (frameSize.width / apertureSize.height);
		}
	}

	CGRect videoBox;
	videoBox.size = size;
	if (size.width < frameSize.width)
		videoBox.origin.x = (frameSize.width - size.width) / 2;
	else
		videoBox.origin.x = (size.width - frameSize.width) / 2;
	
	if ( size.height < frameSize.height )
		videoBox.origin.y = (frameSize.height - size.height) / 2;
	else
		videoBox.origin.y = (size.height - frameSize.height) / 2;

	return videoBox;
}

//ビデオの上に顔認識した画像を載せるやつかな
/*
- (void)drawFaceBoxesForFeatures:(NSArray *)features forVideoBox:(CGRect)clap
{
//	NSArray *sublayers = [NSArray arrayWithArray:[previewLayer sublayers]];
	NSInteger sublayersCount = [sublayers count], currentSublayer = 0;
	NSInteger featuresCount = [features count];
	NSString *featureLayerName;
	struct CGImage *featureImage;
	if (eyeLine) {
		featureLayerName = @"EyeLineLayer";
		featureImage = [eyeLinePNG CGImage];
	}
	else {
		featureLayerName = @"FaceLayer";
		featureImage = [squarePNG CGImage];
	}

	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
	
	// hide all the face layers
	for ( CALayer *layer in sublayers ) {
		if ( [[layer name] isEqualToString:@"FaceLayer"] || [[layer name] isEqualToString:@"EyeLineLayer"]) {
			layer.hidden = YES;
		}
	}	
	
	if ( featuresCount == 0 ) {
		[CATransaction commit];
		return; // early bail.
	}
	
	CGSize parentFrameSize = [self.view frame].size;
//	NSString *gravity = [previewLayer videoGravity];
	CGRect previewBox = [ViewController videoPreviewBoxForGravity:gravity 
														frameSize:parentFrameSize 
													 apertureSize:clap.size];

	for ( CIFaceFeature *ff in features ) {
		// find the correct position for the square layer within the previewLayer
		// the feature box originates in the bottom left of the video frame.
		// (Bottom right if mirroring is turned on)
		CGRect faceRect = [ff bounds];

		if ( eyeLine && ff.hasLeftEyePosition && ff.hasRightEyePosition) {
			// flip EyePosition
			CGPoint leftEyePosition = CGPointMake(ff.leftEyePosition.y, ff.leftEyePosition.x);
			CGPoint rightEyePosition = CGPointMake(ff.rightEyePosition.y, ff.rightEyePosition.x);

			// make rect for eyeLine
			CGFloat xAdd = (rightEyePosition.x - leftEyePosition.x) / 3.0f;
			CGFloat yAdd = xAdd / 2.0f;
			if (leftEyePosition.y>rightEyePosition.y) {
				faceRect = CGRectMake(leftEyePosition.x - xAdd, rightEyePosition.y - yAdd,
									  rightEyePosition.x - leftEyePosition.x + xAdd * 2.0f,
									  leftEyePosition.y - rightEyePosition.y + yAdd * 2.0f);
			}
			else {
				faceRect = CGRectMake(leftEyePosition.x- xAdd, leftEyePosition.y - yAdd,
									  rightEyePosition.x - leftEyePosition.x + xAdd * 2.0f,
									  rightEyePosition.y - leftEyePosition.y + yAdd * 2.0f);			
			}
		}
		else {
			// flip preview width and height
			CGFloat temp = faceRect.size.width;
			faceRect.size.width = faceRect.size.height;
			faceRect.size.height = temp;
			temp = faceRect.origin.x;
			faceRect.origin.x = faceRect.origin.y;
			faceRect.origin.y = temp;
		}
		
		// scale coordinates so they fit in the preview box, which may be scaled
		CGFloat widthScaleBy = previewBox.size.width / clap.size.height;
		CGFloat heightScaleBy = previewBox.size.height / clap.size.width;
		faceRect.size.width *= widthScaleBy;
		faceRect.size.height *= heightScaleBy;
		faceRect.origin.x *= widthScaleBy;
		faceRect.origin.y *= heightScaleBy;

		CALayer *featureLayer = nil;
		
		// re-use an existing layer if possible
		while ( !featureLayer && (currentSublayer < sublayersCount) ) {
			CALayer *currentLayer = [sublayers objectAtIndex:currentSublayer++];
			if ( [[currentLayer name] isEqualToString:featureLayerName] ) {
				featureLayer = currentLayer;
				[currentLayer setHidden:NO];
			}
		}
		
		// create a new one if necessary
		if ( !featureLayer ) {
			featureLayer = [CALayer new];
			[featureLayer setContents:(__bridge id)featureImage];
			[featureLayer setName:featureLayerName];
			//[previewLayer addSublayer:featureLayer];
		}
		[featureLayer setFrame:faceRect];
	}
	
	[CATransaction commit];
}
 */

//ここでビデオ画像のフレームを取り出して、顔画像オブジェクトを取り出す
/*
- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
	   fromConnection:(AVCaptureConnection *)connection
{
	// got an image
	CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
	CFDictionaryRef attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault, sampleBuffer, kCMAttachmentMode_ShouldPropagate);
	CIImage *ciImage = [[CIImage alloc] initWithCVPixelBuffer:pixelBuffer options:(__bridge NSDictionary *)attachments];
	if (attachments)
		CFRelease(attachments);

	NSDictionary *imageOptions = nil;
	int exifOrientation;

	enum {
		PHOTOS_EXIF_0ROW_TOP_0COL_LEFT			= 1, //   1  =  0th row is at the top, and 0th column is on the left (THE DEFAULT).
		PHOTOS_EXIF_0ROW_TOP_0COL_RIGHT			= 2, //   2  =  0th row is at the top, and 0th column is on the right.  
		PHOTOS_EXIF_0ROW_BOTTOM_0COL_RIGHT      = 3, //   3  =  0th row is at the bottom, and 0th column is on the right.  
		PHOTOS_EXIF_0ROW_BOTTOM_0COL_LEFT       = 4, //   4  =  0th row is at the bottom, and 0th column is on the left.  
		PHOTOS_EXIF_0ROW_LEFT_0COL_TOP          = 5, //   5  =  0th row is on the left, and 0th column is the top.  
		PHOTOS_EXIF_0ROW_RIGHT_0COL_TOP         = 6, //   6  =  0th row is on the right, and 0th column is the top.  
		PHOTOS_EXIF_0ROW_RIGHT_0COL_BOTTOM      = 7, //   7  =  0th row is on the right, and 0th column is the bottom.  
		PHOTOS_EXIF_0ROW_LEFT_0COL_BOTTOM       = 8  //   8  =  0th row is on the left, and 0th column is the bottom.  
	};
	exifOrientation = PHOTOS_EXIF_0ROW_RIGHT_0COL_TOP;

	imageOptions = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:exifOrientation] forKey:CIDetectorImageOrientation];
	NSArray *features = [faceDetector featuresInImage:ciImage options:imageOptions];
	
    // get the clean aperture
    // the clean aperture is a rectangle that defines the portion of the encoded pixel dimensions
    // that represents image data valid for display.
	CMFormatDescriptionRef fdesc = CMSampleBufferGetFormatDescription(sampleBuffer);
	CGRect clap = CMVideoFormatDescriptionGetCleanAperture(fdesc, false originIsTopLeft == false);

//	dispatch_async(dispatch_get_main_queue(), ^(void) {
//		[self drawFaceBoxesForFeatures:features forVideoBox:clap];
//	});
}
*/

//ビデオの呼び出し　セットアップ
/*
- (void)setupAVCapture
{
	AVCaptureSession* captureSession;
	captureSession = [AVCaptureSession new];
	AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
	NSError *error = nil;
	AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
	if ([captureSession canAddInput:deviceInput]) {
		[captureSession addInput:deviceInput];
		[captureSession beginConfiguration];
		captureSession.sessionPreset = AVCaptureSessionPreset640x480;
		[captureSession commitConfiguration];
	}
	
	videoDataOutput = [AVCaptureVideoDataOutput new];
	NSDictionary *rgbOutputSettings = [NSDictionary dictionaryWithObject:
									   [NSNumber numberWithInt:kCMPixelFormat_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
	[videoDataOutput setVideoSettings:rgbOutputSettings];
	[videoDataOutput setAlwaysDiscardsLateVideoFrames:YES];
	videoDataOutputQueue = dispatch_queue_create("VideoDataOutputQueue", DISPATCH_QUEUE_SERIAL);
	[videoDataOutput setSampleBufferDelegate:self queue:videoDataOutputQueue];
	
    if ( [captureSession canAddOutput:videoDataOutput] )
		[captureSession addOutput:videoDataOutput];
	[[videoDataOutput connectionWithMediaType:AVMediaTypeVideo] setEnabled:YES];
	
	previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:captureSession];
	[previewLayer setBackgroundColor:[[UIColor blackColor] CGColor]];
	[previewLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
	CALayer *rootLayer = [previewView layer];
	[rootLayer setMasksToBounds:YES];
	[previewLayer setFrame:[rootLayer bounds]];
	[rootLayer addSublayer:previewLayer];
	[captureSession startRunning];
}
 */

#pragma mark -

//メモリ不足の時に呼び出される　とりあえず無視する
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

//UIの部品をロードし終わったら自動でキックされるメソッド
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    //顔の枠と、目線の画像をロード
	squarePNG = [UIImage imageNamed:@"squarePNG"];
	eyeLinePNG = [UIImage imageNamed:@"eyeLine"];
	
    //ON/OFFスイッチの値を格納している
	eyeLine = faceSwitch.on;

    //顔認識オブジェクトのオプション　　何をしているかは知らん　
	NSDictionary *detectorOptions = [[NSDictionary alloc] initWithObjectsAndKeys:CIDetectorAccuracyLow, CIDetectorAccuracy, nil];
    
    
    
    //顔認識のオブジェクトの初期化
	faceDetector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:detectorOptions];


    // イメージ・ピッカーの作成
    imagePicker = [[UIImagePickerController alloc] init];
    // イメージ・ピッカーのデリゲートを設定
    imagePicker.delegate = self;
    
    // カメラが利用できない機種であれば、カメラのボタンを無効にする
    cameraButton.enabled = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    
    // 写真アルバムが利用できない機種であれば、写真アルバムのボタンを無効にする
    photoLibraryButton.enabled = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
    
    
    
}

- (void)viewDidUnload
{
//    [self setWu44ifnrk:nil];
    [self setImageView:nil];
    [self setPhotoLibraryButton:nil];
    [self setCameraButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/*
- (IBAction)cameraButton:(id)sender {
    

}*/
- (IBAction)openCamera:(id)sender {
    // イメージ・ピッカーのソース・タイプをカメラに設定
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    // イメージ・ピッカーを開く
    [self presentModalViewController:imagePicker animated:YES];
    
}

- (IBAction)openLibrary:(id)sender {
    // イメージ・ピッカーのソース・タイプを写真アルバムに設定
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    // イメージ・ピッカーを開く
    [self presentModalViewController:imagePicker animated:YES];

}

- (IBAction)saveImage:(id)sender {
    //サブビューとマージ
    /*
    //画面上のimageViewの位置
    CGRect rect = CGRectMake(0, 0, imageView.image.size.width, imageView.image.size.height);
    
    UIImageView *mergeView = [[UIImageView alloc] initWithFrame:rect];
    
    UIGraphicsBeginImageContext(imageView.image.size);  
    [imageView.image drawInRect:rect];  
    
    for (UIImageView *view in [imageView subviews]) {
        //目線のviewの位置
        CGRect rect_tmp = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
    
        [view.image drawInRect:rect_tmp blendMode:kCGBlendModeNormal alpha:0.7];  
        
        
    }
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();  
    
    UIGraphicsEndImageContext();      
    [mergeView setImage:resultingImage];    
    */
    // イメージ・ビューの画像を写真アルバムに保存
    UIImageWriteToSavedPhotosAlbum(imageView.image, nil, nil, nil);
}

- (IBAction)clearImage:(id)sender {
    
    //サブビュー削除
    for (UIView *view in [imageView subviews]) {
        [view removeFromSuperview];
    }
    // イメージ・ビューの画像を消去(nilに設定)
    imageView.image = nil;
}


// 写真が撮影・選択された時に呼び出されるメソッド
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //サブビュー削除
    for (UIView *view in [imageView subviews]) {
        [view removeFromSuperview];
    }
    // イメージ・ピッカーを閉じる
    [self dismissModalViewControllerAnimated:YES];

    
    // 撮影画像を取得
    UIImage *originalImage = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];// 撮影した写真をUIImageViewへ設定
    imageView.image = originalImage;
    
    
    // 検出器生成
    NSDictionary *options = [NSDictionary dictionaryWithObject:CIDetectorAccuracyLow forKey:CIDetectorAccuracy];
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:options];
    
    // 検出
    CIImage *ciImage = [[CIImage alloc] initWithCGImage:originalImage.CGImage];
    NSDictionary *imageOptions = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:6] forKey:CIDetectorImageOrientation];
    NSArray *array = [detector featuresInImage:ciImage options:imageOptions];
    
    float widthScale = imageView.frame.size.width / imageView.image.size.width;
    float heightScale = imageView.frame.size.height / imageView.image.size.height;
    
    // 検出されたデータを取得
    for (CIFaceFeature *faceFeature in array) {
        // 眼鏡画像追加処理へ
        [self drawMeganeImage:faceFeature:originalImage:widthScale:heightScale];
    }
    
    
    
    
    /*
     // イメージ・ビューの領域を取得
     CGRect canvasRect = imageView.bounds;
     // グラフィックス・コンテクストを作成
     UIGraphicsBeginImageContext(canvasRect.size);
     // イメージ・ビューの画像を描画
     [imageView.image drawInRect:canvasRect];
     // 写真の画像をブレンド・モードを指定して描画
     [image drawInRect:canvasRect blendMode:kCGBlendModeLighten alpha:1.0];
     // グラフィックス・コンテクストから画像を取得
     UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
     // 取得した画像をイメージ・ビューに設定
     ≈ = newImage;
     // グラフィックス・コンテクストを解放
     UIGraphicsEndImageContext();
     }
*/
}
- (void)drawMeganeImage:(CIFaceFeature *)faceFeature:(UIImage *) originalImage:(float) widthScale:(float) heightScale
{
    if (faceFeature.hasLeftEyePosition && faceFeature.hasRightEyePosition && faceFeature.hasMouthPosition) {
        
        // 顔のサイズ情報を取得
        CGRect faceRect = [faceFeature bounds];
        // 写真の向きで検出されたXとYを逆さにセットする
    /*    float temp = faceRect.size.width;
        faceRect.size.width = faceRect.size.height;
        faceRect.size.height = temp;
        temp = faceRect.origin.x;
        faceRect.origin.x = faceRect.origin.y;
        faceRect.origin.y = temp;
      */  
                
		if ( faceFeature.hasLeftEyePosition && faceFeature.hasRightEyePosition){
			// flip EyePosition
			CGPoint leftEyePosition = CGPointMake(faceFeature.leftEyePosition.y, faceFeature.leftEyePosition.x);
			CGPoint rightEyePosition = CGPointMake(faceFeature.rightEyePosition.y, faceFeature.rightEyePosition.x);
            
			// make rect for eyeLine
			CGFloat xAdd = (rightEyePosition.x - leftEyePosition.x) / 1.5f;
			CGFloat yAdd = xAdd / 2.0f;
			if (leftEyePosition.y>rightEyePosition.y) {
				faceRect = CGRectMake(leftEyePosition.x - xAdd, rightEyePosition.y - yAdd,
									  rightEyePosition.x - leftEyePosition.x + xAdd * 2.0f,
									  leftEyePosition.y - rightEyePosition.y + yAdd * 2.0f);
			}
			else {
				faceRect = CGRectMake(leftEyePosition.x- xAdd, leftEyePosition.y - yAdd,
									  rightEyePosition.x - leftEyePosition.x + xAdd * 2.0f,
									  rightEyePosition.y - leftEyePosition.y + yAdd * 2.0f);			
			}
		}
        
        
        // 比率計算
       // float widthScale = imageView.frame.size.width / imageView.image.size.width;
       // float heightScale = imageView.frame.size.height / imageView.image.size.height;
        // 眼鏡画像のxとy、widthとheightのサイズを比率似合わせて変更
        
        faceRect.origin.x *= widthScale;
        faceRect.origin.y *= heightScale;
        faceRect.size.width *= widthScale;
        faceRect.size.height *= heightScale;
        
        
        // 眼鏡のUIImageViewを作成
        UIImage *glassesImage = [UIImage imageNamed:@"eyeLine"];
        UIImageView *glassesImageView = [[UIImageView alloc]initWithImage:glassesImage];
        glassesImageView.contentMode = UIViewContentModeScaleAspectFit;
         
        // 眼鏡画像のリサイズ
        glassesImageView.frame = faceRect;
         
        // 眼鏡レイヤを撮影した写真に重ねる
        //[imageView addSubview:glassesImageView];
         
        
        
        // イメージ・ビューの領域を取得
        CGRect canvasRect = imageView.bounds;
        // グラフィックス・コンテクストを作成
        UIGraphicsBeginImageContext(canvasRect.size);
        // ベースの画像を描画　イメージ・ビューの画像を描画
        [imageView.image drawInRect:canvasRect];
        
        // ここで画像を重ね合わせている　写真の画像をブレンド・モードを指定して描画
        //[glassesImageView.image drawInRect:canvasRect blendMode:kCGBlendModeLighten alpha:1.0];
        [glassesImageView.image drawInRect:faceRect];
        
        // グラフィックス・コンテクストから画像を取得
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        // 取得した画像をイメージ・ビューに設定
        imageView.image = newImage;
        // グラフィックス・コンテクストを解放
        UIGraphicsEndImageContext();

        
       // imageView=originalImage;
    }
}
@end
