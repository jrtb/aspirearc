//
//  CustomScrollLayer.m
//  grandmaskitchen
//
//  Created by jrtb on 6/15/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "CustomScrollLayer.h"


@implementation CustomScrollLayer

@synthesize customPageIndicators;

+(id) nodeWithLayers:(NSArray *)layers widthOffset: (int) widthOffset pageSpriteFrameName:(NSString*)pageSpriteFrameName
{
    return [[self alloc] initWithLayers: layers widthOffset:widthOffset pageSpriteFrameName:pageSpriteFrameName];
}

/*
 * Constructor which provides custom sprites for page indicators
 */
-(id) initWithLayers:(NSArray *)layers widthOffset:(int)widthOffset pageSpriteFrameName:(NSString*)pageSpriteFrameName {
    if(self = [self initWithLayers:layers widthOffset:widthOffset]) {
        self.customPageIndicators = [CCNode node];
        
        // Use default position
        customPageIndicators.position = self.pagesIndicatorPosition;
        
        // Create sprites
        CGFloat n = (CGFloat)self.totalScreens; //< Total points count in CGFloat.
        CGFloat d = 24.0f; //< Distance between points.
        for (int i=0; i < self.totalScreens; ++i)
        {
            CCSprite *pageSprite = [CCSprite spriteWithFile:pageSpriteFrameName];
            pageSprite.position = ccp(d * ( (CGFloat)i - 0.5f*(n-1.0f) ), 0);
            [customPageIndicators addChild:pageSprite];
        }
        
        [self addChild:customPageIndicators];
        
        [self schedule:@selector(updatePageIndicators)];
        
        // Hide default page indicators
        self.pagesIndicatorNormalColor = ccc4(0, 0, 0, 0);
        self.pagesIndicatorSelectedColor = ccc4(0, 0, 0, 0);
        
    }
    return self;
}

-(void) setShowPagesIndicator:(BOOL)showPagesIndicator {
    [super setShowPagesIndicator:showPagesIndicator];
    
    // Make sure custom page indicators are hidden
    customPageIndicators.visible = showPagesIndicator;
}

-(void) setPagesIndicatorPosition:(CGPoint)pagesIndicatorPosition {
    [super setPagesIndicatorPosition:pagesIndicatorPosition];
    
    customPageIndicators.position = pagesIndicatorPosition;
}

/*
 * Scheduled method to update position of custom page indicator sprites
 */
-(void) updatePageIndicators {
    customPageIndicators.position = ccp(self.pagesIndicatorPosition.x - self.position.x, self.pagesIndicatorPosition.y);
    
    for(int i=0; i<customPageIndicators.children.count; i++) {
        CCSprite *indicator = [customPageIndicators.children objectAtIndex:i];
        
        // Non-current page are semi-transparent
        if(i == self.currentScreen) {
            [indicator setOpacity:196]; // 255
        }
        else {
            [indicator setOpacity:72]; // 128
        }
    }
}

- (void)dealloc
{
    self.customPageIndicators = nil;
    //[super dealloc];
}

@end