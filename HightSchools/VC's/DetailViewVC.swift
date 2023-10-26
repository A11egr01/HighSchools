//
//  DetailViewVC.swift
//  HightSchools
//
//  Created by Allegro on 10/25/23.
//

import UIKit

class DetailViewVC: UIViewController {
    
    @IBOutlet weak var schoolName: UILabel!
    @IBOutlet weak var num_of_sat_test_takers: UILabel!
    @IBOutlet weak var sat_critical_reading_avg_score: UILabel!
    @IBOutlet weak var sat_math_avg_score: UILabel!
    @IBOutlet weak var sat_writing_avg_score: UILabel!
    
    var scores: SatScores
    
    init(scores: SatScores) {
        self.scores = scores
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLabels()
    }
    
    func setUpLabels() {
        self.schoolName.text = "\n" + scores.school_name + "\n"
        self.schoolName.backgroundColor = systemColor
        self.schoolName.textColor = .white
        self.schoolName.layer.cornerRadius = 5
        self.schoolName.clipsToBounds = true
        
        let attributedText = NSMutableAttributedString(string: "Num of SAT Test Takers: " + scores.num_of_sat_test_takers)
        let range = (attributedText.string as NSString).range(of: scores.num_of_sat_test_takers)
        attributedText.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 18), range: range)
        self.num_of_sat_test_takers.attributedText = attributedText

        self.sat_critical_reading_avg_score.attributedText = returnAttributedText(regularText: "SAT Critical Reading Avg. Score: ", bold: scores.sat_critical_reading_avg_score)
        self.sat_math_avg_score.attributedText = returnAttributedText(regularText: "SAT Math Avg. Score: ", bold: scores.sat_math_avg_score)
        self.sat_writing_avg_score.attributedText = returnAttributedText(regularText: "SAT Writing Avg. Score: ", bold: scores.sat_writing_avg_score)


    }
    
    func returnAttributedText(regularText: String, bold: String) -> NSMutableAttributedString {
        let attributedText = NSMutableAttributedString(string: regularText + bold)
        let range = (attributedText.string as NSString).range(of: bold)
        attributedText.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 18), range: range)
        return attributedText
    }

}
