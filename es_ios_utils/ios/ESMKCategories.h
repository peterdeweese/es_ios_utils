#if IS_IOS

#import <MapKit/MapKit.h>

@interface MKMapView (ESMKCategories)
  -(void)zoomToUS50States;
  -(void)zoomToUS48States;
  -(void)bringOverlayToFront:(id<MKOverlay>)overlay;
@end

#endif //IS_IOS