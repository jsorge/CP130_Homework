//
//  JMSCollectionViewController.m
//  CP130_HW4
//
//  Created by Jared Sorge on 4/26/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import "JMSCollectionViewController.h"
#import "JMSCollectionViewCell.h"
#import "JMSBackgroundTask.h"

@interface JMSCollectionViewController ()
@property (strong, nonatomic)NSMutableArray *imageViews;
@property (strong, nonatomic)NSMutableArray *operations;
@property (strong, nonatomic)NSOperationQueue *operationQueue;

@property (weak, nonatomic)IBOutlet UIBarButtonItem *startButton;
@property (weak, nonatomic)IBOutlet UIBarButtonItem *stopButton;
@end

static NSInteger NUMBER_OF_ITEMS = 20;

@implementation JMSCollectionViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadInitialTasks];
}

#pragma mark - Properties
- (NSMutableArray *)operations
{
    if (!_operations) {
        _operations = [NSMutableArray array];
    }
    return _operations;
}

- (NSMutableArray *)imageViews
{
    if (!_imageViews) {
        _imageViews = [NSMutableArray array];
    }
    return _imageViews;
}

- (NSOperationQueue *)operationQueue
{
    if (!_operationQueue) {
        _operationQueue = [[NSOperationQueue alloc] init];
    }
    return _operationQueue;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageViews.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"CosbyCell";
    
    JMSCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID
                                                                           forIndexPath:indexPath];
    
    [cell.contentView addSubview:self.imageViews[indexPath.item]];
    
    return cell;
}

#pragma mark - IBActions
- (IBAction)stopButtonTapped:(id)sender
{
    [self.operationQueue cancelAllOperations];
    
    [self.startButton setEnabled:YES];
    [self.stopButton setEnabled:NO];
}

- (IBAction)startButtonTapped:(id)sender
{
    NSMutableArray *newOperationArray = [NSMutableArray array];
    NSOperationQueue *newQueue = [[NSOperationQueue alloc] init];
    
    for (JMSBackgroundTask *oldOperation in self.operations) {
        JMSBackgroundTask *newOperation = [[JMSBackgroundTask alloc] initWithCosbyImageView:oldOperation.cosbyImageView];
        [newOperationArray addObject:newOperation];
        [newQueue addOperation:newOperation];
    }
    self.operationQueue = newQueue;
    
    [self.startButton setEnabled:NO];
    [self.stopButton setEnabled:YES];
}

#pragma mark - Private
- (void)loadInitialTasks
{
    self.operations = nil;
    for (int i = 0; i < NUMBER_OF_ITEMS; i++) {
        UIImageView *newImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 144, 144)];
        newImageView.contentMode = UIViewContentModeScaleAspectFit;
        JMSBackgroundTask *newTask = [[JMSBackgroundTask alloc] initWithCosbyImageView:newImageView];
        
        self.operations[i] = newTask;
        self.imageViews[i] = newImageView;
        [self.operationQueue addOperation:newTask];
    }
}
@end
