//
//  ViewController.swift
//  KyuNetworkExtensions-Client
//
//  swiftlint:disable no_magic_numbers
//  swiftlint:disable prohibited_interface_builder

import UIKit

class ViewController: UIViewController {
	@IBOutlet private weak var objectTextView: UITextView!
	@IBOutlet private weak var objectsTextView: UITextView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Object
		Task {
			let mediaLibraryService = MediaLibraryService(apiKey: "INVALID_API_KEY")
			var retries = 0
			repeat {
				let date = Calendar.current.date(byAdding: .day, value: -retries, to: Date()) ?? Date()
				do {
					let apodItem = try await mediaLibraryService.getAPOD(date: date)
					self.objectTextView.text = String(describing: apodItem)
					break
				} catch {
					self.objectTextView.text = String(describing: error)
					retries += 1
				}
			} while retries < 5
		}
		
		// [Object]
		Task {
			do {
				let toDate = Date()
				let fromDate = Calendar.current.date(byAdding: .day, value: -7, to: toDate) ?? toDate
				
				let mediaLibraryService = MediaLibraryService(apiKey: "INVALID_API_KEY")
				let apodItems = try await mediaLibraryService.getAPODList(fromDate: fromDate, toDate: toDate)
				self.objectsTextView.text = String(describing: apodItems)
			} catch {
				self.objectsTextView.text = String(describing: error)
			}
		}
	}
}
