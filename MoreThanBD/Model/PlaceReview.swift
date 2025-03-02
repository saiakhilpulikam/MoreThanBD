//
//  PlaceReview.swift
//  MoreThanBD
//
//  Created by Sai Akhil Pulikam on 7/25/20.
//  Copyright © 2020 Xiaowen Ma. All rights reserved.
//

import UIKit
import CoreLocation

struct Review {
    var placeName: String
    var stars: Int
    var reviewerName: String
    var review: String
    var reviewerId: String
    var images: [String]
    
    static func reviewFrom(dict: [String: Any]) -> Review {
        let name = dict["name"] as? String ?? ""
        let reviewerName = dict["reviewerName"] as? String ?? ""
        let reviewerId = dict["reviewerId"] as? String ?? ""
        let stars = dict["stars"] as? Int ?? 0
        let reviewString = dict["review"] as? String ?? ""
        let images = dict["images"] as? [String] ?? []
        
        let review = Review(placeName: name, stars: stars, reviewerName: reviewerName, review: reviewString, reviewerId: reviewerId, images: images)
        return review
    }
}

struct Place {
    var distanceAway: Double?
    var placeImageString: String?
    var averageRating: Double?
    var name: String?
    var lng: Double?
    var lat: Double?
    var placeId: String?
    var reviews: [Review]?
    static var currentLocation: CLLocation?
    
    static func placeFromDictionary(dict: [String: Any]) -> Place {
        let name = dict["name"] as? String
        let lng = dict["lng"] as? Double ?? 0
        let lat = dict["lat"] as? Double ?? 0
        let placeImageString = dict["placeImage"] as? String
        let placeId = dict["placeId"] as? String
        
        var totalScore: Double = 0
        let reviews = (dict["userreviews"] as? [Any])?.map({ (review) -> Review in
            let rev = Review.reviewFrom(dict: (review as? [String: Any]) ?? [:])
            totalScore += Double(rev.stars)
            return rev
        })
        
        var distanceAway: Double = 0
        
        let averageRating = totalScore / Double((reviews?.count ?? 1))
        
        if let currentLocation = Self.currentLocation,
            let latitude = CLLocationDegrees(exactly: lat),
            let longitude = CLLocationDegrees(exactly: lng) {
            let locationOfPlace = CLLocation(latitude: longitude, longitude: latitude)
            
            let distance = currentLocation.distance(from: locationOfPlace)
            print("Distance... LAT", currentLocation.coordinate.latitude)
            print("Distance... LNG", currentLocation.coordinate.longitude)
            let distanceInMiles = distance * 0.000621371
            distanceAway = distanceInMiles
        }
        

        //print("Distance... ", distanceAway)
        let place = Place(distanceAway: distanceAway, placeImageString: placeImageString, averageRating: averageRating, name: name, lng: lng, lat: lat, placeId: placeId, reviews: reviews)
        return place
    }
}
