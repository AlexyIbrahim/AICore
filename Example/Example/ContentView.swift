//
//  ContentView.swift
//  Example
//
//  Created by Alexy Ibrahim on 8/28/23.
//

import AICore
import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Button("in app notification", role: .none) {
                Utils.scheduleNotification(title: "Activate PTT", body: "Click here to activate PTT", delaySeconds: 1)
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
