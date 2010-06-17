//
//  SingleViewHostController.h
//  MacSword2
//
//  Created by Manfred Bergmann on 16.06.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CocoLogger/CocoLogger.h>
#import <WindowHostController.h>
#import <Indexer.h>
#import <ObjCSword/SwordModule.h>
#import <ProtocolHelper.h>

#define SINGLEVIEWHOST_NIBNAME   @"SingleViewHost"

@class HostableViewController;
@class SwordModule;
@class SearchTextObject;
@class FileRepresentation;

@interface SingleViewHostController : WindowHostController <NSCoding> {
}

// methods
- (NSView *)contentView;
- (void)setContentView:(NSView *)aView;

// NSCoding
- (id)initWithCoder:(NSCoder *)decoder;
- (void)encodeWithCoder:(NSCoder *)encoder;

@end
