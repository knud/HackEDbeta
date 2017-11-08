//
//  PhotonManager.h
//  Odin PoC
//
//  Created by Knud S Knudsen on 2017-03-08.
//  Copyright © 2017 TechConficio. All rights reserved.
//

// The PhotonManager provides access to readers available either via
// the Particle Cloud or directly via Bluetooth.
//
//
//
#import <Foundation/Foundation.h>

@interface PhotonManager : NSObject

+ (id)sharedManager;

- (BOOL)isAuthenticated;

/**
 *  Login with existing account credentials to Spark cloud
 *
 *  @param user       User name, must be a valid email address
 *  @param password   Password
 */
-(BOOL)loginWithUser:(NSString *)user
            password:(NSString *)password;

@end
