//
//  TodaysStops.h
//  DataWeld
//
//  Created by Johnathan Rossitter on 6/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreView.h"
@interface TodaysStops : CoreView
{
    IBOutlet UITableView *tblData;
    NSMutableArray *rawData;
    NSMutableArray *rawDataDisplay;
    IBOutlet UISearchBar *sbMain;
    NSTimer *searchTimer;
}

@property (nonatomic, strong) IBOutlet UITableView *tblData;
@property (nonatomic,strong) NSMutableArray *rawData;

@property (nonatomic,strong) NSMutableArray *rawDataDisplay;
@property (strong, nonatomic) IBOutlet UISearchBar *sbMain;
@property (nonatomic, strong) NSTimer *searchTimer;


@end
