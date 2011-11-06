//
//  MyAudioWindow.m
//  MicInput
//
//  Created by Stefan Popp on 21.10.11.
//  Copyright (c) 2011 http://www.stefanpopp.de/2011/capture-iphone-microphone/ . All rights reserved.
//

#import "MyAudioViewController.h"
#import "AudioProcessor.h"

@implementation MyAudioViewController
@synthesize topLabel;
@synthesize audioSwitch, gainValueLabel, audioProcessor;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setAudioSwitch:nil];
    [self setGainValueLabel:nil];
    [self setTopLabel:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Gain control

// gain factor += 1
- (IBAction)riseGain:(id)sender {
    if (audioProcessor == nil) return;
    [audioProcessor setGain: [audioProcessor getGain]+1.0f];
    [self setGainLabelValue:[audioProcessor getGain]];
}

// gain factor -= 1
- (IBAction)lowerGain:(id)sender {
    if (audioProcessor == nil) return;
    [audioProcessor setGain: [audioProcessor getGain]-1.0f];
    [self setGainLabelValue:[audioProcessor getGain]];
}

#pragma mark AU control

/*
 Switchtes AudioUnit from AudioProcessor on and off.
 Checks if processor exists. If not it will initialized.
 
 Nevermind that indicator and label stuff. I like it a bit fancy ;)
 */
- (IBAction)audioSwitch:(id)sender {
    if (!audioSwitch.on) {
        [self showLabelWithText:@"Stopping AudioUnit"];
        [audioProcessor stop];
        [self showLabelWithText:@"AudioUnit stopped"];
    } else {
        if (audioProcessor == nil) {
            audioProcessor = [[AudioProcessor alloc] init];
        }
        [self showLabelWithText:@"Starting up AudioUnit"];
        [audioProcessor start];
        [self showLabelWithText:@"AudioUnit running"];
    }
    [self performSelector:@selector(showLabelWithText:) withObject:@"" afterDelay:3.5];
}

#pragma mark Labels

// set gain label text value by given float
- (void)setGainLabelValue:(float)gainValue {
    NSString *gain = [NSString stringWithFormat:@"%d", (int)gainValue];
    [gainValueLabel setText:gain];
}

- (void)showLabelWithText:(NSString*)labelText {
    [topLabel setText:labelText];
}

#pragma mark cleanup

- (void)dealloc {
    [audioProcessor release];
    [audioSwitch release];
    [gainValueLabel release];
    [topLabel release];
    [super dealloc];
}
@end
