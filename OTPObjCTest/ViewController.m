//
//  ViewController.m
//  OTPObjCTest
//
//  Created by Mahmoud Alaa on 07/02/2026.
//

#import "ViewController.h"
#import "OTPObjCTest-Swift.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)showOTP:(id)sender {
    
    OTPViewController *otpVC = [[OTPViewController alloc] initWithExpectedCode:@"1234" digitCount: 4];
    
    otpVC.onSuccess = ^{
        NSLog(@"OTP Success!");
    };
    
    otpVC.onError = ^{
        NSLog(@"OTP Error!");
    };
    
    [self presentViewController:otpVC animated:YES completion:nil];
}

@end
