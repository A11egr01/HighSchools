//
//  HighSchoolVC.swift
//  HightSchools
//
//  Created by Allegro on 10/25/23.
//

import UIKit
import Combine

class HighSchoolVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var viewModel: HighSchoolViewModel
    var screenWasLoaded = false
    private var cancellables: Set<AnyCancellable> = []

    @IBOutlet weak var tableView: UITableView!
    
    init(viewModel: HighSchoolViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = systemColor
        self.title = "Schools"
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.view.backgroundColor = systemColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setupTableView()
        fetchData()
    }
    
    func fetchData() {
        LoadingOverlay.shared.showOverlay(view: UIApplication.shared.keyWindow!)

            viewModel.fetchHighSchools()
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print("Error fetching high schools: \(error)")
                    }
                }, receiveValue: { highSchools in
                    print("Fetched \(highSchools.count) high schools")
                    LoadingOverlay.shared.hideOverlayView()

                    self.tableView.reloadData()
                })
                .store(in: &viewModel.cancellables)

            viewModel.fetchSATScores()
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print("Error fetching SAT scores: \(error)")
                    }
                }, receiveValue: { satScores in
                    print("Fetched SAT scores")
                })
                .store(in: &viewModel.cancellables)
        }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if screenWasLoaded == false {
            var animation = AnimationFactory.makeSlideIn(duration: 0.65, delayFactor: 0.05)
            
            
            let animator = Animator(animation: animation)
            animator.animate(cell: cell, at: indexPath, in: tableView)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.screenWasLoaded = true
            }

        }
    }
    
    private func setupTableView() {
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self

        let nib = UINib(nibName: "HomeCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "HomeCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getCountOfHighSchools()
            .sink { count in }
            .store(in: &cancellables)
        return viewModel.highSchools.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: HomeCell! = tableView.dequeueReusableCell(withIdentifier: "HomeCell") as? HomeCell
        cell.highSchool = viewModel.highSchools[indexPath.row]
        cell.setUpLabels()
        cell.selectedBackgroundView = {
            let view = UIView()
            view.backgroundColor = systemColor
            return view
        }()

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dbn = viewModel.highSchools[indexPath.row].dbn
        if let sat = viewModel.findScores(dbn: dbn) {
            let vc = DetailViewVC(scores: sat)
            self.navigationController?.present(vc, animated: true)
        } else {
            GlobalAlert.showAlert(on: self, withTitle: "Oh no!", message: "No school results were found.")
        }
    }
}
