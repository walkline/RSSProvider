import Foundation

open class RSSProvider {
    public private(set) var dataSource: DataSourceProtocol
    
    public init(withSource source: DataSourceProtocol) {
		self.dataSource = source
    }

    public typealias NewFeedCompletion = (RSSFeed?, Error?) -> Void
    open func subscribeForNewFeeds(withInterval interval: TimeInterval = 3600.0 /* One hour */, newFeedCompletion: @escaping NewFeedCompletion) {
        self.dataSource.fetch { [weak self] (feed, error) in
            newFeedCompletion(feed, error)
            
            guard error == nil else {
                self?.feedUpdateTimer?.suspend()
                return
            }
            
            self?.newFeedCompletion = newFeedCompletion
            self?.startFeedUpdateTimer(withInterval: interval)
        }
    }
    
    fileprivate var newFeedCompletion: NewFeedCompletion?
    fileprivate var feedUpdateTimer: SwiftTimer?
    fileprivate var lastFeed: RSSFeed?
    
    open func startFeedUpdateTimer(withInterval interval: TimeInterval) {
        self.feedUpdateTimer?.suspend()

        
        self.feedUpdateTimer = SwiftTimer.repeaticTimer(interval: .milliseconds(Int(interval * 1000))) { [weak self] (_) in
            self?.fetchDataFromDataSource()
        }
        
        self.feedUpdateTimer?.start()
    }

	@objc open func fetchDataFromDataSource() {
        self.dataSource.fetch { [weak self] (feed, error) in
            guard let completion = self?.newFeedCompletion else {
                self?.lastFeed = nil
                return
            }
            
            guard error == nil else {
                self?.lastFeed = nil
                completion(feed, error)
                return
            }
            
            if self?.lastFeed?.pubDate != feed?.pubDate {
                completion(feed, error)
            }
            
            self?.lastFeed = feed
        }
    }
}
