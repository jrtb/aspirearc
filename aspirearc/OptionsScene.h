//
//  OptionsLayer.h
//  questions
//
//  Created by jrtb on 7/9/10.
//  Copyright jrtb 2010. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

#import "SoundMenuItem.h"

// Options Layer
@interface OptionsScene : CCLayer
{
	CGSize size;
	
	//NSMutableArray *optionsButtons;
	//NSMutableArray *categories;
	
	CCMenu *optionsMenu;
	
	SoundMenuItem *backButton;
	CCMenu *backMenu;
	
	SoundMenuItem *allCategories;
	SoundMenuItem *category1;
	SoundMenuItem *category2;
	SoundMenuItem *category3;
	
}

// returns a Scene that contains the Options as the only child
+(id) scene;

- (void) backButtonPressed: (id)sender;
- (float) getFontSizeForString :(NSString *)aString :(int)containerHeight :(int)containerWidth;

- (void) allCategoriesPressed: (id)sender;
- (void) category1Pressed: (id)sender;
- (void) category2Pressed: (id)sender;
- (void) category3Pressed: (id)sender;

@end
