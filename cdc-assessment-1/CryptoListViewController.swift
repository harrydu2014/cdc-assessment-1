//
//  CryptoListViewController.swift
//  cdc-assessment-1
//
//  Created by Harry, Du on 2024/11/17.
//

import UIKit

class CryptoListViewController: UIViewController {

    private var cryptoModels: [CryptoModel] = []
    
    private let loadButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Load Crypto", for: .normal)
        button.setTitleColor(UIColor(red: 24/255.0, green: 98/255.0, blue: 182/255.0, alpha: 1.0), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let cryptoImageView: UIImageView = {
       let imageView = UIImageView()
       imageView.translatesAutoresizingMaskIntoConstraints = false
       imageView.contentMode = .scaleAspectFit
       return imageView
   }()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        cryptoImageView.image = UIImage(named: "Crypto")
        loadButton.addTarget(self, action: #selector(loadCrypto), for: .touchUpInside)
    }
    
    private func setupLayout() {
        view.addSubview(cryptoImageView)
        view.addSubview(loadButton)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            
            cryptoImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            cryptoImageView.bottomAnchor.constraint(equalTo: loadButton.topAnchor, constant: -20),
            cryptoImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
            cryptoImageView.heightAnchor.constraint(equalTo: cryptoImageView.widthAnchor, multiplier: 0.5),
            
            loadButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            loadButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            loadButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            loadButton.heightAnchor.constraint(equalToConstant: 100),

            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CryptoCell")
        tableView.isHidden = true
    }

    @objc private func loadCrypto() {
        guard let url = Bundle.main.url(forResource: "crypto_list", withExtension: "json") else {
            showErrorAlert()
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            cryptoModels = try decoder.decode([CryptoModel].self, from: data)
            tableView.reloadData()
            loadButton.isHidden = !cryptoModels.isEmpty
            tableView.isHidden = cryptoModels.isEmpty
        } catch {
            showErrorAlert()
        }
    }
    
    private func showErrorAlert() {
        let alert = UIAlertController(title: "Load Crypto With Error", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension CryptoListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cryptoModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CryptoCell", for: indexPath)
        cell.textLabel?.text = cryptoModels[indexPath.row].title
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = CryptoDetailViewController()
        detailVC.modalPresentationStyle = .fullScreen
        present(detailVC, animated: true, completion: nil)
    }
}
