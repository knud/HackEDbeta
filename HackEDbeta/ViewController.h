//
//  ViewController.h
//  MPUReporter
//
//  Created by Steven Knudsen on 17/11/06.
//  Copyright © 2017 TechConficio Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParticleSDK/ParticleSDK.h>

@interface ViewController : UIViewController

@property SparkEventHandler shakeHandler;
@property SparkEventHandler heartbeatHandler;
@property (strong) NSTimer *heartbeatTimer;
@property (nonatomic) UIView *mainView;

-(void) resetShaken;
-(void) heartbeatCheck;
-(void) getDevice;

@end

