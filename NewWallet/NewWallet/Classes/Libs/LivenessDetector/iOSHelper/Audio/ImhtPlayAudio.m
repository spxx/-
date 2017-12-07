//
//  ImhtPlayAudio.m
//  text
//
//  Created by imht-ios on 14-5-21.
//  Copyright (c) 2014年 ymht. All rights reserved.
//

#import "ImhtPlayAudio.h"
#import <AVFoundation/AVFoundation.h>

@interface ImhtPlayAudio ()

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

@end

@implementation ImhtPlayAudio

+ (id)sharedAudioPlayer
{
    static ImhtPlayAudio *audioPlayer ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        audioPlayer = [[ImhtPlayAudio alloc] init];
    });
    
    return audioPlayer;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        
        
        
    }
    return self;
}

- (void)play
{
    [self.audioPlayer stop];
    [self.audioPlayer play];
//    NSLog(@"播放。 ");
}

- (void)stop
{
    if (self.audioPlayer) {
        [self.audioPlayer stop];
    }
}



- (void)setplayData:(NSData *)data
{
    NSError *error;
    
    if (self.audioPlayer != nil) {
        self.audioPlayer = nil;
    }
    self.audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:&error];
    [self.audioPlayer prepareToPlay];
    
}

- (void)setplayURL:(NSURL *)url{
    NSError *error;
    if (self.audioPlayer != nil) {
        self.audioPlayer = nil;
    }
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    
    [self.audioPlayer prepareToPlay];
}

- (void)playWithFileName:(NSString *)name{
    
    if (name && name.length > 0) {
        NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"mp3"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        [self setplayData:data];
        [self play];
    }
    
}

@end
