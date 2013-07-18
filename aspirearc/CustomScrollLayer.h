//
//  CustomScrollLayer.h
//  grandmaskitchen
//
//  Created by jrtb on 6/15/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCScrollLayer.h"

@interface CustomScrollLayer : CCScrollLayer

@property (nonatomic, retain) CCNode *customPageIndicators;

+(id) nodeWithLayers:(NSArray *)layers widthOffset:(int)widthOffset pageSpriteFrameName:(NSString*)pageSpriteFrameName;

-(id) initWithLayers:(NSArray *)layers widthOffset:(int)widthOffset pageSpriteFrameName:(NSString*)pageSpriteFrameName;

@end