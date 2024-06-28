//
//  HomeTabBarViewController.swift
//  Family Trivia
//
//  Created by Chris Voronin on 4/19/19.
//  Copyright © 2019 Chris Voronin. All rights reserved.
//

import UIKit

class HomeTabBarViewController: UITabBarController {

/**
 
 1    A Series Of Unfortunate Events
 10    70's 80's and 90's
 20    Bible & Jesus Christ
 30    Citizenship
 40    Civil War
 49    4th Of July
 50    Christmas
 51    Cinco De Mayo
 52    Easter
 53    Fathers Day
 54    Halloween
 55    MLK Day
 56    Mothers Day
 57    Presidents Day
 58    Thanksgiving
 59    Valentines Day
 60    Veterans Day
 70    Star Wars
 71    Hunger Games
 72    Disney Movies
 73    Twilight Saga
 80    World War 2
 90    Wine
 100    Baby Shower
 101    International Womens Day
 102    Diwali
 
 */


    //TODO: Break out movies into it's own cats by movie.
    //TODO: fix culture, maybe remove unnecessary stuff.
    //Update DAO to be async.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let holidays = CategoryListViewController.create(title: "Holidays", cats: [50, 51, 104, 52, 53, 54, 49, 55, 103, 56, 57, 58, 59, 60, 101, 102])
        let movies = CategoryListViewController.create(title: "Movies", cats: [1, 70, 105, 71, 72, 73])
        let wars = CategoryListViewController.create(title: "Wars", cats: [80, 40])
        let misc = CategoryListViewController.create(title: "Culture", cats: [20, 100, 10, 30, 90])
        let myGames = CreateGameViewController.create()
        //let search = SearchForGamesViewController.packagedSearchController()
        
        let vcList = [holidays, movies, wars, misc, myGames]
        self.setViewControllers(vcList, animated: false)
        
        //Holidays - 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60
        //Movies - 1, 10, 20, 30, 70
        //Wars - 80, 40
        //Misc - 90, 100, 30
        //My Games
        //Search
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        print("prep")
    }

}
