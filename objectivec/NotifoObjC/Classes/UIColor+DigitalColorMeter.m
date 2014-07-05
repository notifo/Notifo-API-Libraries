//
//  Copyright ELC Technologies 2011. All rights reserved.
//

#import "UIColor+DigitalColorMeter.h"

@implementation UIColor (DigitalColorMeter)

+(UIColor*)colorWithDigitalColorMeterString:(NSString*)digitalColorMeterColorString {

	NSArray *colorComponents = [digitalColorMeterColorString componentsSeparatedByString:@"	"];
	
	float red = [[colorComponents objectAtIndex:0] floatValue]*.01;
	float green = [[colorComponents objectAtIndex:1] floatValue]*.01;
	float blue = [[colorComponents objectAtIndex:2] floatValue]*.01;
	float alpha = 1.0;
	return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end
