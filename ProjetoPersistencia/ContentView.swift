//
//  ContentView.swift
//  ProjetoPersistencia
//
//  Created by IOS SENAC on 8/21/21.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(entity: Pessoa.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Pessoa.nome, ascending: true)])
    var pessoas: FetchedResults<Pessoa>
    
    
    @State var nome = ""
    @State var dataNascimento = Date()
    @State var email = ""
    
    var body: some View {
        TabView{
            VStack{
                TextField("Nome", text: $nome).textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                DatePicker(selection: $dataNascimento, label: { Text("Data Nascimento") })
                Button("Salvar"){
                    let pessoa = Pessoa(context: viewContext)
                    pessoa.nome = nome
                    pessoa.email = email
                    pessoa.dataNascimento = dataNascimento
                    PersistenceController.banco.save()
                }
            }.padding().tabItem { Text("Adicionar") }
            
            List{
                ForEach(pessoas){ item in
                    VStack{
                        Text("\(item.nome ?? "")")
                        if let dtNasc = item.dataNascimento{
                            Text("\(formatDate(date:  dtNasc))")
                        }
                        
                        Text("\(item.email ?? "")")
                    }
                }.onDelete(perform: deleteItems)
                
            }.padding().tabItem { Text("Lista") }
            
        }
    }
    
    private func deleteItems(at offset: IndexSet) {
        for index in offset{
            let pessoa = pessoas[index]
            PersistenceController.banco.delete(pessoa)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

func formatDate(date: Date) -> String{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM/yyyy"
    dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
    return dateFormatter.string(from: date)
}
