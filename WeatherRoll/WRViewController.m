//
//  WRViewController.m
//  WeatherRoll
//
//  Created by Sean Larkin on 5/28/14.
//  Copyright (c) 2014 SeanLarkin. All rights reserved.
//

#import "WRViewController.h"
#import "AFNetworking.h"

@interface WRViewController ()

@end

static NSString const *WeatherBaseURI = @"http://api.wunderground.com/api/d4fdf2676204981c/forecast/q/";

@implementation WRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// set MapView Delegates
    self.locationManager = [[CLLocationManager alloc] init];
    self.currentLocationDict = [[NSMutableDictionary alloc] init];
    self.locationManager.delegate = self;
    self.mapView.delegate = self;
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.showsUserLocation = YES;
    [self zoomToCurrentLocation:self];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark MapView Delegate

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{

    [self updateCurrentWeatherData];
    [self updateGeoLocationInfo];
    [self updateCurrentWeatherFields];

}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{

    [self.mapView setCenterCoordinate:userLocation.coordinate animated:YES];
    [self updateCurrentWeatherData];
    [self updateGeoLocationInfo];
    [self updateCurrentWeatherFields];

}

#pragma mark Load Weather Data

- (void)fetchWeatherDataFromLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude
{

    NSString *latitudeString = [[NSNumber numberWithDouble:latitude] stringValue];
    NSString *longitudeString = [[NSNumber numberWithDouble:longitude] stringValue];

    NSLog(@"%@,%@",latitudeString, longitudeString);

    NSString *string = [NSString stringWithFormat:@"%@%@,%@.json", WeatherBaseURI, latitudeString, longitudeString];
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];

    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
    // Success: Set the new Weather Dictionary
    {
        self.currentWeatherDictionary = (NSMutableDictionary *)responseObject; //cast just incase

        [self updateCurrentWeatherFields];

        NSLog(@"%@", (NSMutableDictionary *)responseObject);
    }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error)
    // Fail: Give Weather Error:
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Weather"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];

    [operation start];
}


// Convience method - This will be called any time that the map region changes.
- (void)updateCurrentWeatherData
{
    [self fetchWeatherDataFromLatitude:self.mapView.region.center.latitude
                           longitude:self.mapView.region.center.longitude];
}

- (void)updateGeoLocationInfo
{
    NSLog( @"didUpdateLocation!");

    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:self.locationManager.location completionHandler:^(NSArray *placemarks, NSError *error)
    {
        if ([[placemarks firstObject] locality] && [[placemarks firstObject] administrativeArea])
        {
            self.currentLocationDict[@"city"] = [[placemarks firstObject] locality];

            self.currentLocationDict[@"state"] = [[placemarks firstObject] administrativeArea];

            self.currentCityStateLabel.text = [NSString stringWithFormat:@"%@, %@",self.currentLocationDict[@"city"], self.currentLocationDict[@"state"]];

        }
        // NSLog( @"locality is %@ and administrative area is %@", city, administrativeArea );
    }];
}

