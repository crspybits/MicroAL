//
//  ServiceProviderTableViewCell.h
//  MicroAL
//
//  Created by Christopher Prince on 5/5/16.
//  Copyright © 2016 Spastic Muffin, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MicroAL-Swift.h"

@interface ServiceProviderTableViewCell : UITableViewCell

+ (NSString *) reuseIdentifier;

- (void) configureWith: (ServiceProvider *) managedObject;

@end
