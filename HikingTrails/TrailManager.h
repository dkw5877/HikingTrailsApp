//
//  TrailManager.h
//  HikingTrails
//
//  Created by user on 7/7/14.
//  Copyright (c) 2014 someCompanyNameHere. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Trail.h"

@protocol TrailManagerDelegate;

@interface TrailManager : NSObject

@property(nonatomic)NSMutableString* currentString;
@property(nonatomic,weak) id<TrailManagerDelegate>delegate;

- (void)retrieveTrailFiles;

@end

@protocol TrailManagerDelegate <NSObject>

-(void)didFinishParsingXMLFile:(TrailManager*)trailManager forTrail:(Trail*)trail;

@end
