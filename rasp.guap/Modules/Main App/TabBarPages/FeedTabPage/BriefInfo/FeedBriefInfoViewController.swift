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
            self.loadSchedule()
            self.loadDeadlines()
            self.loadNews()
        }
        
        
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
                let view = PocketBannerView(title: "Вступай в группу!", subtitle: "Узнай о новинках первым!", image: Asset.AppImages.photoPlaceholder.image)
                let div = PocketDivView(content: view)
                view.setButton(title: "Вступить") { _ in
                    div.snp.removeConstraints()
                    div.isHidden = true
                    div.snp.makeConstraints { $0.size.equalTo(CGSize.zero)}
                }
                
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
            stack.snp.makeConstraints {$0.left.right.equalToSuperview()}
            self.rootView.addBlock(title: nil, view: stack )
            
            
            stack.addArrangedSubview(PocketDivView(content:BriefHalfScreenView(title: "\(temp)°", subtitle: conditions,
                                                                               image: self.getWeatherImage(id: icon).0,
                                                                               color: self.getWeatherImage(id: icon).1)))
            
            let rocketsDiv = PocketDivView(content:BriefHalfScreenView(title: "\(rockets)",subtitle: "рокетов за неделю",
                                                                               image: Asset.AppImages.rocket.image))
            stack.addArrangedSubview(rocketsDiv)
            rocketsDiv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showRocketsModal)))
            
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
    @objc func showRocketsModal(){ self.present(RocketModalViewController(), animated: true, completion: nil) }
    
    
    
    //MARK: - Schedule
    func loadSchedule(){
        DispatchQueue.main.async { self.rootView.indicator.startAnimating() }
        guard let group = SAUserSettings.shared!.group,
              let user = SASchedule.shared.groups.get(name: group ) else {return}
        let todayUS = Calendar.current.dateComponents([.weekday], from: Date()).weekday ?? 0
        let today = Calendar.convertToRU(todayUS)
        let timetable = SASchedule.shared.get(for: user).get(week: SASchedule.shared.settings?.week ?? .odd, day: today )
        DispatchQueue.main.async {
            let timetableVC = TimetableViewController(timetable: timetable )
            timetableVC.view.isUserInteractionEnabled = false
            let div = PocketDivView(content: timetableVC.view)
            div.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.switchToShedule)))
            self.rootView.indicator.stopAnimating()
            self.rootView.addBlock(title: "Расписание на сегодня", view: div )
        }
        
    }
    @objc func switchToShedule(){ self.tabBarController?.selectedIndex = 2 }
    
    //MARK: - Deadlines
    func loadDeadlines(){
        DispatchQueue.main.async { self.rootView.indicator.startAnimating() }
        SADeadlines.shared.loadFromServer()
        let deadlines = SADeadlines.shared.nearest
        DispatchQueue.main.async {
            let deadlineListVC = DeadlineListController(list: deadlines)
            deadlineListVC.view.isUserInteractionEnabled = false
            let div = PocketDivView(content: deadlineListVC.view)
            div.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.switchToDeadlines)))
            self.rootView.indicator.stopAnimating()
            self.rootView.addBlock(title: "Ближайшие дедлайны", view: div )
        }
        
    }
    @objc func switchToDeadlines(){ self.tabBarController?.selectedIndex = 1 }
    
    //MARK: - News
    func loadNews(){
        DispatchQueue.main.async { self.rootView.indicator.startAnimating() }
        var feed = [PocketNewsView]()
        let news = SANews()
        news.loadSourceList()
        for stream in news.streams {
            stream.count = 5
            stream.reload()
            
            DispatchQueue.main.async {
                feed.append(contentsOf: stream.feed.map{self.generateNewsView(from: $0,source: stream.source.name)})
            }
        }
        
        
        
        DispatchQueue.main.async {
            let stack = UIStackView(frame: .zero)
            stack.axis = .vertical
            stack.spacing = 15
            feed.sorted { ($0.datetimeLabel.text ?? "") > ($1.datetimeLabel.text ?? "") }.forEach{
                stack.addArrangedSubview($0)
            }
            
            let div = PocketDivView(content: stack)
            
            self.rootView.indicator.stopAnimating()
            self.rootView.addBlock(title: "Актуальные новости", view: div )
        }
        
    }
    func generateNewsView(from:SAFeedElement,source:String = "") -> PocketNewsView{
        let newsView = PocketNewsView()
        newsView.authorLabel.text = source
        newsView.datetimeLabel.text = "\(from.date)"
        newsView.titleLabel.text = from.title
        
        NetworkManager.dataTask(url: from.imageURL ?? "") { (result) in
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
