//
//  PokdexViewController.swift
//  pokemongo
//
//  Created by Brian Nguyen on 2/16/23.
//  Copyright © 2023 Brian Nguyen. All rights reserved.
//

import UIKit

class PokdexViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var caughtPokemons: [Pokemon] = []
    var uncaughtPokemons: [Pokemon] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        caughtPokemons = getAllCaughtPokemons()
        uncaughtPokemons = getAllUncaughtPokemons()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        
        print("Caught: \(caughtPokemons.count)")
        print("Uncaught: \(uncaughtPokemons.count)")
        // Do any additional setup after loading the view.
    }
    
    @IBAction func BackToMapButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Caught Pokemon"
        } else {
            return "Uncaught Pokemon"
        }
    }
        
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for: indexPath)
        var pokemon : Pokemon
        if indexPath.section == 0 {
            pokemon = self.caughtPokemons[indexPath.row]
        } else {
            pokemon = self.uncaughtPokemons[indexPath.row]
        }
        
        cell.textLabel?.text = pokemon.name
        cell.imageView?.image = UIImage(named: pokemon.imageFileName!)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.caughtPokemons.count
        } else{
            return self.uncaughtPokemons.count
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
