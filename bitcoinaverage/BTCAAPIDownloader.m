//
//  BTCAAPIDownloader.m
//  bitcoinaverage
//
//  Created by Jonathan on 11/12/2013.
//  Copyright (c) 2013 Jonathan. All rights reserved.
//

#import "BTCAAPIDownloader.h"
@interface BTCAAPIDownloader ()
@property (nonatomic) BOOL isRepeating;
@end
@implementation BTCAAPIDownloader
-(id)initWithMethod:(NSString *)method delegate:(id<BTCAAPIDownloaderDelegate>)delegate updateInterval:(unsigned int)interval {
    if (self = [super init]) {
        self.method = method;
        self.delegate = delegate;
        self.updateInterval = interval;
    }
    return self;
}
-(void)stopRepeating {
    self.isRepeating = NO;
}
-(void)updateValueStartRepeating:(BOOL)repeat {
    if (repeat) {
        if (self.isRepeating) {
            NSLog(@"Is already repeating");
            return;
        }
        self.isRepeating = YES;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *url = [@"https://api.bitcoinaverage.com/" stringByAppendingPathComponent:self.method];
        NSData *jsonStr = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonStr options:0 error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate downloader:self valueDidUpdate:json];
        });
        if (self.isRepeating) {
            sleep(self.updateInterval);
            [self updateValueStartRepeating:NO];
        }
    });
}
@end
