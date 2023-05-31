//
//  ViewController.swift
//  JrAkademiProject
//
//  Created by cihad güzel on 29.05.2023.
//
import UIKit
import SnapKit
import Carbon

class HelloMessage: UIView, Component {
    private let label = UILabel()

    init(_ name: String) {
        super.init(frame: .zero)
        setupUI()
        configure(with: name)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubview(label)

        label.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview() // Ekranın ortasında hizalama
        }
    }

    private func configure(with name: String) {
        label.text = "Hellooo, \(name)!"
        label.textColor = .black
    }


    // MARK: - Component
    func render(in content: HelloMessage) {
        // Burada herhangi bir işlem yapmanıza gerek yok
    }

    func referenceSize(in bounds: CGRect) -> CGSize? {

        return bounds.size // Etiketin boyutunu belirtmek için ekran boyutunu kullanıyoruz

    }

    func renderContent() -> HelloMessage {
        return self

    }
}

class ViewController: UIViewController, UISearchBarDelegate {


    private let tableView = UITableView()
    private let cellIdentifier = "Cell"

    var isToggled = false {
        didSet { render() }

    }

    private let renderer = Renderer(
        adapter: UITableViewAdapter(),
        updater: UITableViewUpdater()
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Hello"
        tableView.contentInset.top = 44
        renderer.target = tableView

        setupUI()
        render()

    }

    func render() {
        var sections: [Section] = []
        // Create a cell item containing the HelloMessage view
        let helloCell = CellNode(id: "hello", HelloMessage("ufuk"))
        // Create a section and assign the cell item to it
        let helloSection = Section(id: "hello", cells: [helloCell])

        sections.append(helloSection)
        renderer.render(sections)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        super.touchesEnded(touches, with: event)
        isToggled.toggle()

    }


    private func setupUI() {

        // TableView ve diğer arayüz bileşenlerini burada yapılandırabilirsiniz.
        view.addSubview(tableView) // TableView'ı ekranın görünür kısmına ekleyin
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

    }

    // MARK: - UISearchBarDelegate
}


/*class ViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!


    override func viewDidLoad() {
        super.viewDidLoad()

        let frame = CGRect(x: 0, y: 0, width: 375, height: 812)
        let tableView = UITableView(frame: frame, style: .grouped)
        tableView.estimatedSectionHeaderHeight = 44
        tableView.estimatedSectionFooterHeight = 44

        // Define component


        struct Label: Identifiable, Component {

            var text: String
            var id = UUID()

            func referenceSize(in bounds: CGRect) -> CGSize? {
                return nil
            }

            func shouldContentUpdate(with next: Label) -> Bool {
                return false
            }

            func renderContent() -> UILabel {
                return UILabel()
            }

            func render(in content: UILabel) {
                content.text = text
            }
        }

        // Create renderer
        let renderer = Renderer(
            adapter: UITableViewAdapter(),
            updater: UITableViewUpdater()
        )

        renderer.target = tableView


        // Render
        renderer.render {
             /*   Label(text: "GREET")

                Label(text: "Vincent")
                Label(text: "Jules")
                Label(text: "Mia")

            Label(text: "👋 Greeting from Carbon")*/


        /*  Section(
                id: "abc",
                header: Label(text: "Header 1"),
                footer: Label(text: "Footer 1"),
                cells: {
                    Label(text: "Cell 5")
                    Label(text: "Cell 6")
            })
        */}

        view.addSubview(tableView)

    }
}*/
