//
//  BTCAAPIDownloader.h
//  bitcoinaverage
//
//  Created by Jonathan on 11/12/2013.
//  Copyright (c) 2013 Jonathan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BTCAAPIDownloader;
@protocol BTCAAPIDownloaderDelegate <NSObject>
-(void)downloader:(BTCAAPIDownloader *)downloader valueDidUpdate:(NSDictionary *)json;
@end

@interface BTCAAPIDownloader : NSObject
@property (nonatomic, weak) id<BTCAAPIDownloaderDelegate> delegate;
@property (nonatomic) unsigned int updateInterval;
@property (nonatomic, strong) NSString *method;
-(id)initWithMethod:(NSString *)method delegate:(id<BTCAAPIDownloaderDelegate>)delegate updateInterval:(unsigned int)interval;
-(void)updateValueStartRepeating:(BOOL)repeat;
@end
