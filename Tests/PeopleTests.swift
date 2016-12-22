// Copyright 2016 Cisco Systems Inc
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Quick
import Nimble
import Alamofire
@testable import SparkSDK

class PeopleSpec: QuickSpec {
    
    private var me = Config.selfUser
    private var other: TestUser!
    
    private func validate(person: Person) {
        expect(person.id).notTo(beNil())
        expect(person.emails).notTo(beNil())
        expect(person.displayName).notTo(beNil())
        expect(person.created).notTo(beNil())
    }
    
    override func spec() {
        beforeSuite {
            self.other = TestUserFactory.sharedInstance.createUser()
            Spark.initWith(accessToken: self.me.token!)
        }
        
        // MARK: - List people
        
        describe("list People") {
            
            it("with emailAddress and displayName and validCount") {
                
                do {
                    let max = 10
                    let peoples = try Spark.people.list(email: self.other.email!, displayName: self.other.name!, max: max)
                    expect(peoples.count).to(equal(1))
                    self.validate(person: peoples[0])
                    expect(peoples[0].avatar).to(beNil())
                    expect(peoples[0].displayName).to(equal(self.other.name!))
                    expect(peoples[0].emails).to(contain(self.other.email!))
                    
                } catch let error as NSError {
                    fail("Failed to list people, \(error.localizedFailureReason)")
                }
            }
            
            it("with only emailAddress") {
                do {
                    let peoples = try Spark.people.list(email: self.other.email!)
                    expect(peoples.count).to(equal(1))
                    self.validate(person: peoples[0])
                    expect(peoples[0].avatar).to(beNil())
                    expect(peoples[0].displayName).to(equal(self.other.name!))
                    expect(peoples[0].emails).to(contain(self.other.email!))
                    
                } catch let error as NSError {
                    fail("Failed to list people, \(error.localizedFailureReason)")
                }
            }
            
            it("with displayName") {
                do {
                    let peoples = try Spark.people.list(email: nil, displayName: self.other.name!)
                    expect(peoples.count).to(equal(1))
                    self.validate(person: peoples[0])
                    expect(peoples[0].avatar).to(beNil())
                    expect(peoples[0].displayName).to(contain(self.other.name!))
                    
                } catch let error as NSError {
                    fail("Failed to list people, \(error.localizedFailureReason)")
                }
            }
            
            it("with displayName and maxCount") {
                do {
                    let peoples = try Spark.people.list(email: nil, displayName: self.other.name!, max: 10)
                    expect(peoples.count).to(equal(1))
                    self.validate(person: peoples[0])
                    expect(peoples[0].avatar).to(beNil())
                    expect(peoples[0].displayName).to(contain(self.other.name!))
                    
                } catch let error as NSError {
                    fail("Failed to list people, \(error.localizedFailureReason)")
                }
            }
            
            it("with email and maxCount") {
                do {
                    let peoples = try Spark.people.list(email: self.other.email!, displayName: nil, max: 10)
                    expect(peoples.count).to(equal(1))
                    self.validate(person: peoples[0])
                    expect(peoples[0].avatar).to(beNil())
                    expect(peoples[0].emails).to(contain(self.other.email!))
                    
                } catch let error as NSError {
                    fail("Failed to list people, \(error.localizedFailureReason)")
                }
            }
            
            it("with only validCount") {
                expect{try Spark.people.list(email: nil, displayName: nil, max: 10)}.to(throwError())
            }
            
            it("with emailAddress and displayName") {
                do {
                    let peoples = try Spark.people.list(email: self.other.email!, displayName: self.other.name!)
                    expect(peoples.count).to(equal(1))
                    self.validate(person: peoples[0])
                    expect(peoples[0].avatar).to(beNil())
                    expect(peoples[0].displayName).to(contain(self.other.name!))
                    
                } catch let error as NSError {
                    fail("Failed to list people, \(error.localizedFailureReason)")
                }
            }
            
            it("with nothing") {
                expect{try Spark.people.list(email: nil, displayName: nil, max: nil)}.to(throwError())
            }
            
            it("with emailAddress and displayName and invalidCount") {
                expect{try Spark.people.list(email: self.other.email!, displayName: self.other.name!, max: -1)}.to(throwError())
            }
            
            it("with emailAddress and invalidCount") {
                expect{try Spark.people.list(email: self.other.email!, displayName: nil, max: -1)}.to(throwError())
            }
            
            it("with displayName and invalidCount") {
                expect{try Spark.people.list(email: nil, displayName: self.other.name!, max: -1)}.to(throwError())
            }
            
            it("with only invalidCount") {
                expect{try Spark.people.list(email: nil, displayName: nil, max: -1)}.to(throwError())
            }
        }
        
        // MARK: - Get people
        
        describe("get") {
            it("me") {
                do {
                    let person = try Spark.people.getMe()
                    self.validate(person: person)
                    expect(person.avatar).to(beNil())
                    expect(person.displayName).to(equal(self.me.name))
                    expect(person.emails).to(contain(self.me.email!))
                    
                } catch let error as NSError {
                    fail("Failed to get people, \(error.localizedFailureReason)")
                }
            }
            
            it("with personId") {
                do {
                    let person = try Spark.people.get(personId: self.me.id!)
                    self.validate(person: person)
                    expect(person.avatar).to(beNil())
                    expect(person.displayName).to(equal(self.me.name))
                    expect(person.emails).to(contain(self.me.email!))
                    
                } catch let error as NSError {
                    fail("Failed to get people, \(error.localizedFailureReason)")
                }
                
            }
            
            it("with emptyId") {
                expect{try Spark.people.get(personId:"")}.to(throwError())
            }
            
            it("with wrongId") {
                expect{try Spark.people.get(personId:"abcd")}.to(throwError())
            }
        }
        
    }
}
