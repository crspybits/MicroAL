//
//  ServiceProviderTableViewCell.m
//  MicroAL
//
//  Created by Christopher Prince on 5/5/16.
//  Copyright © 2016 Spastic Muffin, LLC. All rights reserved.
//

#import "ServiceProviderTableViewCell.h"

@interface ServiceProviderTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *numberOfReviews;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *grade;
@end

@implementation ServiceProviderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    NSLog(@"awakeFromNib: self.name: %@", self.name);
}

+ (NSString *) reuseIdentifier;
{
    return @"ServiceProviderTableViewCell";
}

- (void) configureWith: (ServiceProvider *) serviceProvider;
{
    NSLog(@"self.name: %@", self.name);
    self.name.text = serviceProvider.name;
    
    NSString *reviews = [NSString stringWithFormat:@"%@ Recent Reviews", [serviceProvider.reviewCount stringValue]];
    self.numberOfReviews.text = reviews;
    
    NSString *address = [NSString stringWithFormat:@"%@, %@ %@", serviceProvider.city, serviceProvider.state, serviceProvider.postalCode];
    self.address.text = address;
    
    // Some cells have "N/A" and this gives a ... in the label.
    if ([serviceProvider.overallGrade length] <= 1) {
         self.grade.text = serviceProvider.overallGrade;
    }
    else {
        // Leave grade blank if we don't have one or have more than one character.
        self.grade.text = nil;
    }
}

@end
