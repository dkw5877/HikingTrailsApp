//
//  TrailManager.m
//  HikingTrails
//
//  Created by user on 7/7/14.
//  Copyright (c) 2014 someCompanyNameHere. All rights reserved.
//

#import "TrailManager.h"
#import <CoreLocation/CoreLocation.h>

@interface TrailManager()< NSXMLParserDelegate >

@property(nonatomic,readwrite)NSArray* trails;
@property(nonatomic)NSMutableArray* trailData;
@property(nonatomic)NSMutableArray* trailGeoPoints;
@property(nonatomic)Trail* currentTrail;
@property(nonatomic)BOOL storingCharacters;
@end

@implementation TrailManager

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.trailGeoPoints= [NSMutableArray new];
    }
    return self;
}


- (void)loadTrailData:(NSURL*)url
{
    NSXMLParser* parser = [[NSXMLParser alloc]initWithContentsOfURL:url];
    parser.delegate = self;
    [parser parse];
}


- (void)retrieveTrailFiles
{
    NSBundle* bundle = [NSBundle mainBundle];
    NSArray* resources = [bundle URLsForResourcesWithExtension:@"gpx" subdirectory:nil];
    
    for (NSURL* url in resources)
    {
        [self loadTrailData: url];
    }
}


#pragma mark - NSXMLParserDelegate Methods
static NSString* kTrail = @"trk";
static NSString* kName = @"name";
static NSString* kTrackPoint = @"trkpt";
static NSString* kElevation = @"ele";
static NSString* kTime = @"time";
static NSString* kLatitude = @"lat";
static NSString* kLongtitude = @"lon";


- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    [self.delegate didFinishParsingXMLFile:self forTrail:self.currentTrail];
}

/*
 * Sent by a parser object to its delegate when it encounters a start tag for a given element.
 */
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    //create a new trail object
    if ([elementName isEqualToString:kTrail])
    {
        self.currentTrail = [[Trail alloc]init];
    }
    else if([elementName isEqualToString:kTrackPoint])
    {
        double lat = [attributeDict[kLatitude]doubleValue];
        double lon = [attributeDict[kLongtitude] doubleValue];
        CLLocation* coordinate = [[CLLocation alloc]initWithLatitude:lat longitude:lon];
        [self.currentTrail.geopoints addObject:coordinate];
        //println("coor lat:\(corrdinate.latitude) long:\(corrdinate.longitude)")
    }
    else if ([elementName isEqualToString:kName] || [elementName isEqualToString:kElevation] ||
             [elementName isEqualToString:kTime])
    {
        self.currentString = [[NSMutableString alloc]init];
    }
    self.storingCharacters = YES;
}

/*
 *
 */
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    //NSLog(@"didEndElement elementName %@",elementName);
    if ([elementName isEqualToString:kName])
    {
        self.currentTrail.trailName = self.currentString;
    }
    else if ([elementName isEqualToString:kTrackPoint])
    {
        //do nothing
    }
    else if ([elementName isEqualToString:kTime])
    {
        
    }
    self.storingCharacters = NO;
}

/*
 * The parser object may send the delegate several parser:foundCharacters: messages to report the characters of an element. Because string may be only part of the total character content for the current element, you should append it to the current accumulation of characters until the element changes.
 */
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (self.storingCharacters)
    {
        [self.currentString appendString:string];
    }
    
}

@end
