//
//  MyAnnotation.h
//  maps
//
//  Created by johnathan rossitter on 9/13/11.
//  Copyright 2011 Rossitter Consulting L.L.C. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/Mapkit.h>
@interface MyAnnotation : NSObject<MKAnnotation>
{
    CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *subTitle;
    
    MKPinAnnotationView *pinColor;
    
    int locationID;
    UIImage *image;
    int locationType;
    NSString *imgURL;
    
}
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic) MKPinAnnotationView *pinColor;
@property (nonatomic) int locationID;
@property (nonatomic) int locationType;
@property (nonatomic, strong) NSString *imgURL;
@end
