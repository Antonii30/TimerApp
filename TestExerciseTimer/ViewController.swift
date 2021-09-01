//
//  ViewController.swift
//  TestExerciseTimer
//
//  Created by Anton Levkin on 28.08.2021.
//

import UIKit

class ViewController: UIViewController {

    var nameTimerTextField = UITextField()
    var timerSecondTextField = UITextField()
    var addTimerButton = UIButton()
    var tableView = UITableView()
    
    var taskList: [Task] = []
    var timer: Timer?
    var countMas = 0
    var pause = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray6
        
        let screenWidth = Double(self.view.frame.size.width)
        let screenHeight = Double(self.view.frame.size.height)
        
        // MARK: - Info textField
        nameTimerTextField = UITextField(frame: CGRect(x: 20, y: 100, width: 300, height: 40))
        nameTimerTextField.font = UIFont.systemFont(ofSize: 15)
        nameTimerTextField.textColor = UIColor.black
        nameTimerTextField.borderStyle = UITextField.BorderStyle.roundedRect
        nameTimerTextField.placeholder = "Введите название таймера"
        
        // MARK: - Time textField
        timerSecondTextField = UITextField(frame: CGRect(x: 20, y: 180, width: 300, height: 40))
        timerSecondTextField.font = UIFont.systemFont(ofSize: 15)
        timerSecondTextField.textColor = UIColor.black
        timerSecondTextField.borderStyle = UITextField.BorderStyle.roundedRect
        timerSecondTextField.placeholder = "Введите время в секундах"
        
        // MARK: - TimeButton
        addTimerButton = UIButton(frame: CGRect(x: 20, y: 260, width: screenWidth - 40, height: 60))
        addTimerButton.setTitle("Добавить таймер", for: .normal)
        addTimerButton.backgroundColor = UIColor.lightGray
        addTimerButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        
        // MARK: - Timer table
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView = UITableView(frame: CGRect(x: 0, y: screenHeight / 2, width: screenWidth, height: screenHeight))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.white
        
        // MARK: - Cell
        
        tableView.register(TimerTableViewCell.self, forCellReuseIdentifier: "CustomCell")
        // MARK: - Add elemeny on view
        view.addSubview(tableView)
        view.addSubview(nameTimerTextField)
        view.addSubview(timerSecondTextField)
        view.addSubview(addTimerButton)
    }

}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - UITableViewDelegate
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let cell = tableView.cellForRow(at: indexPath) as? TimerTableViewCell else {
      return
    }
    cell.updateState()
  }

// MARK: - UITableViewDataSource
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return taskList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath)
    if let cell = cell as? TimerTableViewCell {
        if taskList.count != countMas || cell.task?.isTimerRunning != pause{
            sortCell()
            countMas = taskList.count
            if pause == false{
                pause = true
            } else {
                pause = false
            }
        }
        cell.task = taskList[indexPath.row]
    }
    return cell
  }
    
// MARK: - Actions
  @objc func buttonAction(sender: UIButton!) {
    createTimer()
    guard let info = nameTimerTextField.text else { return }
    guard let time = timerSecondTextField.text else { return }
    nameTimerTextField.text = ""
    timerSecondTextField.text = ""
    let time1 = Int(time) ?? 60
      DispatchQueue.main.async {
        let task = Task(name: info, seconds: time1)
        
        self.taskList.append(task)
        
        let indexPath = IndexPath(row: self.taskList.count - 1, section: 0)
        
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: [indexPath], with: .top)
        self.tableView.endUpdates()
      }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return (section == 0) ? "Таймеры" : nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 40
    }
    
    func createTimer() {
        if timer == nil {
            let timer = Timer(timeInterval: 1.0,
                              target: self,
                              selector: #selector(updateTimer),
                              userInfo: nil,
                              repeats: true)
            RunLoop.current.add(timer, forMode: .common)
            timer.tolerance = 0.1
            
            self.timer = timer
          }
    }
    
    func sortCell(){
        self.taskList.sort { $0.seconds > $1.seconds }
        self.tableView.reloadData()
    }
    
    @objc func updateTimer() {
        if let fireDateDescription = timer?.fireDate.description {
          print(fireDateDescription)
        }
        guard let visibleRowsIndexPaths = tableView.indexPathsForVisibleRows else {
            return
        }

        for indexPath in visibleRowsIndexPaths {
        if let cell = tableView.cellForRow(at: indexPath) as? TimerTableViewCell {
            cell.updateTimer()
        // remove Task when timer = 0
            if cell.task!.seconds < 1 {
                taskList.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
      }
    }
}


