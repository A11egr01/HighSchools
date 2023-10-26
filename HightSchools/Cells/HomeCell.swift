//
//  HomeCell.swift
//  HightSchools
//
//  Created by Allegro on 10/25/23.
//

import UIKit

class HomeCell: UITableViewCell {
    
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var detailLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    var highSchool: HighSchool!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.shadowColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        backView.shadowOffset = CGSize(width: 0, height: 2.0)
        backView.shadowOpacity = 0.5
        backView.shadowRadius = 5.0
    }
    
    
    func setUpLabels() {
        nameLbl.adjustsFontForContentSizeCategory = true
        detailLbl.adjustsFontForContentSizeCategory = true
        nameLbl.font = .preferredFont(forTextStyle: .headline)
        detailLbl.font = .preferredFont(forTextStyle: .body)
        nameLbl.text = highSchool.school_name
        detailLbl.text = "\(highSchool.state_code)"
        backView.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
