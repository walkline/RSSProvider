import XCTest
@testable import RSSProvider

class RSSProviderTests: XCTestCase {
    func testFetchHabrahabrFeed() {
        let expectation = super.expectation(description: "")

        let provider = RSSProvider(withSource: HabrahabrDataSource())
        
        provider.subscribeForNewFeeds {
            (feed, error) in
            
            XCTAssertNil(error)
            
			self.validateFeed(feed)
            
            expectation.fulfill()
        }
        
        super.waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testFetchDefaultFeed() {
        let expectation = super.expectation(description: "")
        
        let provider = RSSProvider(withSource: DefaultDataSource(url: URL(string: "http://feeds.bbci.co.uk/news/world/rss.xml")!))
        
        provider.subscribeForNewFeeds {
            (feed, error) in
            
            XCTAssertNil(error)
            
            self.validateFeed(feed, checkTags: false)
            
            expectation.fulfill()
        }
        
        super.waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testSubscribe() {
        let expectation = super.expectation(description: "")
        
        var callsCounter = 0
        let startDate = Date()
        
        let provider = RSSProvider(withSource: HabrahabrDataSource())
        
        provider.subscribeForNewFeeds(withInterval: 3) {
            (feed, error) in
            
            XCTAssertNil(error)
            
            self.validateFeed(feed)

            callsCounter += 1
            
            if callsCounter == 3 {
                let timeImterval = Date().timeIntervalSince(startDate)
                print(timeImterval)
                XCTAssert(timeImterval > 6.0 && timeImterval < 12.0)
                expectation.fulfill()
            }
        }
        
        super.waitForExpectations(timeout: 15, handler: nil)
    }

    static var allTests : [(String, (RSSProviderTests) -> () throws -> Void)] {
        return [
            ("testFetchHabrahabrFeed", testFetchHabrahabrFeed),
            ("testFetchDefaultFeed", testFetchDefaultFeed),
            ("testSubscribe", testSubscribe),
        ]
    }
    
    func validateFeed(_ feed: RSSFeed?, checkTags: Bool = true) {
        XCTAssertNotNil(feed)
        XCTAssertNotNil(feed?.link)
        
        XCTAssertNotEqual(feed?.title, "")
        XCTAssertNotEqual(feed?.description, "")
        XCTAssertNotEqual(feed?.pubDate, Date())
        XCTAssertNotEqual(feed?.items.count, 0)
        
        for item in feed!.items {
            XCTAssertNotNil(item.link)
            
            XCTAssertNotEqual(item.title, "")
            XCTAssertNotEqual(item.description, "")
            XCTAssertNotEqual(item.pubDate, Date())
            if checkTags {
            	XCTAssertNotEqual(item.tags.count, 0)
            } else {
                print(String(data: item.payloadData!, encoding: String.Encoding.utf8))
            }
        }
    }
}
