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
            self.loadHello()
            self.loadWeatherAndRockets()
            self.loadDeadlines()
            self.loadNews()
        }
        
        
    }
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		reloadDeadlines()
		reloadSchedule()
	}
    //MARK: - Weather
    func loadHello(){
        struct vkResponse:Codable{
            let last_name: String
            let first_name: String
        }
        
        do{
            guard let data = try VK.API.Users.get([.fields:"first_name"]).synchronously().send() else { return}
            let resp = try JSONDecoder().decode([vkResponse].self, from: data)
            DispatchQueue.main.async { self.rootView.addBlock(title: "Добро пожаловать, \(resp[0].first_name) \(resp[0].last_name)", view: nil ) }
        }catch {}
        
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
    func loadWeatherAndRockets(){
        SABrief.shared.loadFromServer()
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
            
            let rocketsDiv = PocketDivView(content:BriefHalfScreenView(title: "\(rockets)",subtitle: "рокетов за неделю",
                                                                               image: Asset.AppImages.rocket.image))
			let container = PocketScalableContainer(content: rocketsDiv)
			container.addTarget(action: { _ in
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: { self.present(RocketModalViewController(), animated: true, completion: nil) })
			}, for: .touchUpInside)
            stack.addArrangedSubview(container)
            
            
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
		
        DispatchQueue.main.async { self.rootView.indicator.startAnimating() }
        guard let group = SAUserSettings.shared!.group,
              let user = SASchedule.shared.groups.get(name: group ) else {return}
        let todayUS = Calendar.current.dateComponents([.weekday], from: Date()).weekday ?? 0
        let today = Calendar.convertToRU(todayUS)
		var day = today
		var timetable:[SALesson]
		repeat{
			timetable = SASchedule.shared.get(for: user).get(week: SASchedule.shared.settings?.week ?? .odd, day: day )
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
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: { self.tabBarController?.selectedIndex = 2 })
			}, for: .touchUpInside)
			
            self.rootView.indicator.stopAnimating()
			self.rootView.addBlock(title: "Расписание на \(today == day ? "сегодня" : weekdays[day] )", view: container )
        }
        
    }
	func reloadSchedule(){
		func nextDay(_ cur:Int)->Int {
			if cur == 6 { return 0 }
			return cur+1
		}

		DispatchQueue.global().async {
			
			guard let group = SAUserSettings.shared?.group,
				  let user = SASchedule.shared.groups.get(name: group ) else {return}
			let todayUS = Calendar.current.dateComponents([.weekday], from: Date()).weekday ?? 0
			let today = Calendar.convertToRU(todayUS)
			var day = today
			var timetable:[SALesson]
			repeat{
				timetable = SASchedule.shared.get(for: user).get(week: SASchedule.shared.settings?.week ?? .odd, day: day )
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
        DispatchQueue.main.async { self.rootView.indicator.startAnimating() }
        let deadlines = SADeadlines.shared.nearest
        DispatchQueue.main.async {
			self.deadlineListVC.setItems(list: deadlines)
            let div = PocketDivView(content: self.deadlineListVC.view)
            let container = PocketScalableContainer(content: div)
			container.addTarget(action: { _ in
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: { self.tabBarController?.selectedIndex = 1 })
			}, for: .touchUpInside)
			
            self.rootView.indicator.stopAnimating()
            self.rootView.addBlock(title: "Ближайшие дедлайны", view: container )
        }
        
    }
    @objc func switchToDeadlines(){ self.tabBarController?.selectedIndex = 1 }
	func reloadDeadlines(){
		DispatchQueue.global().async {
			let deadlines = SADeadlines.shared.nearest
			DispatchQueue.main.async { self.deadlineListVC.setItems(list: deadlines) }
		}
	}
    
    
    
    
    
    
    
    //MARK: - News
    func loadNews(){
        DispatchQueue.main.async { self.rootView.indicator.startAnimating() }
        var feed:[(SAFeedElement,FeedSource)] = []
        let news = SANews()
        news.loadSourceList()
        for stream in news.streams {
            stream.count = 5
            stream.reload()
            
            
            feed.append(contentsOf: stream.feed.map{($0,stream.source)})
            
        }
        
        
        
        DispatchQueue.main.async {
            let stack = UIStackView(frame: .zero)
            stack.axis = .vertical
            stack.spacing = 15
            let sorted = feed.sorted {  $0.0.date > $1.0.date}
            for (element,source) in sorted {
				let tapContainer = PocketScalableContainer(content: self.generateNewsView(from: element, source: source.name))
				tapContainer.addTarget(action: { _ in
					let config = SFSafariViewController.Configuration()
					print("url: \(element.postUrl)")
					guard let url = URL(string: element.postUrl) else {return}
					let vc = SFSafariViewController(url: url, configuration: config)
					vc.modalPresentationStyle = .popover
					self.present(vc, animated: true, completion: nil)
				}, for: .touchUpInside)
                stack.addArrangedSubview(tapContainer)
            }
            
            let div = PocketDivView(content: stack)
            
            self.rootView.indicator.stopAnimating()
            self.rootView.addBlock(title: "Актуальные новости", view: div )
        }
        
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
