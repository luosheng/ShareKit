//
//  SHKSinaWeibo.m
//  ShareKit
//
//  Created by Vilém Kurz on 11/18/12.
//
//

#import "SHKSinaWeibo.h"
#import "SHKConfiguration.h"

@interface SHKSinaWeibo ()

@end

@implementation SHKSinaWeibo

- (id)init {
	self = [super init];
	if (self) {
		_sinaWeibo = [[SinaWeibo alloc] initWithAppKey:SHKCONFIG(sinaWeiboAppKey) appSecret:SHKCONFIG(sinaWeiboAppSecret) appRedirectURI:SHKCONFIG(sinaWeiboRedirectURI) andDelegate:[self retain]];
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		NSDictionary *sinaweiboInfo = [defaults objectForKey:@"SinaWeiboAuthData"];
		if (sinaweiboInfo[@"AccessTokenKey"] && sinaweiboInfo[@"ExpirationDateKey"] && sinaweiboInfo[@"UserIDKey"]) {
			_sinaWeibo.accessToken = sinaweiboInfo[@"AccessTokenKey"];
			_sinaWeibo.expirationDate = sinaweiboInfo[@"ExpirationDateKey"];
			_sinaWeibo.userID = sinaweiboInfo[@"UserIDKey"];
    }
	}
	return self;
}

#pragma mark -
#pragma mark Configuration : Service Defination

+ (NSString *)sharerTitle
{
	return SHKLocalizedString(@"Sina Weibo", @"Sina Weibo");
}

+ (NSString *)sharerId
{
	return @"SHKSinaWeibo";
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

- (BOOL)isAuthorized {
	return [_sinaWeibo isAuthValid];
}

- (void)promptAuthorization
{
	[_sinaWeibo logIn];
}

+ (void)logout
{
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SinaWeiboAuthData"];
}

- (void)storeAuthData
{
	SinaWeibo *sinaweibo = _sinaWeibo;
	
	NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
														sinaweibo.accessToken, @"AccessTokenKey",
														sinaweibo.expirationDate, @"ExpirationDateKey",
														sinaweibo.userID, @"UserIDKey",
														sinaweibo.refreshToken, @"refresh_token", nil];
	[[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"SinaWeiboAuthData"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)tryToSend {
	if (self.item.shareType == SHKShareTypeImage) {
		[_sinaWeibo requestWithURL:@"statuses/upload.json"
												params:[@{@"status": self.item.title, @"pic": self.item.image} mutableCopy]
										httpMethod:@"POST"
											delegate:self];
	} else if (self.item.shareType == SHKShareTypeText) {
		[_sinaWeibo requestWithURL:@"statuses/update.json"
												params:[@{@"status": self.item.text} mutableCopy]
										httpMethod:@"POST"
											delegate:self];
	} else if (self.item.shareType == SHKShareTypeURL) {
		[_sinaWeibo requestWithURL:@"statuses/update.json"
												params:[@{@"status": [NSString stringWithFormat:@"%@ %@", self.item.title, self.item.URL.absoluteString]} mutableCopy]
										httpMethod:@"POST"
											delegate:self];
	}
	return YES;
}

#pragma mark - SinaWeiboDelegate

- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
	[self storeAuthData];
	[self tryPendingAction];
}

@end
