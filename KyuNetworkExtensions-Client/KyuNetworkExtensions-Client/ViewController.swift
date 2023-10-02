//
//  ViewController.swift
//  KyuNetworkExtensions-Client
//
//  swiftlint:disable no_magic_numbers
//  swiftlint:disable prohibited_interface_builder

import UIKit

class ViewController: UIViewController {
	@IBOutlet private weak var textView: UITextView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		Task {
			let mediaLibraryService = MediaLibraryService(apiKey: "INVALID_API_KEY")
			var retries = 0
			repeat {
				let date = Calendar.current.date(byAdding: .day, value: -retries, to: Date()) ?? Date()
				do {
					let apodItem = try await mediaLibraryService.getAPOD(date: date)
					self.textView.text = apodItem.description
					break
				} catch {
					self.textView.text = String(describing: error)
					retries += 1
				}
			} while retries < 5
		}
	}
}
