//
//  Trail.m
//  HikingTrails
//
//  Created by user on 7/7/14.
//  Copyright (c) 2014 someCompanyNameHere. All rights reserved.
//

#import "Trail.h"


@interface Trail()

//@property(nonatomic)CLLocation* trailStart;
//@property(nonatomic)CLLocation* trailStart;

@end

@implementation Trail

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        self.trailName = nil;
        self.geopoints = [NSMutableArray new];
    }
    return self;
}


- (NSString *)description
{
    NSString* description = [NSString stringWithFormat:@"trail:%@ geopoints:%@", self.trailName, self.geopoints];
    return description;
}

@end
