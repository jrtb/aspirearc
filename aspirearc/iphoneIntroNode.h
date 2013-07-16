//
//  iphoneIntroNode.h
//  Tongue
//
//  Created by Ricardo Quesada on 23/09/08.
//  Copyright 2008  Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"

#import <MediaPlayer/MediaPlayer.h>

@interface iphoneIntroNode : CCLayer {
	
	BOOL                    touched;
	CCSprite                *back;

}

@property						BOOL				touched;

+ (id) scene;

@end
