//
//  ViewController.swift
//  PayPalAppDemo
//
//  Created by Tran Anh on 7/29/17.
//  Copyright © 2017 anh. All rights reserved.
//

import UIKit



class ViewController: UIViewController, PayPalPaymentDelegate, FlipsideViewControllerDelegate {
    
    var environment:String = PayPalEnvironmentNoNetwork {
        willSet(newEnvironment) {
            if (newEnvironment != environment) {
                PayPalMobile.preconnect(withEnvironment: newEnvironment)
            }
        }
    }
    
    var resultText = "" // empty
    var payPalConfig = PayPalConfiguration() // default


    var car = ["1.jpg","2.jpg","3.jpg","4.jpg","5.jpg","6.jpg","7.jpg","8.jpg","5.jpg","6.jpg","7.jpg","8.jpg"]
    var carName = ["Lamborghini", "Drift", "Ferrari", "Hyundai","Mercedes Benz","Mitsubishi","Nissan","Volkswagen","Mercedes AMG","Mitsubishi","Nissan","Volkswagen"]
    var carPrice = ["10000$", "11000$", "10600$", "19000$","10088$","107800$","18500$","10600$","10088$","107800$","18500$","10600$"]
    
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var successView: UIView!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        successView.isHidden = true
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    //tableview delegate
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return car.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell
    {
        var cell : SampleTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SampleTableViewCell
        if(cell == nil)
        {
            cell = Bundle.main.loadNibNamed("Cell", owner: self, options: nil)?[0] as! SampleTableViewCell;
        }
        let stringTitle = carName[indexPath.row] as String //NOT NSString
        let strCarName = car[indexPath.row] as String
        let strCarPrice = carPrice[indexPath.row] as String
        cell.lblTitle.text=stringTitle
        cell.ivPhoto.image = UIImage(named: strCarName)
        cell.price.text = strCarPrice
        cell.buyButton.addTarget(self, action: #selector(buyButtonPressed), for: .touchUpInside)
        return cell as SampleTableViewCell
    }
    

    
    func buyButtonPressed(sender: UIButton) {
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: buttonPosition)
        let name = carName[indexPath!.row] as String
        let price = carPrice[indexPath!.row] as String
        let item1 = PayPalItem(name: name, withQuantity: 1, withPrice: NSDecimalNumber(string: price), withCurrency: "USD", withSku: "001")
        
        let items = [item1]
        let subtotal = PayPalItem.totalPrice(forItems: items)
        
        // Optional: include payment details
        let shipping = NSDecimalNumber(string: "5.99")
        let tax = NSDecimalNumber(string: "2.50")
        let paymentDetails = PayPalPaymentDetails(subtotal: subtotal, withShipping: shipping, withTax: tax)
        
        let total = subtotal.adding(shipping).adding(tax)
        
        let payment = PayPalPayment(amount: total, currencyCode: "USD", shortDescription: name, intent: .sale)
        
        payment.items = items
        payment.paymentDetails = paymentDetails
        
        if (payment.processable) {
            let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self)
            present(paymentViewController!, animated: true, completion: nil)
        }
        else {
            print("Payment not processalbe: \(payment)")
        }

    }
    
    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController) {
        print("PayPal Payment Cancelled")
        resultText = ""
        successView.isHidden = true
        paymentViewController.dismiss(animated: true, completion: nil)
    }
    
    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment) {
        print("PayPal Payment Success !")
        paymentViewController.dismiss(animated: true, completion: { () -> Void in
            // send completed confirmaion to your server
            print("Here is your proof of payment:\n\n\(completedPayment.confirmation)\n\nSend this to your server for confirmation and fulfillment.")
            
            self.resultText = completedPayment.description
            self.showSuccess()
        })
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "pushSettings" {
            // [segue destinationViewController] setDelegate:(id)self];
            if let flipSideViewController = segue.destination as? FlipsideViewController {
                flipSideViewController.flipsideDelegate = self
            }
        }
    }
    
    
    // MARK: Helpers
    
    func showSuccess() {
        successView.isHidden = false
        successView.alpha = 1.0
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.5)
        UIView.setAnimationDelay(2.0)
        successView.alpha = 0.0
        UIView.commitAnimations()
    }


}

