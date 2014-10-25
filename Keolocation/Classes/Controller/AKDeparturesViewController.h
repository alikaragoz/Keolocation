//
//  AKDeparturesViewController.h
//  Keolocation
//
//  Created by Ali Karagoz on 25/10/14.
//
//

@import UIKit;

#import "AKBusStop.h"

@interface AKDeparturesViewController : UITableViewController

@property (readonly, nonatomic, strong) AKBusStop *bustStop;

- (instancetype)initWithBusStop:(AKBusStop *)busStop;

@end
