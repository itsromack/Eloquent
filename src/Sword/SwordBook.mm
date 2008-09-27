/*	SwordBook.mm - Sword API wrapper for GenBooks.

    Copyright 2008 Manfred Bergmann
    Based on code by Will Thimbleby

	This program is free software; you can redistribute it and/or modify it under the terms of the
	GNU General Public License as published by the Free Software Foundation version 2.

	This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without
	even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
	General Public License for more details. (http://www.gnu.org/licenses/gpl.html)
*/

#import "SwordBook.h"
#import "SwordModule.h"
#import "SwordTreeEntry.h"
#import "utils.h"

@interface SwordBook (/* Private, class continuation */)
- (SwordTreeEntry *)loadTreeContentsForKey:(sword::TreeKeyIdx *)treeKey;
@end

@implementation SwordBook

@synthesize contents;

- (id)initWithName:(NSString *)aName swordManager:(SwordManager *)aManager {
    
	self = [super initWithName:aName swordManager:aManager];
    if(self) {
        self.contents = [NSMutableDictionary dictionary];
    }
                         
	return self;
}

/**
 return the tree content for the given treekey
 the treekey has to be on ethat is already loaded
 @param[in]: treekey that we should look for, nil for root
 @return: NSArray for if the treekey is a subtree
 @return: NSString for if the treekey is content
 */
- (SwordTreeEntry *)treeContentForKey:(NSString *)treeKey {
    SwordTreeEntry * ret = nil;
    
    if(treeKey == nil) {
        ret = [contents objectForKey:@"root"];
        if(ret == nil) {
            sword::TreeKeyIdx *treeKey = dynamic_cast<sword::TreeKeyIdx*>((sword::SWKey *)*(swModule));
            ret = [self loadTreeContentsForKey:treeKey];
            // add to content
            [contents setObject:ret forKey:@"root"];
        }
    } else {
        ret = [contents objectForKey:treeKey];
        if(ret == nil) {
            const char *keyStr = [treeKey UTF8String];
            sword::TreeKeyIdx *key = new sword::TreeKeyIdx(keyStr);
            ret = [self loadTreeContentsForKey:key];
            // add to content
            [contents setObject:ret forKey:treeKey];
        }
    }
    
    return ret;
}

// fill tree content with keys of book
- (SwordTreeEntry *)loadTreeContentsForKey:(sword::TreeKeyIdx *)treeKey {
    SwordTreeEntry *ret = [[SwordTreeEntry alloc] init];    
    
	char *treeNodeName = (char *)treeKey->getText();
	NSString *name = @"";
    
    // key encoding depends on module encoding
	if([self isUnicode]) {
		name = [NSString stringWithUTF8String:treeNodeName];
	} else {
		name = [NSString stringWithCString:treeNodeName encoding:NSISOLatin1StringEncoding];
	}
    // set name
    ret.key = name;
	
    // if this node has children, walk them
	if(treeKey->hasChildren()) {
		NSMutableArray *c = [NSMutableArray array];
        // get first child
		treeKey->firstChild();		
        // walk the subtree
        if(treeKey->hasChildren()) {
            do {
                NSString *subname = @"";
                // key encoding depends on module encoding
                const char *textStr = treeKey->getText();
                if([self isUnicode]) {
                    subname = [NSString stringWithUTF8String:textStr];
                } else {
                    subname = [NSString stringWithCString:textStr encoding:NSISOLatin1StringEncoding];
                }
                [c addObject:subname];
            }
            while(treeKey->nextSibling());            
        }
        // set content
        ret.content = c;
	}
	
	return ret;
}

#pragma mark - SwordModuleAccess

- (long)entryCount {
    return [contents count];
}

- (NSArray *)stripedTextForRef:(NSString *)reference {
	return [super stripedTextForRef:[reference uppercaseString]];    
}

- (NSArray *)renderedTextForRef:(NSString *)reference {
    return [super renderedTextForRef:reference];
}

- (void)writeEntry:(NSString *)value forRef:(NSString *)reference {
    [super writeEntry:value forRef:reference];
}

@end
