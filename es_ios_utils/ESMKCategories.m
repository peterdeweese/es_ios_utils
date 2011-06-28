#import "ESMKCategories.h"

@implementation MKMapView (ESMKCategories)

- (void)zoomToUS50States
{
   // 72N180W - 18N64W all 50 states + Puerto Rico + Virgin Islands
   CLLocationCoordinate2D topLeftCoord = CLLocationCoordinate2DMake( 72.0, -180.0 ) ;
   CLLocationCoordinate2D bottomRightCoord = CLLocationCoordinate2DMake( 18.0, -64.0 ) ;
   MKMapPoint topLeftPoint = MKMapPointForCoordinate( topLeftCoord ) ;
   MKMapPoint bottomRightPoint = MKMapPointForCoordinate( bottomRightCoord ) ;
   self.visibleMapRect = MKMapRectMake( topLeftPoint.x, topLeftPoint.y, bottomRightPoint.x - topLeftPoint.x, bottomRightPoint.y - topLeftPoint.y ) ;
}

- (void)zoomToUS48States
{
   // 49N125W - 18N64W continental 48 states + Puerto Rico + Virgin Islands
   CLLocationCoordinate2D topLeftCoord = CLLocationCoordinate2DMake( 49.0, -125.0 ) ;
   CLLocationCoordinate2D bottomRightCoord = CLLocationCoordinate2DMake( 18.0, -64.0 ) ;
   MKMapPoint topLeftPoint = MKMapPointForCoordinate( topLeftCoord ) ;
   MKMapPoint bottomRightPoint = MKMapPointForCoordinate( bottomRightCoord ) ;
   self.visibleMapRect = MKMapRectMake( topLeftPoint.x, topLeftPoint.y, bottomRightPoint.x - topLeftPoint.x, bottomRightPoint.y - topLeftPoint.y ) ;
}

@end
