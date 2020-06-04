//
//  CarplaySceneDelegate.swift
//  CarPlaySample
//
//  Created by Watanabe Toshinori on 2020/05/29.
//  Copyright © 2020 Watanabe Toshinori. All rights reserved.
//

import UIKit
import SwiftUI
import CarPlay

class CarplaySceneDelegate: UIResponder, CPTemplateApplicationSceneDelegate {

    private var carplayInterfaceController: CPInterfaceController?

    func templateApplicationScene(_ templateApplicationScene: CPTemplateApplicationScene, didConnect interfaceController: CPInterfaceController, to window: CPWindow) {
        // Background of CPMapTemplate
        let contentView = CarPlayContentView()
        window.rootViewController = UIHostingController(rootView: contentView)

        // Retain the intent to add or remove templates later.
        carplayInterfaceController = interfaceController

        grid()
    }

    // MARK: - CPTemplates

    private func grid() {
        let template = CPGridTemplate(title: "Template List", gridButtons: [
            CPGridButton(titleVariants: ["Map"], image: UIImage(systemName: "map")!, handler: map(_:)),
            CPGridButton(titleVariants: ["List"], image: UIImage(systemName: "list.dash")!, handler: list(_:)),
            CPGridButton(titleVariants: ["Search"], image: UIImage(systemName: "magnifyingglass")!, handler: search(_:)),
            CPGridButton(titleVariants: ["Action"], image: UIImage(systemName: "square.and.arrow.up")!, handler: action(_:)),
            CPGridButton(titleVariants: ["Alert"], image: UIImage(systemName: "exclamationmark.triangle")!, handler: alert(_:)),
            CPGridButton(titleVariants: ["Siri"], image: UIImage(systemName: "waveform.circle")!, handler: siri(_:)),
        ])

        carplayInterfaceController?.setRootTemplate(template, animated: true)
    }

    private func map(_ button: CPGridButton) {
        let template = CPMapTemplate()
        template.mapDelegate = self

        carplayInterfaceController?.pushTemplate(template, animated: true)
    }

    private func list(_ button: CPGridButton) {
        let template = CPListTemplate(title: "List", sections: [
            CPListSection(items: [
                CPListItem(text: "Text", detailText: ""),
                CPListItem(text: "Text", detailText: "", image: UIImage(systemName: "suit.heart")),
                CPListItem(text: "Text", detailText: "", image: nil, showsDisclosureIndicator: true),
                CPListItem(text: "Text", detailText: "", image: UIImage(systemName: "suit.heart"), showsDisclosureIndicator: true),
                CPListItem(text: "Text", detailText: "Detail"),
                CPListItem(text: "Text", detailText: "Detail", image: UIImage(systemName: "suit.heart")),
                CPListItem(text: "Text", detailText: "Detail", image: nil, showsDisclosureIndicator: true),
                CPListItem(text: "Text", detailText: "Detail", image: UIImage(systemName: "suit.heart"), showsDisclosureIndicator: true),
            ])
        ])
        template.delegate = self

        carplayInterfaceController?.pushTemplate(template, animated: true)
    }

    private func search(_ button: CPGridButton) {
        let template = CPSearchTemplate()
        template.delegate = self

        carplayInterfaceController?.pushTemplate(template, animated: true)
    }

    private func action(_ button: CPGridButton) {
        let template = CPActionSheetTemplate(title: "This is sample action sheet", message: nil, actions: [
            CPAlertAction(title: "OK", style: .default, handler: { (action) in
                print("OK")
            }),
            CPAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                print("Cancel")
            }),
        ])

        carplayInterfaceController?.presentTemplate(template, animated: true)
    }

    private func alert(_ button: CPGridButton) {
        let template = CPAlertTemplate(titleVariants: ["This is sample alert."], actions: [
            CPAlertAction(title: "OK", style: .default, handler: { [weak self] (action) in
                print("OK")
                self?.carplayInterfaceController?.dismissTemplate(animated: true)
            }),
            CPAlertAction(title: "Cancel", style: .cancel, handler: { [weak self] (action) in
                print("Cancel")
                self?.carplayInterfaceController?.dismissTemplate(animated: true)
            }),
        ])

        carplayInterfaceController?.presentTemplate(template, animated: true)
    }

    private func siri(_ button: CPGridButton) {
        let template = CPVoiceControlTemplate(voiceControlStates: [
            CPVoiceControlState(identifier: "identifier", titleVariants: ["Test"], image: nil, repeats: true)
        ])

        carplayInterfaceController?.presentTemplate(template, animated: true)
    }

}

// MARK: - CPTemplate delegates

extension CarplaySceneDelegate: CPMapTemplateDelegate {

}

extension CarplaySceneDelegate: CPSearchTemplateDelegate {

    func searchTemplate(_ searchTemplate: CPSearchTemplate, updatedSearchText searchText: String, completionHandler: @escaping ([CPListItem]) -> Void) {
        print(searchText)

        completionHandler([
            CPListItem(text: searchText, detailText: "")
        ])
    }

    func searchTemplate(_ searchTemplate: CPSearchTemplate, selectedResult item: CPListItem, completionHandler: @escaping () -> Void) {
        print(item.text)

        completionHandler()
    }

}

extension CarplaySceneDelegate: CPListTemplateDelegate {

    func listTemplate(_ listTemplate: CPListTemplate, didSelect item: CPListItem, completionHandler: @escaping () -> Void) {
        let template = CPActionSheetTemplate(title: "Title", message: "Message", actions: [CPAlertAction(title: "title", style: .default, handler: { (action) in

        })])

        carplayInterfaceController?.presentTemplate(template, animated: true)

        // Dismiss indicator
        completionHandler()
    }

}
