//
//  ViewController.m
//  MPUReporter
//
//  Created by Steven Knudsen on 17/11/06.
//  Copyright © 2017 TechConficio Inc. All rights reserved.
//

#import "ViewController.h"
#import "PhotonManager.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize mainView;

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  mainView = self.view;
  
  __weak typeof (self) weakSelf = self;
  self.shakeHandler = ^(SparkEvent *event, NSError *error) {
    __strong typeof (self) strongSelf = weakSelf;
    if (!error)
    {
      dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"Got Event %@ with data: %@",event.event,event.data);
        UILabel *movementLabel = [strongSelf.mainView viewWithTag:101];
        [movementLabel setText:@"SHAKEN"];
        [movementLabel setBackgroundColor:[UIColor redColor]];
        [NSTimer scheduledTimerWithTimeInterval:0.95 target:strongSelf selector:@selector(resetShaken) userInfo:nil repeats:NO];
      });
    }
    else
    {
      NSLog(@"Error occured: %@",error.localizedDescription);
    }
  };
  
  self.heartbeatHandler = ^(SparkEvent *event, NSError *error) {
    __strong typeof (self) strongSelf = weakSelf;
    if (!error)
    {
      dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"Got Event %@ with data: %@",event.event,event.data);
        if (strongSelf.heartbeatTimer)
          [strongSelf.heartbeatTimer invalidate];
        UILabel *photonLabel = [strongSelf.mainView viewWithTag:100];
        [photonLabel setBackgroundColor:[UIColor colorWithRed:0.5 green:1.0 blue:0.0 alpha:0.5]];
        strongSelf.heartbeatTimer = [NSTimer scheduledTimerWithTimeInterval:6 target:strongSelf selector:@selector(heartbeatCheck) userInfo:nil repeats:NO];
      });
    }
    else
    {
      NSLog(@"Error occured: %@",error.localizedDescription);
    }
  };
}

-(void)viewDidAppear:(BOOL)animated
{
  // Make sure we are logged into the Particle.io cloud
  if ([[PhotonManager sharedManager] isAuthenticated]) {
    NSLog(@"[ViewController] reader manager authenticated");
  } else {
    NSLog(@"[ViewController] reader manager NOT authenticated");
    [[PhotonManager sharedManager] loginWithUser:@"ksk@ieee.org" password:@"xxxx"];
  }
  if ([[PhotonManager sharedManager] isAuthenticated]) {
    [self getDevice];
  }
}

-(void) resetShaken {
  UILabel *movementLabel = [self.mainView viewWithTag:101];
  [movementLabel setText:@"Still"];
  [movementLabel setBackgroundColor:[UIColor whiteColor]];
  
}

-(void) heartbeatCheck {
  UILabel *photonLabel = [self.view viewWithTag:100];
  [photonLabel setBackgroundColor:[UIColor colorWithRed:1.0 green:0.5 blue:0.0 alpha:0.5]];
}

-(void) getDevice {
  // Find a specific device
  [[SparkCloud sharedInstance] getDevices:^(NSArray *sparkDevices, NSError *error) {
    NSLog(@"%@",sparkDevices.description); // print all devices claimed to user
    
    for (SparkDevice *device in sparkDevices)
    {
      if ([device.name isEqualToString:@"tc_photon_03"]) {
        UILabel *photonLabel = [self.view viewWithTag:100];
        [photonLabel setText:device.name];
        
        // Set the background colour to reflect the connect state
        if (device.connected)
          [photonLabel setBackgroundColor:[UIColor colorWithRed:0.5 green:1.0 blue:0.0 alpha:0.5]];
        else
          [photonLabel setBackgroundColor:[UIColor colorWithRed:1.0 green:0.5 blue:0.0 alpha:0.5]];
        
        // set up a timer to help monitor the Photon's state (connected or not)
        self.heartbeatTimer = [NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(heartbeatCheck) userInfo:nil repeats:NO];
        
        [device subscribeToEventsWithPrefix:@"Shake" handler:self.shakeHandler];
        [device subscribeToEventsWithPrefix:@"heartbeat" handler:self.heartbeatHandler];
      }
    }
  }];
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


@end

