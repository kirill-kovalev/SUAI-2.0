//
//  FeedBriefInfoViewController.swift
//  rasp.guap
//
//  Created by Кирилл on 31.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit
import SUAI_API
import SwiftyVK
import SafariServices

class FeedBriefInfoViewController: UIViewController {
    var rootView:FeedBriefInfoView {self.view as! FeedBriefInfoView}
    override func loadView() {
        self.view = FeedBriefInfoView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
		DispatchQueue.global(qos: .background).async {
			DispatchQueue.main.async { self.rootView.indicator.startAnimating() }
			self.reloadPage(needReload: true)
			DispatchQueue.main.async { self.rootView.indicator.stopAnimating() }
        }
    }
	func reloadPage(needReload:Bool = false){
		var offset:CGPoint = .zero
		if !needReload{ DispatchQueue.main.async {offset = self.rootView.contentOffset}}
		if needReload{let _ = SAUserSettings.shared.reload()}
		self.loadHello()
		
		if needReload,!SABrief.shared.loadFromServer(){ MainTabBarController.Snack(status: .err, text: "Не удалось загрузить сводку ") }
		self.loadWeatherAndRockets()
		
		
		self.loadSchedule()
		
		if needReload,!SADeadlines.shared.loadFromServer(){ MainTabBarController.Snack(status: .err, text: "Не удалось загрузить дедлайны ") }
		self.loadDeadlines()
		
		self.loadNews()
		if !needReload{ DispatchQueue.main.async {self.rootView.contentOffset = offset}}
	}
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		DispatchQueue.global(qos: .background).async {
			if SABrief.shared.loadFromServer() &&
				SADeadlines.shared.loadFromServer() &&
				SAUserSettings.shared.reload() {
				DispatchQueue.main.async {
					for view in self.rootView.stack.arrangedSubviews{
						self.rootView.stack.removeArrangedSubview(view)
						view.removeFromSuperview()
					}
				}
				
				self.reloadPage()
			}
			
        }
	}
    //MARK: - Weather
    func loadHello(){
        	
		guard let name = SAUserSettings.shared.vkName else {return }
		DispatchQueue.main.async { self.rootView.addBlock(title: "Добро пожаловать, \(name)", view: nil ) }
        if !SABrief.shared.isSub {
            DispatchQueue.main.async {
				let view = PocketBannerView(title: "Вступай в группу!", subtitle: "Узнай о новинках первым!", image: Asset.AppImages.Banners.subscribeBanner.image)
                let div = PocketDivView(content: view)
                view.setButton(title: "Вступить") { _ in
                    div.snp.removeConstraints()
                    div.isHidden = true
                    div.snp.makeConstraints { $0.size.equalTo(CGSize.zero)}
                }
                self.rootView.addBlock(title: nil, view: div )
                
                
            }
        }
        
        
    }
    
    //MARK: - Weather
	let rocketsView = BriefHalfScreenView(title: "",subtitle: "рокетов за неделю",
	image: Asset.AppImages.rocket.image)
    func loadWeatherAndRockets(){
		
        if !SABrief.shared.isSub {
            DispatchQueue.main.async { self.rootView.addBlock(title: "Погода на сегодня", view: nil ) }
        }
        let temp = SABrief.shared.weather.temp
        let icon = SABrief.shared.weather.id
        let conditions = SABrief.shared.weather.conditions
        let rockets = SABrief.shared.rockets.count
        DispatchQueue.main.async {
            let stack = UIStackView(frame: .zero)
            stack.axis = .horizontal
            stack.alignment = .fill
            stack.distribution = .fillEqually
            stack.spacing = 10
            self.rootView.addBlock(title: nil, view: stack )
            stack.snp.makeConstraints {$0.left.right.equalToSuperview()}
            
            
            stack.addArrangedSubview(PocketDivView(content:BriefHalfScreenView(title: "\(temp>0 ? "+" : "")\(Int(temp))°", subtitle: conditions,
                                                                               image: self.getWeatherImage(id: icon).0,
                                                                               color: self.getWeatherImage(id: icon).1)))
            
			let rocketsDiv = PocketDivView(content:self.rocketsView)
			self.rocketsView.title.text = "\(rockets)"
			let container = PocketScalableContainer(content: rocketsDiv)
			container.addTarget(action: { _ in
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: { self.present(RocketModalViewController(), animated: true, completion: nil) })
			}, for: .touchUpInside)
            stack.addArrangedSubview(container)
            
            
        }
    }
	func reloadRockets(){
		DispatchQueue.global().async {
			if !SABrief.shared.loadFromServer(){
				MainTabBarController.Snack(status: .err, text: "Не удалось обновить рокеты")
			}
			let rockets = SABrief.shared.rockets.count
			DispatchQueue.main.async { self.rocketsView.title.text = "\(rockets)" }
		}
	}
	
    func getWeatherImage(id:Int) -> (UIImage,UIColor){
        print(id)
        switch (true) {
              case id >= 200 && id <= 232:
                return (Asset.AppImages.WeatherImages.drizzle.image,Asset.PocketColors.buttonOutlineBorder.color)
              case id >= 300 && id <= 321:
                return (Asset.AppImages.WeatherImages.drizzle.image,Asset.PocketColors.buttonOutlineBorder.color)
              case id >= 500 && id <= 531:
                return (Asset.AppImages.WeatherImages.drizzle.image,Asset.PocketColors.buttonOutlineBorder.color)
              case id >= 600 && id <= 622:
                return (Asset.AppImages.WeatherImages.drizzle.image,Asset.PocketColors.pocketGray.color)
              case id >= 701 && id <= 781:
                return (Asset.AppImages.WeatherImages.drizzle.image,Asset.PocketColors.pocketGray.color)
              case id == 800:
                return (Asset.AppImages.WeatherImages.sunny.image,Asset.PocketColors.pocketYellow.color)
              case id == 801:
                return (Asset.AppImages.WeatherImages.clouds.image,Asset.PocketColors.buttonOutlineBorder.color)
              case id >= 802 && id <= 804:
                return (Asset.AppImages.WeatherImages.cloudy.image,Asset.PocketColors.pocketBlack.color)
              default:
                return (Asset.AppImages.WeatherImages.clouds.image,Asset.PocketColors.pocketDarkBlue.color)
        }
    }
    
    
    
    
    //MARK: - Schedule
	let timetableVC = TimetableViewController(timetable: [] )
    func loadSchedule(){
		
		func nextDay(_ cur:Int)->Int {
			if cur == 6 { return 0 }
			return cur+1
		}

        guard let group = SAUserSettings.shared.group,
              let user = SASchedule.shared.groups.get(name: group ) else {return}
        let todayUS = Calendar.current.dateComponents([.weekday], from: Date()).weekday ?? 0
        let today = Calendar.convertToRU(todayUS)
		var day = today
		var timetable:[SALesson]
		let schedule = SASchedule.shared.get(for: user)
		repeat{
			self.scheduleWeek = SASchedule.shared.settings?.week ?? .odd
			self.scheduleDay = day
			timetable = schedule.get(week: self.scheduleWeek, day: day )
			if timetable.isEmpty {
				day = nextDay(day)
			}
		}while(timetable.isEmpty)
		
		let weekdays = ["понедельник","вторник","среду","четверг","пятницу","субботу"]
        DispatchQueue.main.async {
			self.timetableVC.setTimetable(timetable: timetable)
			let div = PocketDivView(content: self.timetableVC.view)
            
			let container = PocketScalableContainer(content: div)
			container.addTarget(action: { _ in
				if let barControllers = self.tabBarController?.viewControllers,
					let vc = (barControllers[2] as? ScheduleTabViewController){
						vc.scheduleDaySelect(didUpdate: self.scheduleDay, week: self.scheduleWeek)
					}
				
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: { self.tabBarController?.selectedIndex = 2 })
			}, for: .touchUpInside)
			
			self.rootView.addBlock(title: "Расписание на \(today == day ? "сегодня" : weekdays[day] )", view: container )
        }
        
    }
	var scheduleDay = 0
	var scheduleWeek:SATimetable.Week = .odd
	func reloadSchedule(){
		func nextDay(_ cur:Int)->Int {
			if cur == 6 { return 0 }
			return cur+1
		}

		DispatchQueue.global().async {
			
			guard let group = SAUserSettings.shared.group,
				  let user = SASchedule.shared.groups.get(name: group ) else {return}
			let todayUS = Calendar.current.dateComponents([.weekday], from: Date()).weekday ?? 0
			let today = Calendar.convertToRU(todayUS)
			var day = today
			var timetable:[SALesson]
			let schedule = SASchedule.shared.load(for: user)
			repeat{
				self.scheduleWeek = SASchedule.shared.settings?.week ?? .odd
				self.scheduleDay = day
				timetable = schedule.get(week: self.scheduleWeek , day: day )

				if timetable.isEmpty {
					day = nextDay(day)
				}
			}while(timetable.isEmpty)
			
			DispatchQueue.main.async { self.timetableVC.setTimetable(timetable: timetable) }
		}
	}
    
    //MARK: - Deadlines
	let deadlineListVC = DeadlineListController(list: [])
    func loadDeadlines(){

		let deadlines = SADeadlines.shared.nearest.enumerated().filter { (index,_) in index < 5 }.map {$0.element}
        DispatchQueue.main.async {
			
			self.deadlineListVC.setItems(list: deadlines )
            let div = PocketDivView(content: self.deadlineListVC.view)
            let container = PocketScalableContainer(content: div)
			container.addTarget(action: { _ in
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: { self.tabBarController?.selectedIndex = 1 })
			}, for: .touchUpInside)
			
            self.rootView.addBlock(title: "Ближайшие дедлайны", view: container )
			self.reloadDeadlines()
        }
        
    }
	func reloadDeadlines(){
		DispatchQueue.global().async {
			if !SADeadlines.shared.loadFromServer(){
				MainTabBarController.Snack(status: .err, text: "Не удалось обновить дедлайны")
			}
			let deadlines = SADeadlines.shared.nearest.enumerated().filter { (index,_) in index < 5 }.map {$0.element}
			if !deadlines.isEmpty{
				DispatchQueue.main.async { self.deadlineListVC.setItems(list:deadlines) }
			}else{
				DispatchQueue.main.async { self.deadlineListVC.setItems(list: [SADeadline(proName:"Срочных дедлайнов нет")]) }
			}
			
		}
	}
    
    
    
    
    
    
    
    //MARK: - News
    func loadNews(){
		let feed:[SAFeedElement] = SABrief.shared.news
		
        DispatchQueue.main.async {
            let stack = UIStackView(frame: .zero)
            stack.axis = .vertical
            stack.spacing = 15
            for element in feed {
				
				let tapContainer = PocketScalableContainer(content: self.generateNewsView(from: element, source: element.source.name))
				tapContainer.addTarget(action: { _ in

					if let url = URL(string: "vk://\(element.postUrl)"){
						UIApplication.shared.open(url, options: [:], completionHandler: { success in
							if !success{ self.openPost(url: element.postUrl)}
						})
					} else { self.openPost(url: element.postUrl)}
					
				}, for: .touchUpInside)
                stack.addArrangedSubview(tapContainer)
            }
            
            let div = PocketDivView(content: stack)
            
            self.rootView.addBlock(title: "Актуальные новости", view: div )
        }
        
    }
	func openPost(url:String){
		let config = SFSafariViewController.Configuration()
		guard let url = URL(string: "https://\(url)") else {return}
		let vc = SFSafariViewController(url: url, configuration: config)
		vc.modalPresentationStyle = .popover
		self.present(vc, animated: true, completion: nil)
	}
    func generateNewsView(from element:SAFeedElement,source:String = "") -> PocketNewsView{
        let newsView = PocketNewsView()
        
        newsView.authorLabel.text = source
        newsView.titleLabel.text = element.title
        newsView.likeLabel.text = "\(element.likes)"
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "Ru")
        
        formatter.dateFormat = "dd MMMM YYYY в HH:mm"
        newsView.datetimeLabel.text = formatter.string(from: element.date)
        
        NetworkManager.dataTask(url: element.imageURL ?? "") { (result) in
            switch(result){
            case .success(let data):
                guard let image = UIImage(data: data) else{ return }
                DispatchQueue.main.async{ newsView.imageView.image = image}
                break
            case .failure: break
            }
        }
        return newsView
    }
}