// Set the fields from the currentWeatherDictionary
- (void)updateCurrentWeatherFields
{
    self.currentHumidityLabel.text = [NSString stringWithFormat:@"Humidity: %@%%",self.currentWeatherDictionary[@"forecast"][@"simpleforecast"][@"forecastday"][0][@"avehumidity"]];

    NSString *highTemp = [NSString stringWithFormat:@"%@°",self.currentWeatherDictionary[@"forecast"][@"simpleforecast"][@"forecastday"][0][@"high"][@"fahrenheit"]];
    NSString *lowTemp = [NSString stringWithFormat:@"%@°",self.currentWeatherDictionary[@"forecast"][@"simpleforecast"][@"forecastday"][0][@"low"][@"fahrenheit"]];

    self.currentTempratureLabel.text = [NSString stringWithFormat:@"High/Low: %@/%@", highTemp ? highTemp : @"", lowTemp ? lowTemp : @""];
    self.currentWeatherImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.currentWeatherDictionary[@"forecast"][@"txt_forecast"][@"forecastday"][0][@"icon_url"]]]];
    self.currentDescriptionLabel.text = [NSString stringWithFormat:@"Now: %@ - Tonight: %@", self.currentWeatherDictionary[@"forecast"][@"txt_forecast"][@"forecastday"][0][@"fcttext"], self.currentWeatherDictionary[@"forecast"][@"txt_forecast"][@"forecastday"][1][@"fcttext"]];


    //set icon images
    self.dayOneImageView.image      = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.currentWeatherDictionary[@"forecast"][@"txt_forecast"][@"forecastday"][0][@"icon_url"]]]];
    self.dayTwoImageView.image      = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.currentWeatherDictionary[@"forecast"][@"txt_forecast"][@"forecastday"][2][@"icon_url"]]]];
    self.dayThreeImageView.image    = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.currentWeatherDictionary[@"forecast"][@"txt_forecast"][@"forecastday"][4][@"icon_url"]]]];

    self.dayOneLabel.text       = [NSString stringWithFormat:@"%@.",
                                   self.currentWeatherDictionary[@"forecast"][@"simpleforecast"][@"forecastday"][1][@"date"][@"weekday_short"]];
    self.dayTwoLabel.text       = [NSString stringWithFormat:@"%@.",
                                   self.currentWeatherDictionary[@"forecast"][@"simpleforecast"][@"forecastday"][2][@"date"][@"weekday_short"]];
    self.dayThreeLabel.text     = [NSString stringWithFormat:@"%@.",
                                   self.currentWeatherDictionary[@"forecast"][@"simpleforecast"][@"forecastday"][3][@"date"][@"weekday_short"]];


    //set hi/lo labels under icons
    self.dayOneHiLoLabel.text = [NSString stringWithFormat:@"%@/%@",
                                 [NSString stringWithFormat:@"%@°",
                                  self.currentWeatherDictionary[@"forecast"][@"simpleforecast"][@"forecastday"][1][@"high"][@"fahrenheit"]],
                                 [NSString stringWithFormat:@"%@°",
                                  self.currentWeatherDictionary[@"forecast"][@"simpleforecast"][@"forecastday"][1][@"low"][@"fahrenheit"]]
                                 ];

    self.dayTwoHiLoLabel.text = [NSString stringWithFormat:@"%@/%@",
                                 [NSString stringWithFormat:@"%@°",
                                  self.currentWeatherDictionary[@"forecast"][@"simpleforecast"][@"forecastday"][2][@"high"][@"fahrenheit"]],
                                 [NSString stringWithFormat:@"%@°",
                                  self.currentWeatherDictionary[@"forecast"][@"simpleforecast"][@"forecastday"][2][@"low"][@"fahrenheit"]]
                                 ];

    self.dayThreeHiLoLabel.text = [NSString stringWithFormat:@"%@/%@",
                                   [NSString stringWithFormat:@"%@°",
                                    self.currentWeatherDictionary[@"forecast"][@"simpleforecast"][@"forecastday"][3][@"high"][@"fahrenheit"]],
                                   [NSString stringWithFormat:@"%@°",
                                    self.currentWeatherDictionary[@"forecast"][@"simpleforecast"][@"forecastday"][3][@"low"][@"fahrenheit"]]
                                   ];

}

#pragma mark IBActions

- (IBAction)zoomToCurrentLocation:(id)sender {

    float spanX = 0.23725;
    float spanY = 0.23725;
    MKCoordinateRegion region;
    region.center.latitude = self.mapView.userLocation.coordinate.latitude;
    region.center.longitude = self.mapView.userLocation.coordinate.longitude;
    region.span.latitudeDelta = spanX;
    region.span.longitudeDelta = spanY;
    [self.mapView setRegion:region animated:YES];

}

- (IBAction)shareWeatherInfo:(id)sender {


    
}



@end
