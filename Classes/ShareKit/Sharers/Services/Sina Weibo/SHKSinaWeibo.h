//
//  SHKSinaWeibo.h
//  ShareKit
//
//  Created by Vilém Kurz on 11/18/12.
//
//

#import "SHKSharer.h"
#import "SinaWeibo.h"

@interface SHKSinaWeibo : SHKSharer <SinaWeiboDelegate, SinaWeiboRequestDelegate> {
	SinaWeibo *_sinaWeibo;
}

@end
