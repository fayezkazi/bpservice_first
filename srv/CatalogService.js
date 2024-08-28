const cds = require("@sap/cds-dk/lib/cds");
const { convert } = require("@sap/cds/libx/_runtime/hana/execute");

// module.exports = cds.service.impl( async function() {

class BPServices extends cds.ApplicationService {

    static newItemPOS;

    init() {

        const { BusinessPartnerSet, AddressSet, OrdersSet, OrderItemsSet } = this.entities;

        //---Order Data Handling --//
            this.after('READ', OrdersSet, async orders => {
                console.log('After Order Read');

            });
            this.on('setOrderNo', async (req,res) => {
                console.log('New Order No set');
                try {
                    this.newItemPOS = 0;
                    return { overall_status : 'N', currency_code: 'USD' }
                } catch (error) {
                   return "Error" + error.toString(); 
                }
            });

            function setOrder(OrdersSet) {
               console.log('Function Trigger'); 
            }


        //---Order Data Handling --//
        // ---Begin This is to Calculate Tax for Order Items >>
        this.after('READ', OrderItemsSet, async Items => {
            try {
                console.log("After Items Read");
                var ItemPOS;
                this.newItemPOS = 0;
                for (let index = 0; index < Items.length; index++) {
                    if (isNaN(ItemPOS)) {
                        ItemPOS = Items[index].OrderItemPos;
                    } else {
                        if (Items[index].OrderItemPos > ItemPOS) {
                            ItemPOS = Items[index].OrderItemPos;
                        }
                    }
                }
                if (!isNaN(ItemPOS)) {
                    this.newItemPOS = ItemPOS + 10;
                } else {
                    this.newItemPOS = 10;
                }

            } catch (error) {
                return "Error " + error.toString();
            }
        });

        this.after(['UPDATE', 'CREATE'], BusinessPartnerSet, async req => {
            try {
                this.newItemPOS = 0;
                console.log("After BP Update");
                var TotalSellAmount = parseFloat('000.00');
                var TotalOrderAmount = parseFloat('000.00');
                var TotalItemAmount = parseFloat('000.00');
                var TotalOrderTaxAmount = parseFloat('000.00');
                var TotalItemTaxAmount = parseFloat('000.00');               
                var ChangeFlag = '';
                const OrderHSet = req.orders;
                for (let index = 0; index < OrderHSet.length; index++) {
                    const OrderH = OrderHSet[index];                    
                    if (!isNaN(parseFloat(OrderH.gross_amount))) {
                        TotalOrderAmount = TotalOrderAmount + parseFloat(OrderH.gross_amount);                        
                    }
                    OrderH.Items.forEach(element => {
                        var netAmount = parseFloat(element.net_amount);
                        if (!isNaN(netAmount)) {
                            TotalItemAmount = TotalItemAmount + netAmount;
                            TotalOrderTaxAmount = TotalOrderTaxAmount + parseFloat(element.tax_amount);
                        }
                    });
                    if (TotalOrderAmount !== TotalItemAmount) {
                        TotalOrderAmount = TotalItemAmount;
                        ChangeFlag = 'X';
                    }
                    TotalSellAmount = TotalSellAmount + TotalOrderAmount;
                    if (ChangeFlag == 'X') {
                        await UPDATE(OrdersSet).with({
                            gross_amount: TotalOrderAmount.toString(),
                            tax_amount: TotalOrderTaxAmount.toString()
                        }).where({ ID: OrderH.ID });
                    }
                    TotalItemAmount = parseFloat('000.00');
                    TotalOrderAmount = parseFloat('000.00');
                    TotalOrderTaxAmount = parseFloat('000.00');

                }
                if (TotalSellAmount !== parseFloat(req.Total_Sell_Amount)) {
                    await UPDATE(BusinessPartnerSet).with({
                        Total_Sell_Amount: TotalSellAmount.toString()
                    }).where({ ID: req.ID });
                }

                console.log('Data Updated');

            } catch (error) {
                return "Error " + error.toString();
            }
        });

        this.on('calItemTax', async req => {
            console.log('Tax Calculation');
            try {
                var tax_amount;
                var order_tax_amount = parseFloat('0.00');
                const orderID = req.params[1].ID;
                const itemID = req.params[2].ID;
                const tx = cds.tx(req);
                // const item = await tx.read(OrderItemsSet).where({ Parent_Key_ID: orderID });
                const item = await tx.read(req.target).where({ Parent_Key_ID: orderID });
                item.forEach(element => {
                    if (element.ID == itemID) {
                        tax_amount = (parseFloat(element.net_amount) * 5) / 100;
                        order_tax_amount = order_tax_amount + tax_amount;
                    } else {
                        if (!isNaN(parseFloat(element.tax_amount))) {
                            order_tax_amount = order_tax_amount + parseFloat(element.tax_amount);
                        }
                    }
                });

                if (!isNaN(tax_amount)) {
                    // const CurrentItem = await tx.read(req.target).where({ID: itemID});
                    // CurrentItem.forEach(element => {
                    //     tax_amount = (parseFloat(element.net_amount) * 5) / 100; 
                    // });
                    

                    await UPDATE(req.target).with({
                        tax_amount: tax_amount.toString()
                    }).where({ID: itemID});
                } 
                // else {
                //     await tx.update(OrderItemsSet).with({
                //         tax_amount: tax_amount.toString()
                //     }).where({ ID: itemID }); 
                // }



                await tx.update(OrdersSet).with({
                    tax_amount: order_tax_amount.toString()
                }).where({ID: orderID})
            } catch (error) {
                return "Error " + error.toString();
            }
        })
        //  ---End of Calculate Tax for Order Items -- //    

        this.on('setDefaultAddress', async req => {
            await UPDATE(req.target).with({
                DefaultAddr: 'X'
            })
        });

        this.on('removeDefaultAddress', async req => {
            await UPDATE(req.target).with({
                DefaultAddr: ''
            })
        });

        this.on('setBPID', async (req, res) => {
            try {
                // const ID = req.data.ID;
                const tx = cds.tx(req);
                const BPSet = await tx.read(BusinessPartnerSet).orderBy({
                    BPID: 'desc'
                }).limit(1);
                const maxID = parseInt(BPSet[0].BPID) + 1;
                console.log("Nax BP ID: " + maxID);
                return { BPID: String(maxID) };
            } catch (error) {
                return "Error " + error.toString();
            }
        });

        this.on('setOrderItemID', async (req, res) => {
            try {
                console.log("Nax BP ID: " + this.newItemPOS);
                const ItemPOS = this.newItemPOS;                
                var itemno = 0;
                if (isNaN(ItemPOS)) {
                    itemno = 10;  
                    this.newItemPOS = itemno + 10;
                } else {
                    itemno = ItemPOS;
                    this.newItemPOS = ItemPOS + 10;
                }
                if (itemno == 0) {
                    itemno = 10;
                    this.newItemPOS = itemno + 10;
                }
                return { OrderItemPos: itemno };
            } catch (error) {
                return "Error " + error.toString();
            }
        });

        return super.init();
    }
};

module.exports = BPServices;