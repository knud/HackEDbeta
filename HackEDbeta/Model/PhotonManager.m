//
//  PhotonManager.m
//  HackEDbeta
//
//  Created by Knud S Knudsen on 2017-03-08.
//  Copyright © 2017 TechConficio. All rights reserved.
//

#import <ParticleSDK/ParticleSDK.h>
#import "PhotonManager.h"

@implementation PhotonManager

#pragma mark Singleton Methods

+ (id)sharedManager {
  static PhotonManager *myManager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    myManager = [[self alloc] init];
  });
  return myManager;
}

- (id)init {
  if (self = [super init]) {
    // init things here if needed...
  }
  return self;
}

- (void)dealloc {
  // Should never be called
}

#pragma mark Public Methods

- (BOOL) isAuthenticated {
  return [[SparkCloud sharedInstance] isAuthenticated];
}

- (BOOL) loginWithUser:(NSString *)user password:(NSString *)password {
  __block BOOL loggedIn = NO;
  
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
  NSURLSessionDataTask *task = [[SparkCloud sharedInstance] loginWithUser:user password:password completion:^(NSError *error) {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    if (!error) {
      NSLog(@"Logged in to cloud");
      loggedIn = YES;
    }
    else
      NSLog(@"Wrong credentials or no internet connectivity, please try again");
  }];
  if (task.state == NSURLSessionTaskStateRunning)
    NSLog(@"NSURLSessionTaskStateRunning");
  if (task.state == NSURLSessionTaskStateSuspended)
    NSLog(@"NSURLSessionTaskStateSuspended");
  if (task.state == NSURLSessionTaskStateCanceling)
    NSLog(@"NSURLSessionTaskStateCanceling");
  if (task.state == NSURLSessionTaskStateCompleted)
    NSLog(@"NSURLSessionTaskStateCompleted");

  return loggedIn;
}

@end
