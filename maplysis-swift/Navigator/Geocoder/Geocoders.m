//
//  Geocoders.m
//  maplysis
//
//  Created by Pericles Maravelakis on 15/05/2017.
//	periclesm@cloudfields.net
//	Licensed under Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)
//	https://creativecommons.org/licenses/by-sa/4.0/
//

#import "Geocoders.h"

@implementation Geocoders

#pragma mark - Apple Geocoding

+ (void)AppleReverseGeocoderWithLocationCoordinates:(CLLocation*)location completion:(void (^)(NSString *fAddress))completion
{
	[[CLGeocoder new] reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
		
		if (placemarks.count > 0)
		{
			CLPlacemark *mark = (CLPlacemark*)[placemarks firstObject];
			
			NSMutableString *addressString = [NSMutableString string];
			
			for (NSString *detail in mark.addressDictionary[@"FormattedAddressLines"])
			{
				[addressString appendString:[NSString stringWithFormat:@"%@ ", detail]];
			}
			
			completion (addressString);
		}
		else
			completion(nil);
	}];
}

+ (void)AppleGeocoderWithAddress:(NSString*)address completion:(void (^)(CLLocation *clocation))completion
{
	[[CLGeocoder new] geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {

		if (placemarks.count > 0)
		{
			CLPlacemark *mark = (CLPlacemark*)[placemarks firstObject];
			completion (mark.location);
		}
		else
			completion(nil);
	}];
}

#pragma mark - Google Geocoding

/*!
 * I am doing the simplest Reverse geocoding here.
 * For more complex and analytical Geocoding, check the Google documentation
 * https://developers.google.com/maps/documentation/geocoding/intro#ReverseGeocoding
 *
 * Personal Note: Having its goods and bads, Apple Maps might give a better geocoding than Google on iOS devices.
 * Having said that, I see no reason why not having both tbh ;)
 * Also, let's GCD here :)
 */

+ (void)GoogleReverseGeocoderWithLocationCoordinates:(CLLocation*)location completion:(void (^)(NSString *fAddress))completion
{
	dispatch_queue_t googleRevGeo = dispatch_queue_create("GoogleReverseGeocoder",NULL);
	dispatch_async (googleRevGeo, ^(void) {

		NSString *lat = [@(location.coordinate.latitude) stringValue];
		NSString *lon = [@(location.coordinate.longitude) stringValue];

		NSString *requestURL = [[NSString stringWithFormat: @"https://maps.googleapis.com/maps/api/geocode/json?latlng=%@,%@", lat, lon]
								stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

		NSData *responseData = [NSData dataWithContentsOfURL:[NSURL URLWithString:requestURL]];

		dispatch_async(dispatch_get_main_queue(), ^{

			if (responseData.length > 0)
			{
				NSError *err;
				NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&err];

				if ([[responseDict[@"status"] lowercaseString] isEqualToString:@"ok"])
				{
					NSString *grgAddress = [responseDict[@"results"] firstObject][@"formatted_address"];
					completion(grgAddress);
				}
				else completion(nil);
			}
			else completion(nil);
		});
	});
}

/*!
 * Same simple Geocoding as in Reverse.
 * For more complex and analytical Geocoding, check the Google documentation
 * https://developers.google.com/maps/documentation/geocoding/intro#geocoding
 *
 * GCD again
 */

+ (void)GoogleGeocoderWithAddress:(NSString*)address completion:(void (^)(CLLocation *clocation))completion
{
	dispatch_queue_t googleGeo = dispatch_queue_create("GoogleGeocoder",NULL);
	dispatch_async (googleGeo, ^(void) {
		
		NSString *requestURL = [[NSString stringWithFormat: @"https://maps.googleapis.com/maps/api/geocode/json?address=%@", address]
								stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
		
		NSData *responseData = [NSData dataWithContentsOfURL:[NSURL URLWithString:requestURL]];
		
		dispatch_async(dispatch_get_main_queue(), ^{
			
			if (responseData.length > 0)
			{
				NSError *err;
				NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&err];
				
				if ([[responseDict[@"status"] lowercaseString] isEqualToString:@"ok"])
				{
					NSDictionary *geometry = [responseDict[@"results"] firstObject][@"geometry"][@"location"];
					double latitude = [geometry[@"lat"] doubleValue];
					double longtitude = [geometry[@"lng"] doubleValue];
					
					CLLocation *gglocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longtitude];
					completion(gglocation);
				}
				else completion(nil);
			}
			else completion(nil);
		});
	});
}

@end
