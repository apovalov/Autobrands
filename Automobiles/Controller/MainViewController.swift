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
    
    private var brands = [Brand]()
    private var models = [Model]()
    var network = Network()
    
    
    //MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        configureRefreshControl()
        receiveData()
    }
    
    
    //MARK: - TableView & Refreshing customization
    
    private func setupTableView() {
        let nib = UINib(nibName: "AutoModelCell", bundle: nil)
        table.register(nib, forCellReuseIdentifier: AutoModelCell.reuseId)
        table.dataSource = self
        table.delegate = self
    }
    
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
    
    
    //MARK: - Data reaceiving
    
    private func receiveData() {
        refreshControl?.beginRefreshing()
        
        let group = DispatchGroup()
        group.enter()
        network.loadBrands(completion: { [weak self] brands in
            self?.brands = brands ?? []
            self?.table.reloadData()
            group.leave()
        })
        
        group.enter()
        network.loadModels(completion: { [weak self] models in
            self?.models = models ?? []
            group.leave()
        })
        
        let modelsUpdate = DispatchWorkItem { [weak self] in
            guard let brands = addModels(brands: self?.brands, models: self?.models) else { return }
            self?.brands = brands
            self?.refreshControl?.endRefreshing()
            self?.table.reloadData()
        }
        group.notify(queue: .main, work: modelsUpdate)
    }
}


//MARK: - UITableViewDelegate, UITableViewDataSource

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        brands.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let brand = brands[section].brandModels?.count ?? 0
        return brand
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
        let headerView: CellsHeaderView = CellsHeaderView.loadFromNin()
        headerView.set(with: brand)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 68.0
    }
}
