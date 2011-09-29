#if IS_IOS

#import "ESMKCategories.h"

@implementation MKMapView (ESMKCategories)

-(void)zoomToUS50States
{
   // 72N180W - 18N64W all 50 states + Puerto Rico + Virgin Islands
   CLLocationCoordinate2D topLeftCoord = CLLocationCoordinate2DMake( 72.0, -180.0 );
   CLLocationCoordinate2D bottomRightCoord = CLLocationCoordinate2DMake( 18.0, -64.0 );
   MKMapPoint topLeftPoint = MKMapPointForCoordinate( topLeftCoord );
   MKMapPoint bottomRightPoint = MKMapPointForCoordinate( bottomRightCoord );
   self.visibleMapRect = MKMapRectMake( topLeftPoint.x, topLeftPoint.y, bottomRightPoint.x - topLeftPoint.x, bottomRightPoint.y - topLeftPoint.y );
}

-(void)zoomToUS48States
{
   // 49N125W - 18N64W continental 48 states + Puerto Rico + Virgin Islands
   CLLocationCoordinate2D topLeftCoord = CLLocationCoordinate2DMake( 49.0, -125.0 );
   CLLocationCoordinate2D bottomRightCoord = CLLocationCoordinate2DMake( 18.0, -64.0 );
   MKMapPoint topLeftPoint = MKMapPointForCoordinate( topLeftCoord );
   MKMapPoint bottomRightPoint = MKMapPointForCoordinate( bottomRightCoord );
   self.visibleMapRect = MKMapRectMake( topLeftPoint.x, topLeftPoint.y, bottomRightPoint.x - topLeftPoint.x, bottomRightPoint.y - topLeftPoint.y );
}

-(void)bringOverlayToFront:(id<MKOverlay>)overlay
{
    int i = [self.overlays indexOfObject:overlay];
    if(i != NSNotFound)
        [self exchangeOverlayAtIndex:self.overlays.count-1 withOverlayAtIndex:i];
    else
        NSLog(@"Overlay not found for bringOverlayToFront. %@", overlay);
}

-(CLLocationDistance)convertDistance:(float)distance toLocationDistanceFromView:(UIView*)v
{
    //TODO: I think using MKMetersBetweenMapPoints would make more sense
    CLLocationCoordinate2D a = [self convertPoint:CGPointZero toCoordinateFromView:v];
    CLLocationCoordinate2D b = [self convertPoint:$point(0, distance) toCoordinateFromView:v];
    return b.longitude - a.longitude;
}

@end

#endif //IS_IOS