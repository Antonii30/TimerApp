//
//  Task.swift
//  TestExerciseTimer
//
//  Created by Anton Levkin on 30.08.2021.
//

import Foundation

class Task {
    var name: String
    var seconds: Int
    var isTimerRunning = false

    init(name: String, seconds: Int) {
    self.name = name
    self.seconds = seconds
    }
}
