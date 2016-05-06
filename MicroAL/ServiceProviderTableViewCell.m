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
@property (strong, nonatomic) ServiceProvider *serviceProvider;
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

- (void) configureWith: (ServiceProvider *) managedObject;
{
    self.serviceProvider = managedObject;
}

- (void) layoutSubviews;
{
    [super layoutSubviews];
    // NSLog(@"managedObject.name: %@", managedObject.name);
    NSLog(@"self.name: %@", self.name);
    self.name.text = self.serviceProvider.name;
    
    NSString *reviews = [NSString stringWithFormat:@"%@ Recent Reviews", [self.serviceProvider.reviewCount stringValue]];
    self.numberOfReviews.text = reviews;
    
    NSString *address = [NSString stringWithFormat:@"%@, %@ %@", self.serviceProvider.city, self.serviceProvider.state, self.serviceProvider.postalCode];
    self.address.text = address;
    
    self.grade.text = self.serviceProvider.overallGrade;
}

@end
