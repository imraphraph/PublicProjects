//
//  ViewController.m
//  PygLatin
//
//  Created by Raphael Lim on 10/08/2016.
//  Copyright © 2016 Raphael Lim. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UITextField *userInputTextField;
@property NSMutableArray *userArray;
@property NSString *wordsToBeSplit;
@property NSMutableArray *wordsComparatorArray;
@property NSArray *myVowels;
@property NSArray *myChar;
@property NSString *inputText;
@property int subsequentCharCount;
@property int charIndex;
@property NSArray *wordsArray;
@property int indexCount;
//@property NSArray *characterSet;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userInputTextField.delegate = self;
    self.subsequentCharCount = 0;
    self.userInputTextField.text = @"";
    self.indexCount = 0;
    
    
}

-(void)print: (NSString*)printWords {
    //vowelsComparator keeps throwing words into this function hence adding up the second and subsequent words below.

    self.resultLabel.text = [[self.resultLabel.text stringByAppendingString:printWords] stringByAppendingString:@" "];
    
}



-(void)charsplitter: (NSArray*)charArraysplitter {
    //word selection loop
    
    
    for(self.indexCount = 0; self.indexCount < charArraysplitter.count; self.indexCount++)
        
    {
        self.wordsToBeSplit = charArraysplitter[self.indexCount];
        
        NSMutableArray *characters = [[NSMutableArray alloc] initWithCapacity:[self.wordsToBeSplit length]];
        
        [self.wordsToBeSplit enumerateSubstringsInRange:NSMakeRange(0, self.wordsToBeSplit.length)
                                                options:NSStringEnumerationByComposedCharacterSequences
                                             usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                                 [characters addObject:substring];
                                             }];
        [self vowelsComparator:characters];
    }
    
}
-(void)vowelsComparator: (NSArray*)comparator {
    
    self.myVowels = [NSArray arrayWithObjects: @"a", @"e", @"i", @"o",@"u", nil];
    for(self.charIndex = 0; self.charIndex < comparator.count; self.charIndex++)
        if([self.myVowels containsObject:comparator[0]]){
            //adding the existing words to array
            [self print: self.wordsArray[self.indexCount]];
            return;
        }else{
            //loops to find other vowels
            self.subsequentCharCount = 0;
            while (self.subsequentCharCount < comparator.count){
                if ([self.myVowels containsObject:comparator[self.subsequentCharCount]]){
                    //moving consonants behind vowels.
                    NSString *combinedWords = [[self.wordsToBeSplit substringFromIndex:self.subsequentCharCount]stringByAppendingString:[self.wordsToBeSplit substringToIndex:self.subsequentCharCount]];
                    NSString *completedWord = [combinedWords stringByAppendingString:@"ay"];
                    [self print: completedWord];
                    return;
                }else{
                    
                }
                self.subsequentCharCount++;
            };
        }
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];//resigns the keyboard every time return button is pressed
    return YES;
}
- (IBAction)pygButton:(id)sender
{
    self.resultLabel.text = @"";
    self.inputText = [self.userInputTextField.text lowercaseString];//user input is lowercase
    self.wordsArray = [self.inputText componentsSeparatedByString: @" "]; //separate words into arrays.
    [self charsplitter: self.wordsArray];
}



@end


