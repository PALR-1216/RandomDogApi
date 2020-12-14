//
//  ContentView.swift
//  RandomDogApi
//
//  Created by Pedro Alejandro on 12/13/20.
//

import SwiftUI
import SDWebImageSwiftUI

struct ContentView: View {
    @ObservedObject var data = GetData()
    var body: some View {
        
        VStack{
            WebImage(url: URL(string: data.data?.message ?? ""))
                .resizable()
                .scaledToFit()
                .cornerRadius(15)
                .padding()
            
            Spacer()
            
            Button(action: {
                data.loadData()
            }, label: {
                Text("Get Random Dog")
                    .font(.title3)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct MyData: Decodable {
    var message: String
}

class GetData:ObservableObject{
    
    @Published var data : MyData?
    
    init() {
        loadData()
    }
    
    
    func loadData(){
        guard let url = URL(string: "https://dog.ceo/api/breeds/image/random") else {return}
        
        URLSession.shared.dataTask(with: url) { (data, _, err) in
            guard let data = data else{return}
            if let decodedData = try? JSONDecoder().decode(MyData.self, from: data){
                
                DispatchQueue.main.async {
                    self.data = decodedData
                }
            }
        }.resume()
    }
}
