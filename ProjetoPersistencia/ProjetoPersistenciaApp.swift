//
//  ProjetoPersistenciaApp.swift
//  ProjetoPersistencia
//
//  Created by IOS SENAC on 8/21/21.
//

import SwiftUI

@main
struct ProjetoPersistenciaApp: App {
    let persistanceController = PersistenceController.banco
    @Environment(\.scenePhase) var scenePhase
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistanceController.container.viewContext)
        }.onChange(of: scenePhase){  (newScenePhase) in
            switch newScenePhase{
                case .background:
                    persistanceController.save()
                    print("Está em background")
                case .inactive:
                    print("Esta inativo")
                case .active:
                    print("Está ativo")
                @unknown default:
                    print("Default")
            }
            
    }
    }
}
