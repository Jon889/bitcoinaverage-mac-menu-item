//
//  BTCAAppDelegate.h
//  bitcoinaverage
//
//  Created by Jonathan on 10/12/2013.
//  Copyright (c) 2013 Jonathan. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface BTCAAppDelegate : NSObject <NSApplicationDelegate>

@property (weak) IBOutlet NSTextField *tickerTimeStampLabel;
@property (weak) IBOutlet NSTextField *bidLabel;
@property (weak) IBOutlet NSTextField *askLabel;
@property (weak) IBOutlet NSTextField *dayAvelabel;
@property (weak) IBOutlet NSPopUpButton *currency;

@end
