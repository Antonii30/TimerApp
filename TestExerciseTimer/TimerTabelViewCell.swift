//
//  TimerTabelViewCell.swift
//  TestExerciseTimer
//
//  Created by Anton Levkin on 30.08.2021.
//

import UIKit

class TimerTableViewCell: UITableViewCell {
    
    let infoLabel:UILabel = {
            let label = UILabel()
            label.font = UIFont.boldSystemFont(ofSize: 15)
            label.textColor = .black
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
    
    let timerLabel:UILabel = {
            let label = UILabel()
            label.font = UIFont.boldSystemFont(ofSize: 15)
            label.textColor = .black
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
    
    var task: Task? {
      didSet {
        infoLabel.text = task?.name
        timerLabel.text = String(format: "", task!.seconds )
        setState()
        updateTimer()
      }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(infoLabel)
        self.contentView.addSubview(timerLabel)
        
        infoLabel.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true
        infoLabel.leadingAnchor.constraint(equalTo:self.contentView.leadingAnchor, constant:10).isActive = true
        infoLabel.widthAnchor.constraint(equalToConstant:60).isActive = true
        infoLabel.heightAnchor.constraint(equalToConstant:20).isActive = true
        
        timerLabel.widthAnchor.constraint(equalToConstant:150).isActive = true
        timerLabel.heightAnchor.constraint(equalToConstant:20).isActive = true
        timerLabel.trailingAnchor.constraint(equalTo:self.contentView.trailingAnchor, constant: -10).isActive = true
        timerLabel.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true
        timerLabel.textAlignment = .right
        
    }
    
    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    
    
    func updateState() {
      guard let task = task else {
        return
      }
      
      task.isTimerRunning.toggle()
      
      setState()
      updateTimer()
    }
    
    func updateTimer() {
      guard let task = task else {
        return
      }
      if task.isTimerRunning {
        timerLabel.text = "Pause"
      } else {
            task.seconds -= 1
            timerLabel.text = timeString(time: TimeInterval(task.seconds))
            //timerLabel.text = String(task.seconds)
            print("\(task.seconds)")
            //            labelButton.setTitle(timeString(time: TimeInterval(seconds)), for: UIControlState.normal)
        }
      }
    
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        var times: [String] = []
        if hours > 0 {
          times.append("\(hours)h")
        }
        if minutes > 0 {
          times.append("\(minutes)m")
        }
        times.append("\(seconds)s")
        
        return String(times.joined(separator: " "))
    }
    
    private func setState() {
      guard let task = task else {
        return
      }
      
      if task.isTimerRunning {
     infoLabel.attributedText = NSAttributedString(string: task.name,
          attributes: [.strikethroughStyle: 1])
      } else {
     infoLabel.attributedText = NSAttributedString(string: task.name,
          attributes: nil)
      }
    }
}
