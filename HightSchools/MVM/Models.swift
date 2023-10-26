//
//  Models.swift
//  HightSchools
//
//  Created by Allegro on 10/25/23.
//

import Foundation

struct SatScores: Codable {
    var dbn: String
    var school_name: String
    var num_of_sat_test_takers: String
    var sat_critical_reading_avg_score: String
    var sat_math_avg_score: String
    var sat_writing_avg_score: String
}


struct HighSchool: Codable {
    let dbn: String
    let school_name: String
    let location: String
    let phone_number: String
    let website: String?
    let state_code: String
    let city: String
}


