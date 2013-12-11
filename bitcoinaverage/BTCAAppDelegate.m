//
//  BTCAAppDelegate.m
//  bitcoinaverage
//
//  Created by Jonathan on 10/12/2013.
//  Copyright (c) 2013 Jonathan. All rights reserved.
//

#import "BTCAAppDelegate.h"
#import "BTCAAPIDownloader.h"

@interface BTCAAppDelegate () <BTCAAPIDownloaderDelegate, NSMenuDelegate>
@property (nonatomic, strong) NSStatusItem *item;
@property (nonatomic, strong) BTCAAPIDownloader *downloader;
@property (nonatomic, strong) BTCAAPIDownloader *languageDownloader;
@property (nonatomic) double prevLast;
@property (weak) IBOutlet NSPopover *popover;
@end
@implementation BTCAAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    self.prevLast = -1;

    [self.currency setTarget:self];
    [self.currency setAction:@selector(currencyChanged)];
    [self.currency removeAllItems];
    self.item = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [self.item setTarget:self];
    [self.item setAction:@selector(showWindow)];
    self.downloader = [[BTCAAPIDownloader alloc] initWithMethod:@"ticker/USD" delegate:self updateInterval:45];
    [self.downloader updateValueStartRepeating:YES];
    self.languageDownloader = [[BTCAAPIDownloader alloc] initWithMethod:@"ticker" delegate:self updateInterval:0];
    [self.languageDownloader updateValueStartRepeating:NO];
    
    [NSEvent addGlobalMonitorForEventsMatchingMask:NSLeftMouseDownMask | NSRightMouseDownMask handler:^(NSEvent *e) {
        if (!CGRectContainsPoint([self.popover.contentViewController.view frame], e.locationInWindow)) {
            [self.popover close];
        }
    }];
}
-(void)currencyChanged {
    [self.downloader setMethod:[@"ticker/" stringByAppendingString:[self.currency.selectedItem title]]];
    [self.downloader updateValueStartRepeating:NO];
}
-(void)showWindow {
    if ([self.popover isShown]) {
        [self.popover close];
        return;
    }
    [self.popover showRelativeToRect:CGRectZero ofView:[[[NSApp currentEvent] window] contentView] preferredEdge:NSMinYEdge];
}
-(NSString *)symbolForCurrency {
    NSDictionary *dict = @{@"USD": @"$",
                           @"GBP": @"£",
                           @"EUR": @"€",
                           @"AUD": @"AU$",
                           @"NZD": @"NZ$",
                           @"RUB": @"руб "};
    NSString *key = [self.currency.selectedItem title];
    return dict[key ?: @"USD"] ?: key;
}
-(void)downloader:(BTCAAPIDownloader *)downloader valueDidUpdate:(NSDictionary *)json {
    if ([downloader.method isEqualToString:@"ticker"]) {
        NSMutableArray *t = [[json allKeys] mutableCopy];
        [t removeObject:@"all"];
        if ([t containsObject:@"USD"]) {
            [t removeObject:@"USD"];
            [t insertObject:@"USD" atIndex:0];
            [self.currency addItemsWithTitles:t];
            [self.currency selectItemWithTitle:@"USD"];
        } else {
            [self.currency addItemsWithTitles:t];
        }
        self.languageDownloader = nil;
    } else if ([[downloader method] rangeOfString:@"ticker"].location != NSNotFound) {
        double last = [json[@"last"] doubleValue];
        NSString *rawStr = [NSString stringWithFormat:@"%@%.2f", [self symbolForCurrency], last];
        NSColor *color = [NSColor colorWithRed:0 green:0.5 blue:0 alpha:1];
        if (self.prevLast == -1) {
            color = [NSColor blackColor];
        } else if (last < self.prevLast) {
            color = [NSColor colorWithRed:0.5 green:0 blue:0 alpha:1];
        }
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:rawStr attributes:@{NSForegroundColorAttributeName:color}];
        [self.item setTitle:(NSString *)str];
        [self.tickerTimeStampLabel setStringValue:json[@"timestamp"]];
        [self.bidLabel setStringValue:json[@"bid"]];
        [self.askLabel setStringValue:json[@"ask"]];
        [self.dayAvelabel setStringValue:json[@"24h_avg"]];
        self.prevLast = last;
    }
}

@end
