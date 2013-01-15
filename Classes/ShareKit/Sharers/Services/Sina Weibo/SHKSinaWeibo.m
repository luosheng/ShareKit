//
//  SHKSinaWeibo.m
//  ShareKit
//
//  Created by Vilém Kurz on 11/18/12.
//
//

#import "SHKSinaWeibo.h"

@interface SHKSinaWeibo ()

@end

@implementation SHKSinaWeibo

#pragma mark -
#pragma mark Configuration : Service Defination

+ (NSString *)sharerTitle
{
	return SHKLocalizedString(@"Sina Weibo", @"Sina Weibo");
}

+ (NSString *)sharerId
{
	return @"SHKiOSSinaWeibo";
}

+ (BOOL)canShareURL
{
    return YES;
}

+ (BOOL)canShareImage
{
    return YES;
}

+ (BOOL)canShareText
{
    return YES;
}

+ (BOOL)canShare
{
	return YES;
}

@end
