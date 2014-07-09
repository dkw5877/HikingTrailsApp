//
//  Trail.h
//  HikingTrails
//
//  Created by user on 7/7/14.
//  Copyright (c) 2014 someCompanyNameHere. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Trail : NSObject

@property(nonatomic)NSString* trailName;
@property(nonatomic)NSMutableArray* geopoints;
@property(nonatomic)double elevation;
@property(nonatomic)NSDate* time;

@end
