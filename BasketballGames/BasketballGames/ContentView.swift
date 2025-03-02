//
//  ContentView.swift
//  Basketball
//
//  Created by Samuel Shi on 2/27/25.
//

import SwiftUI

struct Game: Identifiable, Codable {
    let id: Int
    let date: String
    let opponent: String
    let isHomeGame: Bool
    let team: String
    let score: Score
}

struct Score: Codable {
    let unc: Int
    let opponent: Int
}

struct ContentView: View {
    @State private var games: [Game] = []
    
    var body: some View {
        NavigationView {
            List {
                ForEach(games) { game in
                    HStack{
                        VStack(alignment: .leading){
                            Text("\(game.team) vs \(game.opponent)")
                                .fontWeight(.semibold)
                            Text(game.date)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        VStack(alignment: .trailing){
                            Text("\(game.score.unc) - \(game.score.opponent)")
                                .fontWeight(.semibold)
                            Text(game.isHomeGame ? "Home" : "Away")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            
                        }
                    }
                }
            }
            .navigationBarTitle("UNC Basketball")
            .onAppear()
            {
                Task{
                    await getGames()
                }
            }
        }
        
    }
    func getGames() async {
        guard let url = URL(string: "https://api.samuelshi.com/uncbasketball") else {
            print("Invalid URL")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let games = try JSONDecoder().decode([Game].self, from: data)
            self.games = games
        } catch {
            print("Error fetching data: \(error)")
        }
    }
}



#Preview {
    ContentView()
}
