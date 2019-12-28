//
//  ViewController.swift
//  Automobiles
//
//  Created by Macbook on 26.12.2019.
//  Copyright © 2019 Valentin Shapovalov. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var table: UITableView!
    private var refreshControl: UIRefreshControl?
    
    private var brands: [Brand] = []
    private var models: [Model] = []
    var network = Network()
    
    
    //MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        configureRefreshControl()
        receiveData()
    }
    
    
    //MARK: - TableView & Refreshing customization
    
    /// Make `MainViewController` delegate and datasource of  `table`
    private func setupTableView() {
        table.dataSource = self
        table.delegate = self
    }
    
    /// Inititalization and customization `UIRefreshControl`
    private func configureRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(startUpdate), for: .valueChanged)
        if let refreshControl = refreshControl {
            table.refreshControl = refreshControl
        }
    }
    
    @objc func startUpdate() {
        receiveData()
    }
    
    
    //MARK: - Data receiving
    
    /// Taking data from the network, UI updating and error handling. The update of UI was in two steps: when brands were received and brands with models were received.
    private func receiveData() {
        refreshControl?.beginRefreshing()
        
        let group = DispatchGroup()
        group.enter()
        network.loadBrands(completion: { [weak self] (brands, error) in
            guard let self = self else { return }
            if let error = error {
                Util.addAlert(parent: self, title: "Ошибка", message: error.localizedDescription)
            }
            self.brands = brands ?? []
            self.table.reloadData()
            group.leave()
        })
        
        group.enter()
        network.loadModels(completion: { [weak self] (models, error) in
            guard let self = self else { return }
            if let error = error {
                Util.addAlert(parent: self, title: "Ошибка", message: error.localizedDescription)
            }
            self.models = models ?? []
            group.leave()
        })
        
        let modelsUpdate = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            guard let brands = self.addModels(to: self.brands, with: self.models) else { return }
            self.brands = brands
            DispatchQueue.main.async {
                self.refreshControl?.endRefreshing()
                self.table.reloadData()
            }
        }
        group.notify(queue: DispatchQueue.global(), work: modelsUpdate)
    }
    /// Adding models to existing array of brands.
    func addModels(to brands: [Brand]?, with models: [Model]?) -> [Brand]?{
        guard let brands = brands, let models = models else { return nil }
        let outBrands = brands.map{Brand(brand: $0, models: models)}
        return outBrands
    }
}


//MARK: - UITableViewDelegate, UITableViewDataSource

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        brands.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sections = brands[section].brandModels?.count ?? 0
        return sections
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: AutoModelCell.reuseId, for: indexPath) as! AutoModelCell
        let brand = brands[indexPath.section]
        let model = brand.brandModels?[indexPath.row]
        cell.set(with: model)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let brand = brands[section]
        let headerView: CellsHeaderView = CellsHeaderView.loadFromNib()
        headerView.set(with: brand)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 68.0
    }
}
