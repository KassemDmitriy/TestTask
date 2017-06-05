//
//  FYWQRReaderViewController.m
//  FindYourWeather
//
//  Created by lemon on 01.06.17.
//  Copyright © 2017 Kassem Dmitriy. All rights reserved.
//

#import "FYWQRReaderViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface FYWQRReaderViewController () <AVCaptureMetadataOutputObjectsDelegate>
@property (weak, nonatomic) IBOutlet UIButton *closeReader;

@property (weak, nonatomic) IBOutlet UIView *cameraView;
@property (weak, nonatomic) IBOutlet UIImageView *focusFrame;

@property (nonatomic) BOOL isReading;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@end

@implementation FYWQRReaderViewController

#pragma mark -
#pragma mark - UIViewController life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadBeepSound];
    
    NSError *error;
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
    _captureSession = [[AVCaptureSession alloc] init];
    [_captureSession addInput:input];
    
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:captureMetadataOutput];
    
    
    
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObjects:
                                                   AVMetadataObjectTypeQRCode, nil]];
    
    
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:self.view.layer.bounds];
    [_cameraView.layer addSublayer:_videoPreviewLayer];
    
    [_captureSession startRunning];

}

#pragma mark -
#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    NSArray *objArray = [NSArray arrayWithObjects:
                         AVMetadataObjectTypeQRCode, nil];
    
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        
    }
    
    for (int i = 0; i < [objArray count]; i++) {
        
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:[objArray objectAtIndex:i]]) {
            
//            NSLog(@"%@",[metadataObj stringValue]);
            
            NSString *scanResult = [metadataObj stringValue];
        
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"scanSucceed" object:scanResult];
            
            
            [self performSelectorOnMainThread:@selector(stopReading)
                                   withObject:nil
                                waitUntilDone:NO];
            
            if (_audioPlayer) {
                [_audioPlayer play];
            }
            
        }
        
    }
    
    
}

#pragma mark -
#pragma mark - Additional methods

- (IBAction)closeScanner:(id)sender {
    
    [self stopReading];
}

- (void)stopReading {
    
    [_captureSession stopRunning];
    _captureSession = nil;
    [_videoPreviewLayer removeFromSuperlayer];
    
    [self dismissViewControllerAnimated:YES
                             completion:nil];
    
}


- (void)loadBeepSound {
    
    NSString *beepFilePath = [[NSBundle mainBundle] pathForResource:@"beep" ofType:@"mp3"];
    NSURL *beepURL = [NSURL URLWithString:beepFilePath];
    NSError *error;
    
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:beepURL error:&error];
    if (error) {
        
        NSLog(@"Could not play beep file.");
        NSLog(@"%@", [error localizedDescription]);
        
    } else {
        
        [_audioPlayer prepareToPlay];
    }
    
}


@end
