//
//  Network+Forum.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 11/06/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import Foundation

extension Network {
	
	class func getThreads(for forumId: Int, completion: @escaping NetworkCallback) {
		let url = baseURL.appending("/threads/")
		let parameters: [String: Any] = [
			"forumId": forumId
		]
		
		call(url, httpMethod: .get, parameters: parameters, completion: completion)
	}
	
	class func createThread(_ thread: ForumThread, with post: Post, completion: @escaping NetworkCallback) {
		let url = baseURL.appending("/thread/")
		
		let dateFormatter = DateFormatter.time
		
		let parameters: [String: Any] = [
			"title": thread.title,
			"date": dateFormatter.string(from: post.date),
			"content": post.content,
			"forumId": thread.forum.forumID,
			"userId": post.user.userID
		]
		
		call(url, httpMethod: .post, parameters: parameters, completion: completion)
	}
	
	class func getPosts(for thread: ForumThread, completion: @escaping NetworkCallback) {
		let url = baseURL.appending("/thread/")
		let parameters: [String: Any] = [
			"threadId": thread.threadID
		]
		
		call(url, httpMethod: .get, parameters: parameters, completion: completion)
	}
	
	class func addPost(_ post: Post, to thread: ForumThread, completion: @escaping NetworkCallback) {
		let url = baseURL.appending("/post/")
		
		let dateFormatter = DateFormatter.time
		
		let parameters: [String: Any] = [
			"threadId": thread.threadID,
			"date": dateFormatter.string(from: post.date),
			"content": post.content,
			"userId": post.user.userID
		]
		
		call(url, httpMethod: .post, parameters: parameters, completion: completion)
	}
}
