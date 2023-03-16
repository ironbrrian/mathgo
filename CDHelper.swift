//
//  CDHelper.swift
//  pokemongo
//
//  Created by Brian Nguyen on 2/27/23.
//  Copyright © 2023 Brian Nguyen. All rights reserved.
//

import CoreData
import UIKit

func makeAllPokemons(){
    makePokemon(name: "Charmander", withThe: "charmander")
    makePokemon(name: "Squirtle", withThe: "squirtle")
    makePokemon(name: "Bulbasaur", withThe: "bullbasaur")
    makePokemon(name: "Pikachu", withThe: "pikachu")
    makePokemon(name: "Dratini", withThe: "dratini")
    makePokemon(name: "Eevee", withThe: "eevee")
    makePokemon(name: "Snorlax", withThe: "snorlax")
    
    (UIApplication.shared.delegate as! AppDelegate).saveContext()
}

func makePokemon(name: String, withThe imageName: String){
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // Setting attributes
    let pokemon = Pokemon(context: context)
    pokemon.name = name
    pokemon.imageFileName = imageName
}

//query to database to bring all pokemon we created
func bringAllPokemons() -> [Pokemon]{
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    do{
        // bring all Pokemon from Database and cast as an array
        let pokemons = try context.fetch(Pokemon.fetchRequest()) as! [Pokemon]
        
        //if none, do a few things first
        if pokemons.count == 0 {
            makeAllPokemons()
            return bringAllPokemons()
        }
        return pokemons
    } catch {
        // in case action fails, print error 
        print("Cannot obtain pokemon from Core Data")
    }
    return []
}

func getAllCaughtPokemons() -> [Pokemon]{
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let fetchRequest = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
    fetchRequest.predicate = NSPredicate(format: "timesCaught > %d", 0)
    
    do{
        let pokemons = try context.fetch(fetchRequest) as [Pokemon]
        return pokemons
    } catch {
        print("Cannot obtain pokemon from Core Data")
    }
    
    return []
}

func getAllUncaughtPokemons() -> [Pokemon]{
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let fetchRequest = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
    fetchRequest.predicate = NSPredicate(format: "timesCaught == %d", 0)
    
    do{
        let pokemons = try context.fetch(fetchRequest) as [Pokemon]
        return pokemons
    } catch {
        print("Cannot obtain pokemon from Core Data")
    }
    
    return []
    
}
