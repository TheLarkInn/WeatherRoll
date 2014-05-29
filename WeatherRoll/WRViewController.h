//
//  WRViewController.h
//  WeatherRoll
//
//  Created by Sean Larkin on 5/28/14.
//  Copyright (c) 2014 SeanLarkin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface WRViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>

@property (strong) NSMutableDictionary* currentWeatherDictionary;
@property (strong) NSMutableDictionary* currentLocationDict;
@property (strong) CLLocationManager *locationManager;

#pragma mark IBOutlets

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIImageView *currentWeatherImageView;
@property (strong, nonatomic) IBOutlet UILabel *currentCityStateLabel;
@property (strong, nonatomic) IBOutlet UILabel *currentHumidityLabel;
@property (strong, nonatomic) IBOutlet UILabel *currentPressureLabel;
@property (strong, nonatomic) IBOutlet UILabel *currentTempratureLabel;
@property (strong, nonatomic) IBOutlet UILabel *currentDescriptionLabel;

@property (strong, nonatomic) IBOutlet UILabel *dayOneLabel;
@property (strong, nonatomic) IBOutlet UILabel *dayTwoLabel;
@property (strong, nonatomic) IBOutlet UILabel *dayThreeLabel;

@property (strong, nonatomic) IBOutlet UIImageView *dayOneImageView;
@property (strong, nonatomic) IBOutlet UIImageView *dayTwoImageView;
@property (strong, nonatomic) IBOutlet UIImageView *dayThreeImageView;

@property (strong, nonatomic) IBOutlet UILabel *dayOneHiLoLabel;
@property (strong, nonatomic) IBOutlet UILabel *dayTwoHiLoLabel;
@property (strong, nonatomic) IBOutlet UILabel *dayThreeHiLoLabel;



@end
