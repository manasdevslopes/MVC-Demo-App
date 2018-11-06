import UIKit

class AppleProductsTableViewController: UITableViewController
{
    lazy var productLines: [ProductLine] = {
        return ProductLine.productLines()
    }()
    
    var productShown = [Bool](repeating: false, count: ProductLine.numberOfProducts)
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = editButtonItem
        
        // Make the row height dynamic
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
 
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let productLine = productLines[section]
        return productLine.name
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return productLines.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let productLine = productLines[section]
        return productLine.products.count   // the number of products in the section
    }

    // indexPath: which section and which row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Product Cell", for: indexPath) as! ProductTableViewCell

        let productLine = productLines[indexPath.section]
        let product = productLine.products[indexPath.row]
        
        cell.configureCellWith(product)
        
        return cell
    }
    
    // MARK: - Edit Tableview
    //Delete Rows
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton = UITableViewRowAction(style: .normal, title: "Delete") { (rowAction, indexPath) in
            let alert = UIAlertController(title: "Delete", message: "Do you want to delete it?", preferredStyle: .actionSheet)
            let deleteAction = UIAlertAction(title: "Yes", style: .default ) { (action) in
                
                let productLine = self.productLines[indexPath.section]
                productLine.products.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            let cancelAction = UIAlertAction(title: "No", style: .default, handler: nil)
            alert.addAction(deleteAction)
            alert.addAction(cancelAction)
            self.present(alert,animated: true,completion: nil)
        }
        deleteButton.backgroundColor = UIColor.red
        
        let moreButton = UITableViewRowAction(style: .normal, title: "More") { (rowAction, indexPath) in
            let alert = UIAlertController(title: "Alert", message: "For ur information -> Task Acomplished", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Return", style: .default, handler: nil)
            alert.addAction(alertAction)
            self.present(alert,animated: true,completion: nil)
        }
        moreButton.backgroundColor = UIColor.blue
        
        return [deleteButton,moreButton]
    }
    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == UITableViewCellEditingStyle.delete {
//            let productLine = productLines[indexPath.section]
//            productLine.products.remove(at: indexPath.row)
//            // tell the table view to update with new data source
//            // tableView.reloadData()    //Bad way!
//            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
//        }
//    }
    
    // MARK: - Animate table view cell
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //first
        //cell.alpha = 0
        
        if productShown[indexPath.row] == false {
            
            let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, -500, 10, 0)
            cell.layer.transform = rotationTransform
            UIView.animate(withDuration: 1.0) {
                //cell.alpha = 1
                cell.layer.transform = CATransform3DIdentity
            }
            productShown[indexPath.row] = true
            
        }
    }
    // MARK: - Moving Cells
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    {
        let productToMove = productLines[sourceIndexPath.section].products[sourceIndexPath.row]
    
        // move targetedProduct to toProducts
        productLines[destinationIndexPath.section].products.insert(productToMove, at: destinationIndexPath.row)
        
        // delete the targetedProduct to fromProducts
        productLines[sourceIndexPath.section].products.remove(at: sourceIndexPath.row)
    }
    
    //Dont move the particular row to another section
    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if sourceIndexPath.section != proposedDestinationIndexPath.section {
            var row = 0
            if sourceIndexPath.section < proposedDestinationIndexPath.section {
                row = self.tableView(tableView, numberOfRowsInSection: sourceIndexPath.section) - 1
            }
            return IndexPath(row: row, section: sourceIndexPath.section)
        }
        return proposedDestinationIndexPath
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let identifier = segue.identifier {
            switch identifier {
                case "Show Detail":
                    let productDetailVC = segue.destination as! ProductDetailViewController
                    if let indexPath = self.tableView.indexPath(for: sender as! UITableViewCell) {
                        productDetailVC.product = productAtIndexPath(indexPath)
                    }
                case "Show Edit":
                    let editTableVC = segue.destination as! EditTableViewController
                    if let indexPath = self.tableView.indexPath(for: sender as! UITableViewCell) {
                        editTableVC.product = productAtIndexPath(indexPath)
                    }
                
                default: break
            }
        }
    }
    
    // MARK: - Helper Method
    
    func productAtIndexPath(_ indexPath: IndexPath) -> Product
    {
        let productLine = productLines[indexPath.section]
        return productLine.products[indexPath.row]
    }
    
}







































